//
//  AlbumsTableViewController.m
//  IOS7Tests
//
//  Created by lzb on 15/8/27.
//  Copyright (c) 2015年 loaer. All rights reserved.
//

#import "AlbumsTableViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AlbumTableViewCell.h"
#import "AlbumViewController.h"

static NSString *CellIdentifier = @"PosterCell";
#define MTScreenWidth  [[UIScreen mainScreen] bounds].size.width
@interface AlbumsTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, strong) UIView *customNavView;
@property(nonatomic, strong) UIButton *leftbutton;
@property(nonatomic, strong) UIButton *rightbutton;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, assign) BOOL toCameraRoll;

@end

@implementation AlbumsTableViewController

@synthesize albums,customNavView,leftbutton,rightbutton,titleLabel,toCameraRoll;

+ (ALAssetsLibrary *)defaultAssetsLibrary {
  static dispatch_once_t pred = 0;
  static ALAssetsLibrary *library = nil;
  dispatch_once(&pred, ^{
    library = [[ALAssetsLibrary alloc] init];
  });
  return library;
}

- (id)initWithToCameraRoll:(BOOL)isto{
        
        self = [super init];
        if (self)
        {
            toCameraRoll = isto;
        }
        return self;
    
}

-(void)showNav{
    
    customNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenWidth, 44)];
    [customNavView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:customNavView];
    
    leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setTitle:@"返回" forState:UIControlStateNormal];
    
    
    [leftbutton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [leftbutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [leftbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [leftbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [leftbutton setImage:[UIImage imageNamed:@"topbar_btn_back"] forState:UIControlStateNormal];
    [leftbutton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeueLT-LightCond" size:15]];
    [leftbutton setFrame:CGRectMake(5, 7, 120, 30)];
    [leftbutton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [customNavView addSubview:leftbutton];
    
    
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((MTScreenWidth - 160)/2, 7, 160, 30)];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeueLT-LightCond" size:20]];
    
    titleLabel.text = @"选择照片";
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    
    [customNavView addSubview:titleLabel];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)setAlbumsArray {

  ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock =

      ^(ALAssetsGroup *group, BOOL *stop) {

        if (group.numberOfAssets != 0) {
              
        if (group != nil) {
          if (!albums) {
            albums = [NSMutableArray new];
          }
          
          if ([[group
                  valueForProperty:ALAssetsGroupPropertyType] integerValue] ==
              16) {
            //把相机胶卷添加到数组第一位
            [albums insertObject:group atIndex:0];
            //                NSLog(@"%@    %@",[group
            //                valueForProperty:ALAssetsGroupPropertyName],[group
            //                valueForProperty:ALAssetsGroupPropertyType]);
          } else
            [albums addObject:group];
            
        }
        } else {

          [self.groupsTable performSelectorOnMainThread:@selector(reloadData)

                                           withObject:nil
                                        waitUntilDone:YES];
        }

      };

  ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)

  {

    NSString *errorMessage = nil;

    switch ([error code]) {

    case ALAssetsLibraryAccessUserDeniedError:

    case ALAssetsLibraryAccessGloballyDeniedError:

      errorMessage = @"The user has declined access to it.";

      break;

    default:

      errorMessage = @"Reason unknown.";

      break;
    }

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Opps"

                                                        message:errorMessage
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"

                                              otherButtonTitles:nil, nil];

    [alertView show];

  };

  //    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent |
  //    ALAssetsGroupFaces | ALAssetsGroupLibrary | ALAssetsGroupPhotoStream;

  [[[self class] defaultAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos

                                                     usingBlock:listGroupBlock
                                                   failureBlock:failureBlock];
}

-(void)showAssetGroup{
    
    self.groupsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStylePlain];
    self.groupsTable.delegate = self;
    self.groupsTable.dataSource = self;
    [self.groupsTable registerClass:[AlbumTableViewCell class]
             forCellReuseIdentifier:CellIdentifier];
    self.groupsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.groupsTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.groupsTable];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

- (BOOL)prefersStatusBarHidden
{
    return YES; // 返回NO表示要显示，返回YES将hiden
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self showAssetGroup];
  [self setAlbumsArray];
  [self showNav];
  self.groupsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  AlbumTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                      forIndexPath:indexPath];
  if (cell == nil) {
    cell = [[AlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:CellIdentifier];
  } else {
    //删除cell的所有子视图
    while ([cell.contentView.subviews lastObject] != nil) {
      [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
  }
  ALAssetsGroup *group = [albums objectAtIndex:indexPath.row];
  CGImageRef posterImageRef = [group posterImage];
  UIImage *posterImage = [UIImage imageWithCGImage:posterImageRef];
  NSString *countString =
      [NSString stringWithFormat:@"%ld", (long)[group numberOfAssets]];
  [cell setCellImageView:posterImage
                   title:[group valueForProperty:ALAssetsGroupPropertyName]
                   count:countString];
  return cell;
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {

  return 88;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  AlbumViewController *album = [[AlbumViewController alloc]
      initWithGroup:[albums objectAtIndex:indexPath.row]];
  [self.navigationController pushViewController:album animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (toCameraRoll) {
        if (albums.count) {
            [self.navigationController pushViewController:[[AlbumViewController alloc]
                                                           initWithGroup:[albums objectAtIndex:0]] animated:NO];
            toCameraRoll = NO;
        }
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

@end
