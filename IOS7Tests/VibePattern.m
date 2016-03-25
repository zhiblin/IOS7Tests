//
//  VibePattern.m
//  AllDemo
//
//  Created by xiaopi on 16/3/25.
//  Copyright © 2016年 loaer. All rights reserved.
//

#import "VibePattern.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation MyVibePattern
+ (MyVibePattern *)PatternWithIntensity:(float)intensity time:(NSUInteger)time isVibe:(BOOL)isVibe{
    MyVibePattern *pattern = [MyVibePattern new];
    pattern.isV = isVibe;
    pattern.intensity = intensity;
    pattern.time = time;
    return pattern;
};
@end


@interface VibePattern(){
    NSArray *_patterns;
    NSMutableDictionary *_buff;
    bool _isRepeat;
    }
@end

@implementation VibePattern

- (VibePattern *)initWithPattern:(NSArray *)patterns{
    if ([super init]) {
        _patterns = [[NSMutableArray alloc] initWithArray:patterns copyItems:YES];
        _buff=nil;
        _isRepeat=NO;
    }
    return self;
}


- (VibePattern *)initWithFile:(NSString *)file{
    if ([super init]) {
        _patterns = [NSMutableArray arrayWithContentsOfFile:file];
        _buff=nil;
        _isRepeat=NO;
    }
    return self;
}
- (VibePattern *)initWithLoop:(NSUInteger)vibe pause:(NSUInteger)pause{
    if ([super init]) {
        MyVibePattern *vibePattern = [MyVibePattern PatternWithIntensity:0.3 time:vibe isVibe:YES];
        MyVibePattern *pausePattern = [MyVibePattern PatternWithIntensity:0.9 time:pause isVibe:NO];
        
        _patterns = @[vibePattern,pausePattern];
        _buff=nil;
        _isRepeat=YES;
    }
    return self;
    
    
}
- (void)play{
    [NSThread detachNewThreadSelector:@selector(loop) toTarget:self withObject:nil];
}
- (void)stop{
    
}


- (void)loop{
    NSUInteger i=0;
    while (YES) {
        NSUInteger pause = 0;
        MyVibePattern *pattern = _patterns;
        if (!pattern.isV) {
        }
        else{
            [self prepareBuffWithPattern:pattern];
            [self performSelectorOnMainThread:@selector(systemPlay) withObject:nil waitUntilDone:NO];
        }
        [NSThread sleepForTimeInterval:pattern.time*1.0f/1000];
        i++;
        if (i==[_patterns count] && !_isRepeat) {
            break;
        }
        i=i%[_patterns count];
    }
}
- (void)prepareBuffWithPattern:(MyVibePattern *)pattern{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    NSMutableArray* arr = [NSMutableArray array ];
    
    [arr addObject:[NSNumber numberWithBool:YES]]; //vibrate for 2000ms
    [arr addObject:[NSNumber numberWithInt:pattern.time]];
    
    
    
    [dict setObject:arr forKey:@"VibePattern"];
    [dict setObject:[NSNumber numberWithFloat:pattern.intensity] forKey:@"Intensity"];
    _buff = dict;
}
- (void)systemPlay{
    NSLog(@"system play @%");
    
    AudioServicesPlaySystemSoundWithVibration(4095,nil,_buff);
}

@end
