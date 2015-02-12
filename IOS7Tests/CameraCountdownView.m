//
//  CameraCountdownCounter.m
//  MTXJ
//
//  Created by JoyChiang on 12-8-27.
//  Copyright (c) 2012年 Meitu. All rights reserved.
//

#import "CameraCountdownView.h"

@implementation CameraCountdownView

@synthesize seconds = _seconds;
@synthesize delegate = _delegate;
@synthesize secondsBackgroundView = _secondsBackgroundView;

#pragma mark - CameraCountdownView LifeCycle
- (id)initWithFrame:(CGRect)frame andSeconds:(NSInteger)seconds
{
    if (self = [super initWithFrame:frame]) {
        
        self.seconds = seconds;
        
        int width=70;
        _secondsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-width)/2, (self.frame.size.height-width)/2, width, width)];
        [_secondsBackgroundView setBackgroundColor:[UIColor clearColor]];
        
//        _secondsBackgroundView.frame = CGRectMake(_secondsBackgroundView.frame.origin.x,
//                                                  _secondsBackgroundView.frame.origin.y - 10,
//                                                  _secondsBackgroundView.frame.size.width,
//                                                  _secondsBackgroundView.frame.size.height);
//        _secondsBackgroundView.center = self.center;
        [self addSubview:_secondsBackgroundView];
        
        
        _countDownImgView = [[UIImageView alloc] initWithFrame:_secondsBackgroundView.bounds];
        _countDownImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"倒计时%d",seconds]];
        _countDownImgView.hidden = YES;
        [_secondsBackgroundView addSubview:_countDownImgView];
        
//        if ([MYXJSettingState systemSound]) {
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"countdown" ofType:@"wav"];
//            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
//        }
    }
    return self;
}
- (id)initWithSeconds:(NSInteger)seconds
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        
        self.seconds = seconds;
        
        _secondsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        [_secondsBackgroundView setBackgroundColor:[UIColor clearColor]];
        _secondsBackgroundView.center = self.center;
        _secondsBackgroundView.frame = CGRectMake(_secondsBackgroundView.frame.origin.x,
                                                  _secondsBackgroundView.frame.origin.y - 10,
                                                  _secondsBackgroundView.frame.size.width,
                                                  _secondsBackgroundView.frame.size.height);
        [self addSubview:_secondsBackgroundView];
        
        
        _countDownImgView = [[UIImageView alloc] initWithFrame:_secondsBackgroundView.bounds];
        _countDownImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"倒计时%d",seconds]];
        _countDownImgView.hidden = YES;
        [_secondsBackgroundView addSubview:_countDownImgView];
        
//        if ([MYXJSettingState systemSound]) {
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"countdown" ofType:@"wav"];
//            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
//        }
    }
    return self;
}

- (void)dealloc{
    AudioServicesDisposeSystemSoundID(soundID);
    [self invalidateCountdownTimer];
//    [_secondsBackgroundView release];
    
//    [_countDownImgView release];
//    [super dealloc];
}

#pragma mark - CameraCountdownView Public Methods
- (void)setSeconds:(NSInteger)seconds {
    _seconds = seconds;
    _countDownImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"倒数%d",_seconds]];
}

- (void)invalidateCountdownTimer
{
    if ([_countdownTimer isValid]) {
        [_countdownTimer invalidate];
    }

//    [_countdownTimer release];
    _countdownTimer = nil;
}

- (void)startCountdownTimer
{
    [self invalidateCountdownTimer];    
    _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleCountdownTimer:) userInfo:nil repeats:YES];
}

- (void)handleCountdownTimer:(NSTimer *)timer
{
    if (_seconds > 0)
    {
        _countDownImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"倒计时%d",_seconds]];
//        if ([MYXJSettingState systemSound])
//        {
//            AudioServicesPlaySystemSound(soundID);
//        }
        
        _countDownImgView.hidden = NO;
        _countDownImgView.alpha = 1.0;
        [UIView animateWithDuration:0.9 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _countDownImgView.alpha = 0.0;
            _countDownImgView.transform = CGAffineTransformMakeScale(4, 4);
        } completion:^(BOOL finished) {
            _countDownImgView.hidden = YES;
            _countDownImgView.transform = CGAffineTransformIdentity;
        }];
        _seconds--;
    }
    else
    {
        // finish
        [_delegate cameraCountdownViewDidCompleted];
        [self invalidateCountdownTimer];
        _seconds = 0;
    }
}
@end