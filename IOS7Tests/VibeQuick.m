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

- (void)vibrate
{
    [self test];
//    AudioServicesStopSystemSound(kSystemSoundID_Vibrate);
//    
//    int64_t vibrationLength = 30;
//    
//    NSArray *pattern = @[@NO, @0, @YES, @(vibrationLength)];
//    
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//    dictionary[@"VibePattern"] = pattern;
//    dictionary[@"Intensity"] = @1;
//    
//    AudioServicesPlaySystemSoundWithVibration(kSystemSoundID_Vibrate, nil, dictionary);
}

-(void)test{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    NSMutableArray* arr = [NSMutableArray array ];
    
    [arr addObject:[NSNumber numberWithBool:YES]]; //vibrate for 2000ms
    [arr addObject:[NSNumber numberWithInt:2000]];
    
    [arr addObject:[NSNumber numberWithBool:NO]];  //stop for 1000ms
    [arr addObject:[NSNumber numberWithInt:1000]];
    
    [arr addObject:[NSNumber numberWithBool:YES]];  //vibrate for 1000ms
    [arr addObject:[NSNumber numberWithInt:1000]];
    
    [arr addObject:[NSNumber numberWithBool:NO]];    //stop for 500ms
    [arr addObject:[NSNumber numberWithInt:500]];
    
    [dict setObject:arr forKey:@"VibePattern"];
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"Intensity"];
    AudioServicesPlaySystemSoundWithVibration(4095,nil,dict);
}

@end