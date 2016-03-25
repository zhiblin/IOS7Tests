//
//  VibePattern.h
//  AllDemo
//
//  Created by xiaopi on 16/3/25.
//  Copyright © 2016年 loaer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyVibePattern : NSObject

+ (MyVibePattern *)PatternWithIntensity:(float)intensity time:(NSUInteger)time isVibe:(BOOL)isVibe;
@property (nonatomic) bool isV;
@property (nonatomic) float intensity;
@property (nonatomic) NSUInteger time;

@end

@interface VibePattern : NSObject

- (VibePattern *)initWithPattern:(NSArray *)patterns;
- (VibePattern *)initWithFile:(NSString *)file;
- (VibePattern *)initWithLoop:(NSUInteger)vibe pause:(NSUInteger)pause;
- (void)play;
- (void)stop;

@end
