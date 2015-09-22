//
//  FiveStarViewController.m
//  AllDemo
//
//  Created by lzb on 15/9/21.
//  Copyright © 2015年 loaer. All rights reserved.
//

#import "FiveStarViewController.h"


#define CONST_animation_time 1.5
#define CONST_enlarge_proportion 1.0

@interface FiveStarViewController ()

@property(nonatomic, strong) UIImageView *starImageView;
@property(nonatomic, strong) UITextView *titleText;
@property(nonatomic, strong) UIButton *cancelButton;
@property(nonatomic, strong) UIButton *doButton;
@property(nonatomic, strong) NSString *starString;
@property(nonatomic, strong) NSString *okDoString;
@property(nonatomic, strong) NSString *cancelDoString;


@end

@implementation FiveStarViewController

@synthesize centerView,titleText,cancelButton,doButton,starImageView;
@synthesize starString,okDoString,cancelDoString;




CGPoint UpPointOfView(UIView *view)
{
    return (CGPoint){view.center.x, 200+2+55/2};
};



- (void) circleAnimate:(UIImageView*)view
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:CONST_animation_time];
    [view setCenter:UpPointOfView(view)];
    
    
    CABasicAnimation *scalingAnimation = (CABasicAnimation *)[view.layer animationForKey:@"scaling"];
    
    if (!scalingAnimation)
    {
        scalingAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        scalingAnimation.repeatCount=1;
        scalingAnimation.duration=CONST_animation_time;
        scalingAnimation.autoreverses=NO;
        scalingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        scalingAnimation.fromValue=[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 0.0)];
        scalingAnimation.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeScale(CONST_enlarge_proportion, CONST_enlarge_proportion, 1.0)];
    }
    
    [view.layer addAnimation:scalingAnimation forKey:@"scaling"];
    view.layer.transform = CATransform3DMakeScale(CONST_enlarge_proportion, CONST_enlarge_proportion, 1.0);
    [UIView commitAnimations];
}

- (instancetype)initWithTitle:(NSString *)titleString ok:(NSString *)okString cancel:(NSString *)cancelString{
    
    self = [super init];
    if (self) {
        starString = titleString;
        okDoString = okString;
        cancelDoString = cancelString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (starString == nil) {
        starString = @"给个好评吧！！";
    }
    [self.view setBackgroundColor:[UIColor  colorWithRed:0 green:0 blue:0 alpha:0.5]];
    centerView = [[UIView alloc] initWithFrame:CGRectMake(25, 100, 270, 220)];
    centerView.center = CGPointMake(self.view.center.x, self.view.center.y-20);// self.view.center;
    [self corner:centerView];
    centerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:centerView];
    
    starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 270, 77)];
    [starImageView setImage:[UIImage imageNamed:@"star"]];
    [centerView addSubview:starImageView];
    titleText = [[UITextView alloc] initWithFrame:CGRectMake(10, 67, 254, 83)];
    titleText.userInteractionEnabled = NO;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineHeightMultiple = 50.0f;
//    paragraphStyle.maximumLineHeight = 50.0f;
//    paragraphStyle.minimumLineHeight = 50.0f;
    paragraphStyle.lineSpacing = 3.;
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:16.], NSParagraphStyleAttributeName:paragraphStyle};
    titleText.attributedText = [[NSAttributedString alloc] initWithString:starString attributes:attributes];
    [titleText setText:starString];
    [centerView addSubview:titleText];
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(10, 164, 120, 42)];
    [cancelButton setBackgroundColor:[UIColor colorWithRed:172.0/255.0 green:172.0/255.0 blue:172.0/255.0 alpha:1.]];
    [cancelButton setTitle:cancelDoString forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self corner:cancelButton];
    [centerView addSubview:cancelButton];
    
    doButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doButton setFrame:CGRectMake(140, 164, 120, 42)];
    [doButton setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:73.0/255.0 blue:112.0/255.0 alpha:1.]];
    [doButton setTitle:okDoString forState:UIControlStateNormal];
    [doButton addTarget:self action:@selector(doAction) forControlEvents:UIControlEventTouchUpInside];
    [self corner:doButton];
    [centerView addSubview:doButton];
    
}
-(void)corner:(UIView *)tagetView{
    
    tagetView.layer.cornerRadius = 6;//设置那个圆角的有多圆
//    tagetView.layer.borderWidth = 10;//设置边框的宽度，当然可以不要
//    tagetView.layer.borderColor = [[UIColor redColor] CGColor];//设置边框的颜色
    tagetView.layer.masksToBounds = YES;//设为NO去试试
    
}

-(void)showStarComment:(UIViewController *)VC{
    
    [VC addChildViewController:self];
    self.view.frame = VC.view.bounds;
    [VC.view addSubview:self.view];
}

- (void)doAction{
    if (self.didstar) {
        self.didstar(YES);
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}

- (void)cancelAction
{
//    [UIView animateWithDuration:0.5 animations:^{
//        [cancelButton setFrame:CGRectMake(cancelButton.frame.origin.x, DEVICE_HEIGHT+190, cancelButton.frame.size.width, cancelButton.frame.size.height)];
//        [self.titleView setFrame:CGRectMake(self.titleView.frame.origin.x, DEVICE_HEIGHT, self.titleView.frame.size.width, self.titleView.frame.size.height)];
//        
//    } completion:^(BOOL finished) {
    if (self.didstar) {
        self.didstar(NO);
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
