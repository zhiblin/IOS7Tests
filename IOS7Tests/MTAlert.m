//
//  MTAlert.m
//  BeautyPlus
//
//  Created by lzb on 15/11/5.
//  Copyright © 2015年 美图网. All rights reserved.
//

#import "MTAlert.h"

@implementation MTAlert

@synthesize titleLabel,messageLabel,okButton,cancelButton;

-(id)initWithFrame:(CGRect)frame title:(NSString *)titleStr message:(NSString *)messageStr ok:(NSString *) okStr{
    self = [super initWithFrame:frame];
    if (self) {
        [self show:frame title:titleStr message:messageStr ok:okStr];
    }
     return self;
}


-(void)show:(CGRect)f title:(NSString *)titleStr message:(NSString *)messageStr ok:(NSString *) okStr{
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, f.size.width-10, f.size.height/3)];
    titleLabel.text = titleStr;
    [titleLabel setFont:[UIFont systemFontOfSize:18.]];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5+f.size.height/3, f.size.width-10, f.size.height/3)];
    [messageLabel setFont:[UIFont systemFontOfSize:16.]];
    messageLabel.text = messageStr;
    messageLabel.numberOfLines = 0;
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:messageLabel];
    
    okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setBackgroundColor:[UIColor colorWithRed:255./255. green:93./255. blue:120./255. alpha:1.]];
   
    [self corner:okButton];
    [okButton setTitle:okStr forState:UIControlStateNormal];
//    [okButton setImage:titleImage forState:UIControlStateNormal];
    [okButton setFrame:CGRectMake(5, 0, 175, 38)];
    [okButton setCenter:CGPointMake(self.center.x, self.center.y +  f.size.height/3)];
    [okButton addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:okButton];
    
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [cancelButton setImage:titleImage forState:UIControlStateNormal];
    [cancelButton setFrame:CGRectMake(0, 0, 175, 38)];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
//    [self addSubview:cancelButton];
    
}

-(void)corner:(UIView *)tagetView{
    
    tagetView.layer.cornerRadius = 6;//设置那个圆角的有多圆
    //    tagetView.layer.borderWidth = 10;//设置边框的宽度，当然可以不要
    //    tagetView.layer.borderColor = [[UIColor redColor] CGColor];//设置边框的颜色
    tagetView.layer.masksToBounds = YES;//设为NO去试试
    
}



-(void)ok{
    
}

-(void)cancel{
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
