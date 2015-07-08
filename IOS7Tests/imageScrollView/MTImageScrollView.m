//
//  MTCameraImageScrollView.m
//  MTXX
//
//  Created by JoyChiang on 14-3-27.
//  Copyright (c) 2014年 Meitu. All rights reserved.
//

#import "MTImageScrollView.h"
#define UIViewAutoresizingAll               UIViewAutoresizingFlexibleLeftMargin| \
UIViewAutoresizingFlexibleWidth|\
UIViewAutoresizingFlexibleRightMargin|\
UIViewAutoresizingFlexibleTopMargin|\
UIViewAutoresizingFlexibleHeight|\
UIViewAutoresizingFlexibleBottomMargin

@interface MTImageScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *originalImageView;
@property (nonatomic, strong) UIImageView *processImageView;

@end

@implementation MTImageScrollView {
    UIView *_imageContainerView;
}

- (void)commonInit
{
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.alwaysBounceHorizontal = YES;
    self.alwaysBounceVertical = YES;
    self.minimumZoomScale = 1.f;
    self.maximumZoomScale = 4.f;
    self.delegate = self;
    
    if (_imageContainerView == nil) {
        _imageContainerView = [[UIView alloc] initWithFrame:self.bounds];
        _imageContainerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageContainerView];
    }
    
    if (_originalImageView == nil) {
        _originalImageView = [[UIImageView alloc] initWithFrame:_imageContainerView.bounds];
        _originalImageView.autoresizingMask = UIViewAutoresizingAll;
        _originalImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_imageContainerView addSubview:_originalImageView];
    }
    
    if (_processImageView == nil) {
        _processImageView = [[UIImageView alloc] initWithFrame:_imageContainerView.bounds];
        _processImageView.autoresizingMask = UIViewAutoresizingAll;
        _processImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_imageContainerView addSubview:_processImageView];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [self commonInit];
}

- (void)setProcessImage:(UIImage *)processImage
{
    _processImageView.image = processImage;
}

- (void)setOriginalImage:(UIImage *)originalImage
{
    _originalImageView.image = originalImage;
    
    [self layoutSubviews];
}


-(UIImage *)originalImage
{
    return _originalImageView.image;
}

-(UIImage *)processImage
{
    return _processImageView.image;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize imageSize = _originalImageView.image.size;
    if (!CGSizeEqualToSize(imageSize, CGSizeZero)) {
        CGSize showImageSize = CGSizeZero;
        if (imageSize.height/imageSize.width > self.frame.size.height/self.frame.size.width) {
            showImageSize = CGSizeMake(imageSize.width * self.frame.size.height/imageSize.height, self.frame.size.height);
        } else {
            showImageSize = CGSizeMake(self.frame.size.width, imageSize.height * self.frame.size.width/imageSize.width);
        }
        CGRect frame = CGRectMake(0.0f, 0.0f, showImageSize.width * self.zoomScale, showImageSize.height *self.zoomScale);
        if (frame.size.width < self.bounds.size.width) {
            frame.origin.x = (self.bounds.size.width - frame.size.width) / 2;
        } else {
            frame.origin.x = 0;
        }
        if (frame.size.height < self.bounds.size.height) {
            frame.origin.y = (self.bounds.size.height - frame.size.height) / 2;
        } else {
            frame.origin.y = 0;
        }
        
        _imageContainerView.frame = frame;
        
        self.contentSize = _imageContainerView.frame.size;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 8) {
        [self layoutSubviews];
    }
}

@end