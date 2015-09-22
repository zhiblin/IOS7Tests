//
//  AdViewController.m
//  IOS7Tests
//
//  Created by lzb on 15/9/7.
//  Copyright © 2015年 loaer. All rights reserved.
//

#import "AdViewController.h"
#import <AFNetworking-RACExtensions/AFHTTPRequestOperationManager+RACSupport.h>
#import "AdDataModel.h"
#define RAFN_MAINTAIN_COMPLETION_BLOCKS

@interface AdViewController ()


@property (nonatomic, strong) UITextView *statusTextView;
@property (nonatomic, strong) UIImageView *afLogoImageView;
@property (nonatomic, strong) UIButton *startTestingButton;
@property (nonatomic, strong) AFHTTPRequestOperationManager *httpClient;
@property (nonatomic, assign) BOOL isTesting;

@property (nonatomic, strong) RACDisposable *currentDisposable;
@property (nonatomic, strong) RACSubject *statusSignal;

@end

@implementation AdViewController

- (id)init {
    self = [super init];
    
    //Signal for the textview's text
    _statusSignal = [RACSubject subject];
    
    return self;
}

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    
    [super viewDidLoad];
    
    NSArray *farray = [NSArray arrayWithObjects:@"7",@"6",@"5",@"4",@"3",@"2",@"1", nil];
    for (NSString *s in farray) {
        
    }
    
}

-(void)initAF{
    
    CGRect slice, remainder;
    CGRectDivide(self.view.bounds, &slice, &remainder, 44, CGRectMaxYEdge);
    
    self.statusTextView = [[UITextView alloc]initWithFrame:remainder];
    self.statusTextView.editable = NO;
    self.statusTextView.font = [UIFont fontWithName:@"Helvetica" size:20.0f];
    [self.statusTextView setTextAlignment:NSTextAlignmentCenter];
    [self.statusTextView rac_liftSelector:@selector(setText:) withSignals:self.statusSignal, nil];
    
    self.afLogoImageView = [[UIImageView alloc]initWithFrame:CGRectOffset(remainder, 0, CGRectGetHeight(UIScreen.mainScreen.bounds))];
    self.startTestingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.startTestingButton setTitle:@"Start Testing" forState:UIControlStateNormal];
    self.startTestingButton.frame = self.view.bounds;
    
    [[self.startTestingButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *testingButton) {
        self.isTesting = !self.isTesting;
        [testingButton setTitle:(self.isTesting ? @"Cancel Testing..." : @"Start Testing") forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            [testingButton setFrame:(self.isTesting ? slice : self.view.bounds)];
        }];
        if (self.isTesting) {
            [self testImageFetch];
        } else {
            [self cancelTheShow];
            
        }
    }];
    
    [self.view addSubview:self.statusTextView];
    [self.view addSubview:self.afLogoImageView];
    [self.view addSubview:self.startTestingButton];
    
    //Get network status
    self.httpClient = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"https://www.google.com"]];
    self.httpClient.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self.httpClient.networkReachabilityStatusSignal subscribeNext:^(NSNumber *status) {
        AFNetworkReachabilityStatus networkStatus = [status intValue];
        switch (networkStatus) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:
                [self.statusSignal sendNext:@"Cannot Reach Host"];
                [self cancelTheShow];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                break;
        }
        
    }];
}

