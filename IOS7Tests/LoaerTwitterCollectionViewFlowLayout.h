//
//  LoaerTwitterCollectionViewFlowLayout.h
//  IOS7Tests
//
//  Created by lzb on 15/5/26.
//  Copyright (c) 2015年 loaer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoaerTwitterCollectionViewFlowLayout : UICollectionViewFlowLayout <UIGestureRecognizerDelegate>

@property (assign, nonatomic) CGFloat scrollingSpeed;
@property (assign, nonatomic) UIEdgeInsets scrollingTriggerEdgeInsets;
@property (strong, nonatomic, readonly) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (strong, nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer;

@end

@protocol LoaerTwitterCollectionViewDataSource <UICollectionViewDataSource>

@optional

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath;
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath;

- (void)collectionView:(UICollectionView *)collectionView willDeleteToIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didDeleteToIndexPath:(NSIndexPath *)indexPath;

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath;

- (BOOL)collectionView:(UICollectionView *)collectionView canDeleteItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canDeteleToIndexPath:(NSIndexPath *)toIndexPath;

@end

@protocol LoaerTwitterCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>
@optional

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;

@end