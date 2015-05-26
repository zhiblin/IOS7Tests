//
//  LoaerTwitterCollectionViewFlowLayout.m
//  IOS7Tests
//
//  Created by lzb on 15/5/26.
//  Copyright (c) 2015年 loaer. All rights reserved.
//

#import "LoaerTwitterCollectionViewFlowLayout.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#ifndef CGGEOMETRY_LoaerSUPPORT_H_
CG_INLINE CGPoint
Loaer_CGPointAdd(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}
#endif

typedef NS_ENUM(NSInteger, LoaercrollingDirection) {
    LoaercrollingDirectionUnknown = 0,
    LoaercrollingDirectionUp,
    LoaercrollingDirectionDown,
    LoaercrollingDirectionLeft,
    LoaercrollingDirectionRight
};

static NSString * const kLoaercrollingDirectionKey = @"LoaercrollingDirection";
static NSString * const kLoaerCollectionViewKeyPath = @"collectionView";

@interface CADisplayLink (Loaer_userInfo)
@property (nonatomic, copy) NSDictionary *Loaer_userInfo;
@end

@implementation CADisplayLink (Loaer_userInfo)
- (void) setLoaer_userInfo:(NSDictionary *) Loaer_userInfo {
    objc_setAssociatedObject(self, "Loaer_userInfo", Loaer_userInfo, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *) Loaer_userInfo {
    return objc_getAssociatedObject(self, "Loaer_userInfo");
}
@end

@interface UICollectionViewCell (LoaerTwitterCollectionViewFlowLayout)

- (UIView *)Loaer_snapshotView;

@end

@implementation UICollectionViewCell (LoaerTwitterCollectionViewFlowLayout)

- (UIView *)Loaer_snapshotView {
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        return [self snapshotViewAfterScreenUpdates:YES];
    } else {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0f);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return [[UIImageView alloc] initWithImage:image];
    }
}

@end

@interface LoaerTwitterCollectionViewFlowLayout ()

@property (strong, nonatomic) NSIndexPath *selectedItemIndexPath;
@property (strong, nonatomic) UIView *currentView;
@property (strong, nonatomic) UIView *deleteView;
@property (assign, nonatomic) CGPoint currentViewCenter;
@property (assign, nonatomic) CGPoint panTranslationInCollectionView;
@property (strong, nonatomic) CADisplayLink *displayLink;

@property (assign, nonatomic, readonly) id<LoaerTwitterCollectionViewDataSource> dataSource;
@property (assign, nonatomic, readonly) id<LoaerTwitterCollectionViewDelegateFlowLayout> delegate;

@end

@implementation LoaerTwitterCollectionViewFlowLayout

- (void)setDefaults {
    _scrollingSpeed = 300.0f;
    _scrollingTriggerEdgeInsets = UIEdgeInsetsMake(50.0f, 50.0f, 50.0f, 50.0f);
}

- (void)setupCollectionView {
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleLongPressGesture:)];
    _longPressGestureRecognizer.delegate = self;

    // Links the default long press gesture recognizer to the custom long press gesture recognizer we are creating now
    // by enforcing failure dependency so that they doesn't clash.
    for (UIGestureRecognizer *gestureRecognizer in self.collectionView.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [gestureRecognizer requireGestureRecognizerToFail:_longPressGestureRecognizer];
        }
    }

    [self.collectionView addGestureRecognizer:_longPressGestureRecognizer];

    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(handlePanGesture:)];
    _panGestureRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:_panGestureRecognizer];

    // Useful in multiple scenarios: one common scenario being when the Notification Center drawer is pulled down
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationWillResignActive:) name: UIApplicationWillResignActiveNotification object:nil];
}

