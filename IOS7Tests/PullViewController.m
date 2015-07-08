//
//  PullViewController.m
//  IOS7Tests
//
//  Created by lzb on 15/7/1.
//  Copyright (c) 2015年 loaer. All rights reserved.
//

#import "PullViewController.h"
#import "NextViewController.h"
#import "MSSPopMasonry.h"
#import "MTImageScrollView.h"


static CGFloat ImageHeight  = 72.0;
static CGFloat ImageWidth  = 76.0;

@interface PullViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) MTImageScrollView *scroll_view;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UILabel *pullRefreshLabel;
@property (nonatomic, strong) UIView *myview;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) BOOL down;
@property(nonatomic,strong) UIImageView *fakeView;
@property(nonatomic) BOOL updateWithDraging;

@end

@implementation PullViewController

@synthesize myview;


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [myview setCenter:self.view.center];
}
-(void)zoomView:(CGFloat)y{
    
    
}
- (void)objectDidDragged:(UIPanGestureRecognizer *)sender {
//    CGRect originalCenter = CGRectZero;
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"%@",NSStringFromCGPoint(sender.view.center));
//        originalCenter = center;
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
//        CGPoint pcenter = sender.view.center;
//        NSLog(@"%@",NSStringFromCGPoint(pcenter));
        
//        else{
//            down = NO;
//        }
        //注意，这里取得的参照坐标系是该对象的上层View的坐标。
        CGPoint offset = [sender translationInView:self.view];
        [self.backView setFrame:CGRectMake(0, 0, self.view.frame.size.width, offset.y)];
        //通过计算偏移量来设定draggableObj的新坐标
        [sender.view setCenter:CGPointMake(sender.view.center.x, sender.view.center.y + offset.y)];
        //初始化sender中的坐标位置。如果不初始化，移动坐标会一直积累起来。
        
        [sender setTranslation:CGPointMake(0, 0) inView:sender.view];
        if (sender.view.center.y >= [UIScreen mainScreen].bounds.size.height*0.75) {
//            pcenter.y = abs(pcenter.y + offset.y);
            _down = YES;
            
        }
        else{
            _down = NO;
        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded){
//            CGPoint p = [sender velocityInView:self.view];
//       
//            NSTimeInterval duration = fabs((([UIScreen mainScreen].bounds.size.height*0.75 - sender.view.center.y)/p.y));
//        NSLog(@"%f",duration);
        
        if (_down == YES) {
            [UIView animateWithDuration:0.66 animations:^{
                
                [sender.view setCenter:CGPointMake(sender.view.center.x, sender.view.center.y*3)];
                
            } completion:^(BOOL finished) {
                
                NextViewController *next = [[NextViewController alloc] init];
                [self.navigationController pushViewController:next animated:NO];
                
            }];
        }
        else{
            [UIView animateWithDuration:0.36 animations:^{
                [sender.view setCenter:self.view.center];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIImageView *myimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"倒计时3.png"]];
//    [myimage setFrame:CGRectMake(20, 0, 80, 80)];
//    [self.backView addSubview:myimage];
//    self.backView = [[UIView alloc] init];
//    self.backView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:self.backView];
//    
//    myview = [[UIView alloc] initWithFrame:self.view.frame];
//    myview.backgroundColor = [UIColor brownColor];
//    [self.view addSubview:myview];
////    self.view.backgroundColor = [UIColor blueColor];
//    //创建手势
//    UIPanGestureRecognizer *panGR =
//    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(objectDidDragged:)];
//    //限定操作的触点数
//    [panGR setMaximumNumberOfTouches:1];
//    [panGR setMinimumNumberOfTouches:1];
//    //将手势添加到draggableObj里
//    [myview addGestureRecognizer:panGR];
//    
//    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(-100.0);
//        make.left.mas_equalTo(0.0);
//        make.width.equalTo(self.myview);
//        make.height.mas_equalTo(100.0);
//    }];
//    // Do any additional setup after loading 45the view.

    self.view.backgroundColor = [UIColor redColor];
    UIImage *image = [UIImage imageNamed:@"下拉拍照"];
    self.imgProfile = [[UIImageView alloc] initWithImage:image];
    self.imgProfile.frame = CGRectMake(self.view.frame.size.width/2, 0, 1, 1);
    self.imgProfile.center = CGPointMake(self.view.frame.size.width/2, 0);
    
//    self.fakeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"倒计时1"]];
    UIView *my = [[UIView alloc] initWithFrame:self.view.frame];
    my.backgroundColor = [UIColor blackColor];
    CGRect frame = self.view.frame;
//    frame.origin.y = 0;
//    self.fakeView.frame = frame;
    
    self.scrollView = [[UIScrollView alloc] init];
//    [self.scrollView setFrame:self.view.bounds];
    self.scrollView.delegate = self;
//    self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.contentSize = CGSizeMake(320, frame.size.height+1);
    
    [self.scrollView addSubview:my];
    
    [self.view addSubview:self.imgProfile];
    [self.view addSubview:self.scrollView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.scrollView setFrame:self.view.bounds];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 下拉刷新
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;{
    _updateWithDraging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat yOffset   = self.scrollView.contentOffset.y;
    CGFloat maxHeight = self.view.frame.size.height/5;
    float zoom = ABS(yOffset)/maxHeight;
    NSLog(@";;;;;;;;;%f,,,%f,,,,%hhd",zoom,yOffset,_updateWithDraging);
    if (yOffset < 0 && _updateWithDraging && zoom <= 1) {
        CGRect f = self.imgProfile.frame;
        f.size = CGSizeMake(ImageWidth*zoom, ImageHeight*zoom);
        self.imgProfile.frame = f;
        self.imgProfile.center = CGPointMake(self.view.frame.size.width/2, ABS(yOffset)/2);
        
    }
    else{
        [scrollView setScrollEnabled:NO];
        [scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }

}

// 上拉继续获取
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat maxHeight = self.view.frame.size.height/5;
    
    if (fabs(offsetY) > maxHeight) {
        _updateWithDraging = NO;
        [scrollView setScrollEnabled:NO];
        [scrollView setContentInset:UIEdgeInsetsMake(-offsetY, 0, 0, 0)];
        [UIView animateWithDuration:(0.33/320*self.view.frame.size.height) animations:^{
            CGRect rect = scrollView.frame;
            rect.origin.y = scrollView.frame.size.height;
            scrollView.frame = rect;
            [self.imgProfile setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
        } completion:^(BOOL finished) {
          
            [self.navigationController pushViewController:[[NextViewController alloc] init] animated:NO];
            [scrollView setScrollEnabled:YES];
            [scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
            _updateWithDraging = NO;
        }];
    }

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
