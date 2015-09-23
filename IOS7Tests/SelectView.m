//
//  SelectView.m
//  AllDemo
//
//  Created by lzb on 15/9/22.
//  Copyright © 2015年 loaer. All rights reserved.
//

#import "SelectView.h"

@implementation SelectView
@synthesize oneButton,twoButton,threeButton,fourButton,fiveButton,sixButton,sevenButton;

- (UIButton *)settingButtontitle:(NSString *)titleString {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"等级按钮2-4"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"等级按钮2-4选中"] forState:UIControlStateSelected];
    [btn setTitle:titleString forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionChangeFacialLevel:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = [titleString integerValue];
    btn.userInteractionEnabled = YES;
    return btn;
}

-(void)resetButtonState{
    
    oneButton.selected = twoButton.selected = threeButton.selected = fourButton.selected = fiveButton.selected = sixButton.selected = sevenButton.selected = NO;
}
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"%@",NSStringFromCGRect(frame));
        NSLog(@"%f",frame.size.width/7);
        float w = frame.size.width/7;
        float h = frame.size.height;
        oneButton = [self settingButtontitle:@"1"];
        [oneButton setFrame:CGRectMake(0, 0, w, h)];
        twoButton = [self settingButtontitle:@"2"];
        [twoButton setFrame:CGRectMake(w, 0, w, h)];
        threeButton = [self settingButtontitle:@"3"];
        [threeButton setFrame:CGRectMake(w*2, 0, w, h)];
        fourButton = [self settingButtontitle:@"4"];
        [fourButton setFrame:CGRectMake(w*3, 0, w, h)];
        fiveButton = [self settingButtontitle:@"5"];
        [fiveButton setFrame:CGRectMake(w*4, 0, w, h)];
        sixButton = [self settingButtontitle:@"6"];
        [sixButton setFrame:CGRectMake(w*5, 0, w, h)];
        sevenButton = [self settingButtontitle:@"7"];
        [sevenButton setFrame:CGRectMake(w*6, 0, w, h)];

        [self addSubview:oneButton];
        [self addSubview:twoButton];
        [self addSubview:threeButton];
        [self addSubview:fourButton];
        [self addSubview:fiveButton];
        [self addSubview:sixButton];
        [self addSubview:sevenButton];
        [fourButton setSelected:YES];
    }
    return self;
}

- (void)actionChangeFacialLevel:(id)sender{
     UIButton* btn = (UIButton *)sender;
    NSLog(@"%li",(long)btn.tag);
    [self resetButtonState];
    [btn setSelected:YES];
    if (self.didbtn) {
        self.didbtn(btn.tag);
    }
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
//    float w = [UIScreen mainScreen].bounds.size.width/7;
//    
//    CGRect btrect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/7, [UIScreen mainScreen].bounds.size.height);
//    oneButton.frame = twoButton.frame = threeButton.frame = fourButton.frame = fiveButton.frame = sixButton.frame = sevenButton.frame = btrect;
//    fourButton.center = self.center;
//    threeButton.center = CGPointMake(fourButton.center.x-w, fourButton.center.y);
//    twoButton.center = CGPointMake(threeButton.center.x-w, threeButton.center.y);
//    oneButton.center = CGPointMake(twoButton.center.x-w, twoButton.center.y);
//    
//    fiveButton.center = CGPointMake(fourButton.center.x+w, fourButton.center.y);
//    sixButton.center = CGPointMake(fiveButton.center.x+w, fiveButton.center.y);
//    sevenButton.center = CGPointMake(sixButton.center.x+w, sixButton.center.y);
//    [self updateConstraintsIfNeeded];
}


@end
