//
//  VibeQuick.m
//  SayYesToTheTest
//
//  Created by Frank Williams on 3/7/15.
//  Copyright (c) 2015 Frank Williams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VibeQuick.h"
@import AudioToolbox;

void AudioServicesStopSystemSound(int);
void AudioServicesPlaySystemSoundWithVibration(int, id, NSDictionary *);

@implementation vibeObject;

- (void)vibrate:(CGFloat) intensity andTime:(int)time
{
    [self test:intensity andTime:time];
    /*
    AudioServicesStopSystemSound(kSystemSoundID_Vibrate);
    
    int64_t vibrationLength = 300;
    
    NSArray *pattern = @[@NO, @0, @YES, @(vibrationLength)];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[@"VibePattern"] = pattern;
    dictionary[@"Intensity"] = @1;
    
    AudioServicesPlaySystemSoundWithVibration(kSystemSoundID_Vibrate, nil, dictionary);
     */
}

-(void)test:(CGFloat)intensity andTime:(int)time{
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    NSMutableArray* arr = [NSMutableArray array ];
    
    [arr addObject:[NSNumber numberWithBool:YES]]; //vibrate for 2000ms
    [arr addObject:[NSNumber numberWithInt:time]];
    /*
    [arr addObject:[NSNumber numberWithBool:NO]];  //stop for 1000ms
    [arr addObject:[NSNumber numberWithInt:1000]];
    
    [arr addObject:[NSNumber numberWithBool:YES]];  //vibrate for 1000ms
    [arr addObject:[NSNumber numberWithInt:1000]];
    
    [arr addObject:[NSNumber numberWithBool:NO]];    //stop for 500ms
    [arr addObject:[NSNumber numberWithInt:500]];
    */
    [dict setObject:arr forKey:@"VibePattern"];
    [dict setObject:[NSNumber numberWithFloat:intensity] forKey:@"Intensity"];
//    NSString *m = [NSString stringWithFormat:@"%@%@%@",@"AudioServicesPl",@"aySystemSoun",@"dWithVibration"];
//    SEL v = NSSelectorFromString(m);
//    if([object　respondsToSelector:v])
//   {
//       [object　performSelector:sel　withObject: @"test" ]; //如果有两个参数,使用两个withObject:参数;
//    }
    AudioServicesPlaySystemSoundWithVibration(4095,nil,dict);
    
}


-(void)stop{
    AudioServicesStopSystemSound(kSystemSoundID_Vibrate);
}


@end