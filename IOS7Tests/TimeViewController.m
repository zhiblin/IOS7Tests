//
//  TimeViewController.m
//  AllDemo
//
//  Created by lzb on 15/9/23.
//  Copyright © 2015年 loaer. All rights reserved.
//

#import "TimeViewController.h"
#import "DDHTimerControl.h"

@interface TimeViewController (){
    
    UILabel     * _labelA;
    UILabel     * _labelB;
}

@property (nonatomic, strong) DDHTimerControl *minuteTimer;
@property (nonatomic, strong) DDHTimerControl *secondTimer;


@end

@implementation TimeViewController

@synthesize minuteTimer,secondTimer;

-(void)testFLV{
    
    _labelA = [[UILabel alloc] init];
    _labelA.translatesAutoresizingMaskIntoConstraints = NO;
    _labelA.backgroundColor = [UIColor blueColor];
    _labelA.numberOfLines = 0;
    _labelA.text = @"AAAAAAAAAAAAAAAAAAAAA";
    [self.view addSubview:_labelA];
    
    _labelB = [[UILabel alloc] init];
    _labelB.translatesAutoresizingMaskIntoConstraints = NO;
    _labelB.backgroundColor = [UIColor yellowColor];
    _labelB.numberOfLines = 0;
    _labelB.text = @"BBBBBBBBBBBBBBBBBBBBB";
    [self.view addSubview:_labelB];
    
    NSDictionary * views = @{@"labelA":_labelA,@"labelB":_labelB};
    NSDictionary * metrics = @{@"top":@20,@"left":@20,@"bottom":@20,@"right":@20,@"width":@200,@"height":@50,@"vPadding":@70,@"hPadding":@30};
    NSString * vLayoutString = @"V:|-top-[labelA(==height)]-vPadding-[labelB(>=height)]";
    NSArray * vLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:vLayoutString options:0 metrics:metrics views:views];
    
    NSString * hLayoutString = @"H:|-left-[labelA(==width)]-hPadding-[labelB(<=width)]";
    NSArray * hLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:hLayoutString options:0 metrics:metrics views:views];
    [self.view addConstraints:vLayoutArray];
    [self.view addConstraints:hLayoutArray];
    
}

-(void)otherA{
    minuteTimer = [DDHTimerControl timerControlWithType:DDHTimerTypeEqualElements];
    minuteTimer.translatesAutoresizingMaskIntoConstraints = NO;
    minuteTimer.color = [UIColor orangeColor];
    minuteTimer.highlightColor = [UIColor redColor];
    minuteTimer.minutesOrSeconds = 12;
    minuteTimer.titleLabel.text = @"min";
    minuteTimer.userInteractionEnabled = NO;
    [self.view addSubview:minuteTimer];
    
    secondTimer = [DDHTimerControl timerControlWithType:DDHTimerTypeSolid];
    secondTimer.translatesAutoresizingMaskIntoConstraints = NO;
    secondTimer.color = [UIColor orangeColor];
    secondTimer.highlightColor = [UIColor redColor];
    secondTimer.minutesOrSeconds = 59;
    secondTimer.titleLabel.text = @"sec";
    secondTimer.userInteractionEnabled = NO;
    [self.view addSubview:secondTimer];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:minuteTimer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:minuteTimer attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondTimer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:secondTimer attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
    
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(minuteTimer, secondTimer);
    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[minuteTimer(200)]-10-[secondTimer(100)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[minuteTimer(200)]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(minuteTimer)]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self otherA];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