- (void)testImageFetch {
    //Fetch the image.  WHen fetched, animate the logo image up, then down and start the next test.
    [self.statusSignal sendNext:@"Fetching AFNetworking Logo..."];
    
    RACSubject *imageSubject = [RACSubject subject];
    [self.afLogoImageView rac_liftSelector:@selector(setImage:) withSignals:imageSubject, nil];
    
    NSString *urlStr = @"http://backend.beautyplus.com/beautyplusaddata/getbeautyplusad.json?lang=zh-Hant&debug_status=1&system=2";//@"http://img.xiaba.cvimage.cn/4d5b6e9ed1869ff4580e0000.jpg";
    self.httpClient.responseSerializer = [AFJSONResponseSerializer serializer];
    
    _currentDisposable = [[[self.httpClient rac_GET:urlStr parameters:nil] map:^id(RACTuple *value) {
        return [value first];
    }] subscribeNext:^(NSDictionary *adDataDic) {
        
        NSArray *AdsArray = [adDataDic objectForKey:@"beautyplusad"];
        for (NSDictionary *dict in AdsArray) {
            AdDataModel *ad = [[AdDataModel alloc] initWithDictionary:dict];
            NSLog(@"icon url %@",ad.iconurl);
        }
//        [imageSubject sendNext:image];
//        CGRect slice, remainder;
//        CGRectDivide(self.view.bounds, &slice, &remainder, 44, CGRectMaxYEdge);
//        [UIView animateWithDuration:0.5 animations:^{
//            [self.afLogoImageView setFrame:remainder];
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.5 delay:1 options:0 animations:^{
//                [self.afLogoImageView setFrame:CGRectOffset(remainder, 0, CGRectGetHeight(UIScreen.mainScreen.bounds))];
//            } completion:^(BOOL finished) {
//                [self testXMLFetch];
//            }];
//        }];
    }];
}

- (void)testXMLFetch {
    //Fetch the Flickr feed for groups.
    [self.statusSignal sendNext:@"Fetching Flickr XML..."];
    
    
    NSString *urlStr = @"http://api.flickr.com/services/rest/?method=flickr.groups.browse&api_key=b6300e17ad3c506e706cb0072175d047&cat_id=34427469792%40N01&format=rest";
    self.httpClient.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    _currentDisposable = [[[self.httpClient rac_GET:urlStr parameters:nil]map:^id(RACTuple *value) {
        return [value second];
    }] subscribeNext:^(NSHTTPURLResponse *response) {
        [self.statusSignal sendNext:response.allHeaderFields.description];
        
        [self performSelector:@selector(testError) withObject:nil afterDelay:0.5];
    }];
}

- (void)testError {
    [self.statusSignal sendNext:@"Sending Error-Prone Request..."];
    
    //Send an un-authorized request to show how error blocks work.
    NSString *urlStr = @"http://api.flickr.com/";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:@"json", @"format", @"66854529@N00", @"user_id", @"1", @"nojsoncallback", nil];
    NSString *path = [[NSString alloc]initWithFormat:@"services/rest/?method=flickr.people.getPhotos"];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:url];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    _currentDisposable = [[manager rac_GET:path parameters:params] subscribeError:^(NSError *error) {
        [self.statusSignal sendNext:[error localizedDescription]];
        
        [self performSelector:@selector(finish) withObject:nil afterDelay:0.5];
    }];
}

- (void)finish {
    [self.statusSignal sendNext:@"Finished!"];
    [self.startTestingButton setTitle:@"Restart Tests" forState:UIControlStateNormal];
    self.isTesting = !self.isTesting;
}

- (void)cancelTheShow {
    //Kills the current disposable and removes the image view.
    CGRect slice, remainder;
    CGRectDivide(self.view.bounds, &slice, &remainder, 44, CGRectMaxYEdge);
    
    [self.statusSignal sendNext:@""];
    [_currentDisposable dispose];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.afLogoImageView setFrame:CGRectOffset(remainder, 0, CGRectGetHeight(UIScreen.mainScreen.bounds))];
    }];
}

//@end
//
//@implementation AdViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]
//                                              initWithBaseURL:[NSURL URLWithString:@"http://backend.beautyplus.com/beautyplusaddata/getbeautyplusad.json?lang=zh-Hant&debug_status=1&system=2"]];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [[manager rac_GET:path parameters:params] subscribeNext:^(RACTuple *JSONAndHeaders) {
//        //Voila, a tuple with (JSON, HTTPResponse)
//    }];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
