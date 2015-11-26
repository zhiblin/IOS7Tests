//
//  MTAlertViewController.m
//  BeautyPlus
//
//  Created by lzb on 15/11/5.
//  Copyright © 2015年 美图网. All rights reserved.
//

#import "MTAlertViewController.h"

@interface MTAlertViewController ()

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *messageString;
@property (nonatomic, strong) NSString *okString;
@property (nonatomic, strong) NSString *cancelString;
@property (nonatomic, assign) AlertViewType alertType;


@end

@implementation MTAlertViewController

@synthesize titleLabel,messageLabel,okButton,cancelButton,titleView;
@synthesize titleString, messageString, okString, cancelString, alertType;



- (id)initWithTitle:(NSString *)titleStr  message:(NSString *)messageStr ok:(NSString *) okStr cancel:(NSString *) cancelStr alertType:(AlertViewType)alertViewType{
    
    self = [super init];
    if (self) {
        titleString = titleStr;
        messageString = messageStr;
        okString = okStr;
        cancelString = cancelStr;
        alertType = alertViewType;
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor  colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self showtitle:titleString message:messageString ok:okString cancel:cancelString alertType:alertType];
}

-(CGSize)labelSize:(float)fontsize text:(NSString *)textStr {
    
    UIFont *font = [UIFont systemFontOfSize:fontsize];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [textStr boundingRectWithSize:CGSizeMake(250, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    NSLog(@"size.width=%f, size.height=%f", labelSize.width, labelSize.height);
    
    return labelSize;
}

-(void)showtitle:(NSString *)titleStr message:(NSString *)messageStr ok:(NSString *) okStr cancel:(NSString *) cancelStr alertType:(AlertViewType)alertViewType{
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 999)];
    titleLabel.text = titleStr;
    [titleLabel setFont:[UIFont systemFontOfSize:18.]];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    CGSize titleSize = [self labelSize:18. text:titleStr];
    [titleLabel setFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
    [self.view addSubview:titleLabel];
    
    
    messageLabel = [[UILabel alloc] init];
    [messageLabel setFont:[UIFont systemFontOfSize:16.]];
    messageLabel.text = messageStr;
    messageLabel.numberOfLines = 0;
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    CGSize messageSize = [self labelSize:16. text:messageStr];
    [messageLabel setFrame:CGRectMake(0, 0, messageSize.width, messageSize.height)];
    [self.view addSubview:messageLabel];
    titleLabel.center = CGPointMake(self.view.center.x, self.view.center.y - messageSize.height - (titleSize.height/2) - 40.);
    messageLabel.center = CGPointMake(self.view.center.x, self.view.center.y - (messageSize.height/2) - 20.);

    okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setBackgroundColor:[UIColor colorWithRed:255./255. green:93./255. blue:120./255. alpha:1.]];
    
    [self corner:okButton];
    [okButton setTitle:okStr forState:UIControlStateNormal];
    if (alertViewType == OneButton) {
        
        [okButton setFrame:CGRectMake(0, 0, 220, 38)];
        [okButton setCenter:CGPointMake(self.view.center.x, self.view.center.y + 19)];
    }
    else if (alertViewType == TwoButton) {
        
        [okButton setFrame:CGRectMake(0, 0, 100, 38)];
        [okButton setCenter:CGPointMake(self.view.center.x - (titleLabel.frame.size.width+20)/4, self.view.center.y + 19)];
    }
    [okButton addTarget:self action:@selector(doAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:okButton];
    
    if (alertViewType == TwoButton) {
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(0, 0, 100, 38)];
    [cancelButton setCenter:CGPointMake(self.view.center.x + (titleLabel.frame.size.width+20)/4, self.view.center.y + 19)];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:cancelStr forState:UIControlStateNormal];
        
    [self.view addSubview:cancelButton];

    }
//    NSLog(@"title frame %@ /n message frame %@ /n button frame %@",NSStringFromCGRect(titleLabel.frame),NSStringFromCGRect(messageLabel.frame),NSStringFromCGRect(okButton.frame));
 
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x-10, titleLabel.frame.origin.y-16, titleLabel.frame.size.width+20, titleSize.height +messageSize.height + 38 + 40 + 19 + 10)];
    [self corner:bgview];
    bgview.backgroundColor = [UIColor colorWithRed:249.0/255. green:249./255. blue:249./255. alpha:1.];
    [self.view addSubview:bgview];
    [self.view sendSubviewToBack:bgview];
    
}

-(UIView*)backgroundView:(CGRect)viewFrame{
    
    UIView *bgview = [[UIView alloc] initWithFrame:viewFrame];
    
    return bgview;
}


-(void)corner:(UIView *)tagetView{
    
    tagetView.layer.cornerRadius = 6;//设置那个圆角的有多圆
    //    tagetView.layer.borderWidth = 10;//设置边框的宽度，当然可以不要
    //    tagetView.layer.borderColor = [[UIColor redColor] CGColor];//设置边框的颜色
    tagetView.layer.masksToBounds = YES;//设为NO去试试
    
}

-(void)showCustomAlertView:(UIViewController *)VC{
    
    [VC addChildViewController:self];
    self.view.frame = VC.view.bounds;
    [VC.view addSubview:self.view];
}

- (void)doAction{
    if (self.didAction) {
        self.didAction(YES);
    }
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)cancelAction
{
    //    [UIView animateWithDuration:0.5 animations:^{
    //        [cancelButton setFrame:CGRectMake(cancelButton.frame.origin.x, DEVICE_HEIGHT+190, cancelButton.frame.size.width, cancelButton.frame.size.height)];
    //        [self.titleView setFrame:CGRectMake(self.titleView.frame.origin.x, DEVICE_HEIGHT, self.titleView.frame.size.width, self.titleView.frame.size.height)];
    //
    //    } completion:^(BOOL finished) {
    if (self.didAction) {
        self.didAction(NO);
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
    //    }];
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
