//
//  MainViewController.m
//  AllDemo
//
//  Created by lzb on 15/11/5.
//  Copyright © 2015年 loaer. All rights reserved.
//

#import "MainViewController.h"
#import "MTAlertViewController.h"

@interface MainViewController ()

@property(nonatomic, strong) NSMutableArray *beforeData;

@property(nonatomic, strong) NSMutableArray *afterData;

@end

@implementation MainViewController

@synthesize beforeData,afterData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *butt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [butt setFrame:CGRectMake(60, 100, 120, 100)];
    [butt setTitle:@"Alert  " forState:UIControlStateNormal];
    [butt addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butt];
    beforeData = [NSMutableArray new];
    afterData = [NSMutableArray new];
    for (int i = 0; i< 10; i++) {
        [beforeData addObject:[NSString stringWithFormat:@"%i",i]];
    }
    afterData = [beforeData mutableCopy];
    
    for (NSString *i in afterData) {
        NSLog(@"aa%@",i);
    }
    for (NSString *i in beforeData) {
        NSLog(@"bbb%@",i);
    }
    
    [afterData removeObject:@"2"];
    [afterData addObject:@"11"];
    
    for (NSString *i in afterData) {
        NSLog(@"aa%@",i);
    }
    for (NSString *i in beforeData) {
        NSLog(@"bbb%@",i);
    }
    
//    [self gi];
}

-(void)gi{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 20)];
    label.font = [UIFont boldSystemFontOfSize:20.0f];  //UILabel的字体大小
    label.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;  //文本对齐方式
    [label setBackgroundColor:[UIColor redColor]];
    
    
    //高度固定不折行，根据字的多少计算label的宽度
    NSString *str = @"高度不变获取宽度，获取字符串不折行单行显示时所需要的长度高度不变获取宽度，获取字符串不折行单行显示时所需要的长度";
    //    CGSize size = [str sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, label.frame.size.height)];
    //    CGSize size = CGSizeMake(220.0f,MAXFLOAT);
//    NSDictionary *attribute = @{NSFontAttributeName: label.font};
//    CGSize labelsize = [str boundingRectWithSize:label.frame.size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//    NSLog(@"size.width=%f, size.height=%f", labelsize.width, labelsize.height);
    //根据计算结果重新设置UILabel的尺寸
//    [label setFrame:CGRectMake(0, 10, labelsize.width, 20)];
    label.text = str;
    
    
    UIFont *font = [UIFont systemFontOfSize:15];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [str boundingRectWithSize:CGSizeMake(207, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
     NSLog(@"size.width=%f, size.height=%f", labelSize.width, labelSize.height);
    [label setFrame:CGRectMake(0, 0, labelSize.width, labelSize.height)];
    label.center = self.view.center;
    [self.view addSubview:label];
    
}

-(void)ok{
    
    MTAlertViewController *alert = [[MTAlertViewController alloc] initWithTitle:@"textestesetwetwerw wr tw 23 wrwe" message:@"sjdfpasdofqepo poj pqiej oijofa iljqe " ok:@"ok" cancel:@"cancel" alertType:TwoButton];
    __weak  UIViewController *weakVC = self;
    [alert showCustomAlertView:weakVC];
    
    
//    FiveStarViewController *star = [[FiveStarViewController alloc] initWithTitle:@"如果BeautyPlus给您带来美丽，请给我们五星好评吧~您的鼓励与支持是我们最大的动力" ok:@"去好评" cancel:@"下一次"];
//    star.didstar = ^(BOOL did){
//        if (did) {
//            NSLog(@"eeeeeeeee");
//            NSString *strComment = [NSString stringWithFormat:
//                                    @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",
//                                    @"622434129"];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strComment]];
//        }
//        else
//            NSLog(@"sssssss");
//    };
//    __weak  UIViewController *weakVC = self;
//    [star showStarComment:weakVC];
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
