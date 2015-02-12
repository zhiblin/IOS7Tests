//
//  CameraCountdownCounter.h
//  MTXJ
//
//  Created by JoyChiang on 12-8-27.
//  Copyright (c) 2012年 Meitu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol CameraCountdownViewDelegate;

@interface CameraCountdownView : UIView
{
    NSInteger   _seconds;
    NSTimer     *_countdownTimer;
    UIView      *_secondsBackgroundView;
    UIImageView *_countDownImgView;
    SystemSoundID soundID;
}

@property(nonatomic, assign)  NSInteger seconds;
@property(nonatomic, weak)  id<CameraCountdownViewDelegate> delegate;
@property(nonatomic, readonly)  UIView *secondsBackgroundView;

- (id)initWithSeconds:(NSInteger)seconds;
- (id)initWithFrame:(CGRect)frame andSeconds:(NSInteger)seconds;
- (void)startCountdownTimer;

- (void)invalidateCountdownTimer;
@end

@protocol CameraCountdownViewDelegate <NSObject>
- (void)cameraCountdownViewDidCompleted;
@end