- (void)tearDownCollectionView {
    // Tear down long press gesture
    if (_longPressGestureRecognizer) {
        UIView *view = _longPressGestureRecognizer.view;
        if (view) {
            [view removeGestureRecognizer:_longPressGestureRecognizer];
        }
        _longPressGestureRecognizer.delegate = nil;
        _longPressGestureRecognizer = nil;
    }

    // Tear down pan gesture
    if (_panGestureRecognizer) {
        UIView *view = _panGestureRecognizer.view;
        if (view) {
            [view removeGestureRecognizer:_panGestureRecognizer];
        }
        _panGestureRecognizer.delegate = nil;
        _panGestureRecognizer = nil;
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (id)init {
    self = [super init];
    if (self) {
        [self setDefaults];
        [self addObserver:self forKeyPath:kLoaerCollectionViewKeyPath options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaults];
        [self addObserver:self forKeyPath:kLoaerCollectionViewKeyPath options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc {
    [self invalidatesScrollTimer];
    [self tearDownCollectionView];
    [self removeObserver:self forKeyPath:kLoaerCollectionViewKeyPath];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    if ([layoutAttributes.indexPath isEqual:self.selectedItemIndexPath]) {
        layoutAttributes.hidden = YES;
    }
}

- (id<LoaerTwitterCollectionViewDataSource>)dataSource {
    return (id<LoaerTwitterCollectionViewDataSource>)self.collectionView.dataSource;
}

- (id<LoaerTwitterCollectionViewDelegateFlowLayout>)delegate {
    return (id<LoaerTwitterCollectionViewDelegateFlowLayout>)self.collectionView.delegate;
}

- (void)invalidateLayoutIfNecessary {

    NSIndexPath *newIndexPath = [self.collectionView indexPathForItemAtPoint:self.currentView.center];
    NSIndexPath *previousIndexPath = self.selectedItemIndexPath;

    if ((newIndexPath == nil) || [newIndexPath isEqual:previousIndexPath]) {

        return;
    }

    if ([self.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:canMoveToIndexPath:)] &&
        ![self.dataSource collectionView:self.collectionView itemAtIndexPath:previousIndexPath canMoveToIndexPath:newIndexPath]) {
        return;
    }

    self.selectedItemIndexPath = newIndexPath;

    if ([self.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:willMoveToIndexPath:)]) {
        [self.dataSource collectionView:self.collectionView itemAtIndexPath:previousIndexPath willMoveToIndexPath:newIndexPath];
    }

    __weak typeof(self) weakSelf = self;
    [self.collectionView performBatchUpdates:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf.collectionView deleteItemsAtIndexPaths:@[ previousIndexPath ]];
            [strongSelf.collectionView insertItemsAtIndexPaths:@[ newIndexPath ]];
        }
    } completion:^(BOOL finished) {
        __strong typeof(self) strongSelf = weakSelf;
        if ([strongSelf.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:didMoveToIndexPath:)]) {
            [strongSelf.dataSource collectionView:strongSelf.collectionView itemAtIndexPath:previousIndexPath didMoveToIndexPath:newIndexPath];
        }
    }];
}

- (void)invalidatesScrollTimer {
    if (!self.displayLink.paused) {
        [self.displayLink invalidate];
    }
    self.displayLink = nil;
}

- (void)setupScrollTimerInDirection:(LoaercrollingDirection)direction {
    if (!self.displayLink.paused) {
        LoaercrollingDirection oldDirection = [self.displayLink.Loaer_userInfo[kLoaercrollingDirectionKey] integerValue];

        if (direction == oldDirection) {
            return;
        }
    }

    [self invalidatesScrollTimer];

    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleScroll:)];
    self.displayLink.Loaer_userInfo = @{ kLoaercrollingDirectionKey : @(direction) };

    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark - Target/Action methods

// Tight loop, allocate memory sparely, even if they are stack allocation.
- (void)handleScroll:(CADisplayLink *)displayLink {
    LoaercrollingDirection direction = (LoaercrollingDirection)[displayLink.Loaer_userInfo[kLoaercrollingDirectionKey] integerValue];
    if (direction == LoaercrollingDirectionUnknown) {
        return;
    }

    CGSize frameSize = self.collectionView.bounds.size;
    CGSize contentSize = self.collectionView.contentSize;
    CGPoint contentOffset = self.collectionView.contentOffset;
    UIEdgeInsets contentInset = self.collectionView.contentInset;
    // Important to have an integer `distance` as the `contentOffset` property automatically gets rounded
    // and it would diverge from the view's center resulting in a "cell is slipping away under finger"-bug.
    CGFloat distance = rint(self.scrollingSpeed * displayLink.duration);
    CGPoint translation = CGPointZero;

    switch(direction) {
        case LoaercrollingDirectionUp: {
            distance = -distance;
            CGFloat minY = 0.0f - contentInset.top;

            if ((contentOffset.y + distance) <= minY) {
                distance = -contentOffset.y - contentInset.top;
            }

            translation = CGPointMake(0.0f, distance);
        } break;
        case LoaercrollingDirectionDown: {
            CGFloat maxY = MAX(contentSize.height, frameSize.height) - frameSize.height + contentInset.bottom;

            if ((contentOffset.y + distance) >= maxY) {
                distance = maxY - contentOffset.y;
            }

            translation = CGPointMake(0.0f, distance);
        } break;
        case LoaercrollingDirectionLeft: {
            distance = -distance;
            CGFloat minX = 0.0f - contentInset.left;

            if ((contentOffset.x + distance) <= minX) {
                distance = -contentOffset.x - contentInset.left;
            }

            translation = CGPointMake(distance, 0.0f);
        } break;
        case LoaercrollingDirectionRight: {
            CGFloat maxX = MAX(contentSize.width, frameSize.width) - frameSize.width + contentInset.right;

            if ((contentOffset.x + distance) >= maxX) {
                distance = maxX - contentOffset.x;
            }

            translation = CGPointMake(distance, 0.0f);
        } break;
        default: {
            // Do nothing...
        } break;
    }

    self.currentViewCenter = Loaer_CGPointAdd(self.currentViewCenter, translation);
    self.currentView.center = Loaer_CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);
    self.collectionView.contentOffset = Loaer_CGPointAdd(contentOffset, translation);
}


- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    switch(gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *currentIndexPath = [self.collectionView indexPathForItemAtPoint:[gestureRecognizer locationInView:self.collectionView]];

            if ([self.dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)] &&
               ![self.dataSource collectionView:self.collectionView canMoveItemAtIndexPath:currentIndexPath]) {
                return;
            }

            self.selectedItemIndexPath = currentIndexPath;

            if ([self.delegate respondsToSelector:@selector(collectionView:layout:willBeginDraggingItemAtIndexPath:)]) {
                [self.delegate collectionView:self.collectionView layout:self willBeginDraggingItemAtIndexPath:self.selectedItemIndexPath];
            }

            UICollectionViewCell *collectionViewCell = [self.collectionView cellForItemAtIndexPath:self.selectedItemIndexPath];

            self.currentView = [[UIView alloc] initWithFrame:collectionViewCell.frame];

            collectionViewCell.highlighted = YES;
            UIView *highlightedImageView = [collectionViewCell Loaer_snapshotView];
            highlightedImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            highlightedImageView.alpha = 1.0f;

            collectionViewCell.highlighted = NO;
            UIView *imageView = [collectionViewCell Loaer_snapshotView];
            imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            imageView.alpha = 0.0f;

            [self.currentView addSubview:imageView];
            [self.currentView addSubview:highlightedImageView];
            [self.collectionView addSubview:self.currentView];

            self.currentViewCenter = self.currentView.center;

            __weak typeof(self) weakSelf = self;
            [UIView
             animateWithDuration:0.3
             delay:0.0
             options:UIViewAnimationOptionBeginFromCurrentState
             animations:^{
                 __strong typeof(self) strongSelf = weakSelf;
                 if (strongSelf) {
                     strongSelf.currentView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                     highlightedImageView.alpha = 0.0f;
                     imageView.alpha = 1.0f;
                 }
             }
             completion:^(BOOL finished) {
                 __strong typeof(self) strongSelf = weakSelf;
                 if (strongSelf) {
                     [highlightedImageView removeFromSuperview];

                     if ([strongSelf.delegate respondsToSelector:@selector(collectionView:layout:didBeginDraggingItemAtIndexPath:)]) {
                         [strongSelf.delegate collectionView:strongSelf.collectionView layout:strongSelf didBeginDraggingItemAtIndexPath:strongSelf.selectedItemIndexPath];
                     }
                 }
             }];

            [self invalidateLayout];
        } break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            NSIndexPath *currentIndexPath = self.selectedItemIndexPath;

            CGRect cur = [self.collectionView convertRect:self.currentView.frame toView:self.collectionView.superview];

            BOOL deleteBool = CGRectIntersectsRect(self.collectionView.frame, cur);

            if (!deleteBool) {

            if ([self.dataSource respondsToSelector:@selector(collectionView:willDeleteToIndexPath:)]) {

                [self.dataSource collectionView:self.collectionView willDeleteToIndexPath:currentIndexPath];

             }

                 __weak typeof(self) weakSelf = self;

                 [self.collectionView performBatchUpdates:^{

                     __strong typeof(self) strongSelf = weakSelf;

                     if (strongSelf) {

                         [strongSelf.collectionView deleteItemsAtIndexPaths:@[ currentIndexPath ]];

                     }

                 } completion:^(BOOL finished) {

                     __strong typeof(self) strongSelf = weakSelf;

                     if ([strongSelf.dataSource respondsToSelector:@selector(collectionView:didDeleteToIndexPath:)]) {

                     [strongSelf.dataSource collectionView:strongSelf.collectionView didDeleteToIndexPath:currentIndexPath];

                     }

                 }];
             }

            if (currentIndexPath) {
                if ([self.delegate respondsToSelector:@selector(collectionView:layout:willEndDraggingItemAtIndexPath:)]) {
                    [self.delegate collectionView:self.collectionView layout:self willEndDraggingItemAtIndexPath:currentIndexPath];
                }

                self.selectedItemIndexPath = nil;
                self.currentViewCenter = CGPointZero;

                UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:currentIndexPath];

                self.longPressGestureRecognizer.enabled = NO;

                __weak typeof(self) weakSelf = self;
                [UIView
                 animateWithDuration:0.3
                 delay:0.0
                 options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                     __strong typeof(self) strongSelf = weakSelf;
                     if (strongSelf) {
                         strongSelf.currentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         if(deleteBool) strongSelf.currentView.center = layoutAttributes.center;
                     }
                 }
                 completion:^(BOOL finished) {

                     self.longPressGestureRecognizer.enabled = YES;

                     __strong typeof(self) strongSelf = weakSelf;
                     if (strongSelf) {
                         [strongSelf.currentView removeFromSuperview];
                         strongSelf.currentView = nil;
                         [strongSelf invalidateLayout];

                         if ([strongSelf.delegate respondsToSelector:@selector(collectionView:layout:didEndDraggingItemAtIndexPath:)]) {
                             [strongSelf.delegate collectionView:strongSelf.collectionView layout:strongSelf didEndDraggingItemAtIndexPath:currentIndexPath];
                         }
                     }
                 }];
            }
        } break;

        default: break;
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            self.panTranslationInCollectionView = [gestureRecognizer translationInView:self.collectionView];
            CGPoint viewCenter = self.currentView.center = Loaer_CGPointAdd(self.currentViewCenter, self.panTranslationInCollectionView);

            [self invalidateLayoutIfNecessary];

            switch (self.scrollDirection) {
                case UICollectionViewScrollDirectionVertical: {
                    if (viewCenter.y < (CGRectGetMinY(self.collectionView.bounds) + self.scrollingTriggerEdgeInsets.top)) {
                        [self setupScrollTimerInDirection:LoaercrollingDirectionUp];
                    } else {
                        if (viewCenter.y > (CGRectGetMaxY(self.collectionView.bounds) - self.scrollingTriggerEdgeInsets.bottom)) {
                            [self setupScrollTimerInDirection:LoaercrollingDirectionDown];
                        } else {
                            [self invalidatesScrollTimer];
                        }
                    }
                } break;
                case UICollectionViewScrollDirectionHorizontal: {
                    if (viewCenter.x < (CGRectGetMinX(self.collectionView.bounds) + self.scrollingTriggerEdgeInsets.left)) {
                        [self setupScrollTimerInDirection:LoaercrollingDirectionLeft];
                    } else {
                        if (viewCenter.x > (CGRectGetMaxX(self.collectionView.bounds) - self.scrollingTriggerEdgeInsets.right)) {
                            [self setupScrollTimerInDirection:LoaercrollingDirectionRight];
                        } else {
                            [self invalidatesScrollTimer];
                        }
                    }
                } break;
            }
        } break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            [self invalidatesScrollTimer];
        } break;
        default: {
            // Do nothing...
        } break;
    }
}

#pragma mark - UICollectionViewLayout overridden methods

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *layoutAttributesForElementsInRect = [super layoutAttributesForElementsInRect:rect];

    for (UICollectionViewLayoutAttributes *layoutAttributes in layoutAttributesForElementsInRect) {
        switch (layoutAttributes.representedElementCategory) {
            case UICollectionElementCategoryCell: {
                [self applyLayoutAttributes:layoutAttributes];
            } break;
            default: {
                // Do nothing...
            } break;
        }
    }

    return layoutAttributesForElementsInRect;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];

    switch (layoutAttributes.representedElementCategory) {
        case UICollectionElementCategoryCell: {
            [self applyLayoutAttributes:layoutAttributes];
        } break;
        default: {
            // Do nothing...
        } break;
    }

    return layoutAttributes;
}

#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.panGestureRecognizer isEqual:gestureRecognizer]) {
        return (self.selectedItemIndexPath != nil);
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([self.longPressGestureRecognizer isEqual:gestureRecognizer]) {
        return [self.panGestureRecognizer isEqual:otherGestureRecognizer];
    }

    if ([self.panGestureRecognizer isEqual:gestureRecognizer]) {
        return [self.longPressGestureRecognizer isEqual:otherGestureRecognizer];
    }

    return NO;
}

#pragma mark - Key-Value Observing methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:kLoaerCollectionViewKeyPath]) {
        if (self.collectionView != nil) {
            [self setupCollectionView];
        } else {
            [self invalidatesScrollTimer];
            [self tearDownCollectionView];
        }
    }
}

#pragma mark - Notifications

- (void)handleApplicationWillResignActive:(NSNotification *)notification {
    self.panGestureRecognizer.enabled = NO;
    self.panGestureRecognizer.enabled = YES;
}


@end
