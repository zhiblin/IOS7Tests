//
//  MTPictureViewController.m
//  CollectDemo
//
//  Created by mtt0156 on 14-3-25.
//  Copyright (c) 2014年 lin zhibin. All rights reserved.
//

#import "MTPictureViewController.h"
#import "AlbumAuthoryHelpView.h"
#import "MBProgressHUD.h"
#import "PomeloSettingState.h"
#import "MTPictureCell.h"

@interface MTPictureViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSIndexPath *lastIndexPath;
    //网格frame
    CGRect grouppersonsFrame;
    //预览Scroll frame
    CGRect scrollViewFrame;
    //相册列表 frame
    CGRect groupsFrame;
    //标题名称
    NSString *titleTextString;
    
    __weak id  _becomeActiveNotification;
    __weak id  _resignActiveNotification;
}

@property (nonatomic, strong) UIButton *toGridBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@property (nonatomic, strong) UITableView *groupsTable;
@property (nonatomic, copy) NSString *titleTextString;
@property (nonatomic, strong) NSMutableArray *titleImages;

@property (nonatomic, strong) NSMutableArray *tempArrays;


@end


static const NSTimeInterval kDelayTime = 0.6;

@implementation MTPictureViewController

@synthesize _currentPageIndex;
@synthesize toGridBtn,backBtn,doneBtn;
@synthesize FromCamera,FromBeautyCenter;
@synthesize delegate;
@synthesize grouppersons;
@synthesize _photoPages;
@synthesize titleView;
@synthesize groups;
@synthesize titleLabel;
@synthesize groupsTable;
@synthesize titleTextString;
@synthesize titleImages;
@synthesize tempArrays;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _photoPages = [[NSMutableArray alloc] init];
    groups = [[NSMutableArray alloc] init];
    titleImages = [[NSMutableArray alloc] init];
    tempArrays = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor blackColor];
    
    
    if (FromBeautyCenter) {
        
        viewStatus = 2;
        titleTextString = TEXT(@"GUI_TEXT_ASSETS_CAMERAROLL");
        groupsFrame = CGRectMake(-320, 44, 320, self.view.frame.size.height-44);
        grouppersonsFrame = CGRectMake(0, 44, 320, self.view.frame.size.height-44);
        scrollViewFrame = CGRectMake(0, 0, 320, self.view.frame.size.height);
        
        
    }
    else{
        groupsFrame = CGRectMake(-320, 44, 320, self.view.frame.size.height-44);
        grouppersonsFrame = CGRectMake(-320, 44, 320, self.view.frame.size.height-44);
        scrollViewFrame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    }
    
    [self loadImageFromLibrarys];
    [self showScroll];
    
    [self showNav];
    
    [self showAllPhotos];
    if (FromBeautyCenter) {
        [self showAssetGroup];
    }
}

//相册读取


- (ALAssetsLibrary *)defaultAssetsLibrary {
	static dispatch_once_t pred = 0;
	static ALAssetsLibrary *library = nil;
	dispatch_once(&pred, ^{
		library = [[ALAssetsLibrary alloc] init];
	});
	return library;
}
//加载所有相册
-(void)loadGroups{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
    if (!self.assetsLibrary)
        self.assetsLibrary = [self defaultAssetsLibrary];
    
    if (!self.groups)
        self.groups = [[NSMutableArray alloc] init];
    else
        [self.groups removeAllObjects];
    
    if (!self.titleImages)
        self.titleImages = [[NSMutableArray alloc] init];
    else
        [self.titleImages removeAllObjects];
    
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group)
        {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            
//            NSLog(@"%i",group.numberOfAssets);
            
            if (group.numberOfAssets > 0){
                
                if ([self.groups count] == 0) {
                    [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets]-1] options:NSEnumerationConcurrent usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                        
                        if (result) {
                            
                            [titleImages addObject:[UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage]];
                        }
                        
                    }];
                }
                else{
                    [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:0] options:NSEnumerationConcurrent usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                    if (result) {
                    
                        [titleImages addObject:[UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage]];
                    }
                
                    }];
                }
                
                [self.groups addObject:group];
            }
        }
        else
        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//            [self.groupsTable reloadData];
//            });
        }
    };
    
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        
        [self noPermissionView];
        
    };
    
    // Enumerate Camera roll first
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
    
    // Then all other groups
    NSUInteger type =
    ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent |
    ALAssetsGroupFaces | ALAssetsGroupPhotoStream;
    
    [self.assetsLibrary enumerateGroupsWithTypes:type
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
//    });
}

-(void)loadAssetsWithGroup{
    
    titleTextString = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    titleLabel.text = titleTextString;
    
    
    if (!self._photoPages)
        self._photoPages = [[NSMutableArray alloc] init];
    else
        [self._photoPages removeAllObjects];
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        
        if (asset)
        {
            [self._photoPages addObject:asset];
            
            
        }
        
        else if (self._photoPages.count > 0)
        {
            NSArray *tempArray = [[self._photoPages reverseObjectEnumerator] allObjects];
            self._photoPages = nil;
            self._photoPages = [NSMutableArray arrayWithArray:tempArray];
            tempArray = nil;
            _currentPageIndex = self._photoPages.count - 1;
            [self.grouppersons reloadData];
        }
    };
    
    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
    
}


-(void)loadImageFromLibrarys{
    
    if (!_photoPages)
        _photoPages = [[NSMutableArray alloc] init];
    
    else
        [_photoPages removeAllObjects];
    if (!tempArrays)
        tempArrays = [[NSMutableArray alloc] init];
    else
        [tempArrays removeAllObjects];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //创建信号量
        dispatch_semaphore_t semaphore1 = dispatch_semaphore_create(0);
        dispatch_semaphore_t semaphore2 = dispatch_semaphore_create(0);
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
            
            if (result!=nil) {
                // 检查是否是照片，还可能是视频或其它的
                // 所以这里我们还能类举出枚举视频的方法。。。
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    [tempArrays addObject:result];
                    
                }
            }
            else{
                //当某个group取完毕后，信号量加1，dispatch_semaphore_wait方法执行，信号量为0，程序循环，去取下一个group中的result
                if ([tempArrays count] > 0) {
                    
                    NSArray *tempArray = [[tempArrays reverseObjectEnumerator] allObjects];
                    [tempArrays removeAllObjects];
                    tempArrays = nil;
                    self._photoPages = [NSMutableArray arrayWithArray:tempArray];
                    tempArray = nil;
                    
                }
                
                dispatch_semaphore_signal(semaphore2);
                
            }
            
        };
        
        
        ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
            
            if (group!=nil)
            {
                NSLog(@"%@",group);
//                [groups addObject:group];
                [group enumerateAssetsUsingBlock:groupEnumerAtion];
                dispatch_semaphore_wait(semaphore2, DISPATCH_TIME_FOREVER);
                
            }else{
                //当所有group取完后，信号量加1，程序不再阻塞，进入界面线程。
                dispatch_semaphore_signal(semaphore1);
            }
            
        };
        
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *error){
            //显示没有权限页面
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self noPermissionView];
                
                if ([_photoPages count] == 0) {
                    
                    [toGridBtn removeFromSuperview];
                    [doneBtn removeFromSuperview];
                    
                }
                
            });
            
            NSLog(@"failureblock:%@",error);
        };
        
        
        if (!self.assetsLibrary)
        self.assetsLibrary = [self defaultAssetsLibrary];
        
        [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
        
        dispatch_semaphore_wait(semaphore1, DISPATCH_TIME_FOREVER);

        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([_photoPages count] > 0) {
            _currentPageIndex = 0;

            
            [self updatePageViews];
            [grouppersons reloadData];
            }
            else{
                [grouppersons removeFromSuperview];
                [toGridBtn removeFromSuperview];
                [doneBtn removeFromSuperview];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:TEXT(@"GUI_TEXT_ASSETS_PHOTOS_NULL")
                                                               delegate:self
                                                      cancelButtonTitle:TEXT(@"GUI_TEXT_CAMERA_AUTHORISE_OK")
                                                      otherButtonTitles:nil, nil];
                
                [alert show];
                
            }
           
        });
    });
    
}


//没有权限页面
-(void)noPermissionView{
    
    AlbumAuthoryHelpView *helpView = [[[NSBundle mainBundle] loadNibNamed:@"AlbumAuthoryHelpView" owner:self options:nil] firstObject];
    helpView.frame = CGRectMake(0, 44, 320, self.view.frame.size.height-44);
    [self.view addSubview:helpView];
    [self.view bringSubviewToFront:helpView];
    
}


//头部和底部按钮
-(void)showNav{
    
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [titleView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:titleView];
    toGridBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (FromBeautyCenter) {
        
        [toGridBtn setTitle:TEXT(@"GUI_TEXT_ASSETS_PHOTOS") forState:UIControlStateNormal];
        
    }
    
    else {
        
        [toGridBtn setTitle:TEXT(@"GUI_TEXT_ASSETS_CAMERAROLL") forState:UIControlStateNormal];
        
    }
    
    [toGridBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [toGridBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [toGridBtn addTarget:self action:@selector(showCollection) forControlEvents:UIControlEventTouchUpInside];
    [toGridBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [toGridBtn setImage:[UIImage imageNamed:@"topbar_btn_back"] forState:UIControlStateNormal];
    [toGridBtn.titleLabel setFont:[UIFont fontWithName:Custom_Font_Family_2 size:18]];
    [toGridBtn setFrame:CGRectMake(5, 7, 120, 30)];
    [toGridBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [titleView addSubview:toGridBtn];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 7, 160, 30)];
    [titleLabel setText:TEXT(@"GUI_TEXT_ASSETS_CAMERAROLL")];
    [titleLabel setFont:[UIFont fontWithName:Custom_Font_Family_1 size:20]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    if (FromCamera) {
        [titleLabel setAlpha:0.0f];
    }
    [self.view addSubview:titleLabel];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    if (FromBeautyCenter) {
//        
        [backBtn setImage:[UIImage imageNamed:@"btn_取消"] forState:UIControlStateNormal];
//        
//    } else {
//        
//        [backBtn setImage:[UIImage imageNamed:@"相册_icon_camera-roll"] forState:UIControlStateNormal];
//    }
    [backBtn setFrame:CGRectMake(276, 0, 40, 40)];
    [titleView addSubview:backBtn];
    
    
    doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (FromBeautyCenter){
        [doneBtn setAlpha:0.0f];
        [doneBtn setUserInteractionEnabled:NO];
    }
    else{
        [doneBtn setAlpha:1.0f];
        [doneBtn setUserInteractionEnabled:YES];
    }
    [doneBtn setTitle:TEXT(@"GUI_TEXT_ASSETS_USE") forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneWithMBProgressHUD) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setFrame:CGRectMake(0, self.view.frame.size.height-44, 320, 44)];
    [doneBtn setImage:[UIImage imageNamed:@"相册_使用"] forState:UIControlStateNormal];
    [doneBtn setImage:[UIImage imageNamed:@"相册_使用"] forState:UIControlStateHighlighted];
    
    [doneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [doneBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5.0, 0.0, 0.0)];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont fontWithName:Custom_Font_Family_2 size:18]];
    [doneBtn setBackgroundImage:[self rectImageWithColor:RGBACOLOR(251.0, 76.0, 105.0, 1.0) size:doneBtn.frame.size] forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:[self rectImageWithColor:RGBCOLOR(182.0, 65.0, 86.0) size:doneBtn.frame.size] forState:UIControlStateSelected];
    [doneBtn setBackgroundImage:[self rectImageWithColor:RGBCOLOR(182.0, 65.0, 86.0) size:doneBtn.frame.size] forState:UIControlStateHighlighted];
    [doneBtn setAdjustsImageWhenHighlighted:YES];
    [self.view addSubview:doneBtn];
    
    
    
}

-(UIImage *)rectImageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

-(void)showCollection{
    
    if (FromBeautyCenter) {
        if (viewStatus == 2) {
            viewStatus = 1;
//            [self loadGroups];
            [self.groupsTable reloadData];
            [UIView animateWithDuration:0.4f animations:^{
                [grouppersons setFrame:CGRectMake(320, 44, 320, self.view.frame.size.height-44)];
                
                //            [_scrollView setFrame:CGRectMake(320, 44, 320, self.view.frame.size.height-88)];
                [groupsTable setFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
                toGridBtn.alpha = 0.0f;
                _scrollView.alpha = 0.0f;
                titleLabel.alpha = 1.0f;
                [doneBtn setAlpha:0.0f];
                [doneBtn setUserInteractionEnabled:NO];
                titleLabel.text = TEXT(@"GUI_TEXT_ASSETS_PHOTOS");
            } completion:^(BOOL finished) {
                toGridBtn.userInteractionEnabled = NO;
                _scrollView.userInteractionEnabled = NO;
            }];
        }
        else if (viewStatus == 3){
            viewStatus = 2;
            
            [UIView animateWithDuration:0.4f animations:^{
                [grouppersons setFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
                
                [_scrollView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//                toGridBtn.alpha = 0.0f;
                [toGridBtn setTitle:TEXT(@"GUI_TEXT_ASSETS_PHOTOS") forState:UIControlStateNormal];
                _scrollView.alpha = 0.0f;
                titleLabel.alpha = 1.0f;
                [doneBtn setAlpha:0.0f];
                [doneBtn setUserInteractionEnabled:NO];
            } completion:^(BOOL finished) {
//                toGridBtn.userInteractionEnabled = NO;
                _scrollView.userInteractionEnabled = NO;
                
            }];
            
        }
        else {
            
            viewStatus = 2;
            
            [UIView animateWithDuration:0.4f animations:^{
                
                [groupsTable setFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
                [grouppersons setFrame:CGRectMake(320, 44, 320, self.view.frame.size.height-44)];
                
                [_scrollView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
                toGridBtn.alpha = 0.0f;
                _scrollView.alpha = 0.0f;
                titleLabel.alpha = 1.0f;
            } completion:^(BOOL finished) {
                
                _scrollView.userInteractionEnabled = NO;
            }];
        }
        
    }
    else{
    
    [UIView animateWithDuration:0.4f animations:^{
        [grouppersons setFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];

        [_scrollView setFrame:CGRectMake(320, 0, 320, self.view.frame.size.height)];
        toGridBtn.alpha = 0.0f;
        _scrollView.alpha = 0.0f;
        titleLabel.alpha = 1.0f;
        doneBtn.alpha = 0.0f;
    } completion:^(BOOL finished) {
        toGridBtn.userInteractionEnabled = NO;
        _scrollView.userInteractionEnabled = NO;
        doneBtn.userInteractionEnabled = NO;
    }];
    }
}



-(void)back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)doneWithMBProgressHUD{
    [doneBtn setBackgroundImage:[self rectImageWithColor:RGBCOLOR(182.0, 65.0, 86.0) size:doneBtn.frame.size] forState:UIControlStateNormal];
    [doneBtn setUserInteractionEnabled:NO];
//    [doneBtn setEnabled:NO];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
//	hud.labelText = TEXT(@"GUI_TEXT_SAVE_STATUS_SAVING");
    hud.minShowTime = 1.0f;
    hud.removeFromSuperViewOnHide = YES;
    [hud showWhileExecuting:@selector(done) onTarget:self withObject:nil animated:YES];
    
}

-(void)done{
    
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *coverImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    ALAsset *asset = [_photoPages objectAtIndex:_currentPageIndex];
    UIImage *fullImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage scale:asset.defaultRepresentation.scale orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
    fullImage = [fullImage imageWithMaxLength:(int)[PomeloSettingState pictureSize]];
    NSDictionary *photoinfo = [[NSDictionary alloc] initWithObjectsAndKeys:fullImage,UIImagePickerControllerOriginalImage,asset.defaultRepresentation.metadata,@"metadata", nil];
    fullImage = nil;
    [self.groups removeAllObjects];
    [self._photoPages removeAllObjects];
    self.groups = nil;
    self._photoPages = nil;
    [delegate imagePickerViewController:self didFinishPickerALAssetWith:photoinfo coverImage:coverImage];
    
}


-(UIImage *)getPhotoByIndex:(NSInteger )index bigORsmall:(BOOL)bs{
    
    UIImage* imageCurrent = nil;
    ALAsset *asset = [_photoPages objectAtIndex:index];
    if (bs) {
        
        imageCurrent = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
    }
    else{
        
        imageCurrent = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
        
    }
    
    return imageCurrent;
}


- (void)updatePageViews
{
    
    _scrollView.contentSize = CGSizeMake(_photoPages.count * _scrollView.frame.size.width, _scrollView.frame.size.height);
    [_scrollView setContentOffset:CGPointMake(_currentPageIndex * _scrollView.frame.size.width, 0) animated:NO];
    
    CGSize pageSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height);
    _currentPageView.frame = CGRectMake(_scrollView.contentOffset.x, 0,
                                        pageSize.width, pageSize.height);
    _currentPageView.image = [self getPhotoByIndex:_currentPageIndex bigORsmall:YES];
    
    
    _prevPageView.frame = CGRectMake(_currentPageView.frame.origin.x - pageSize.width, 0,
                                     pageSize.width, pageSize.height);
    if (_currentPageIndex > 0)
    {
        _prevPageView.image = [self getPhotoByIndex:(_currentPageIndex - 1) bigORsmall:YES];
    }
    
    _nextPageView.frame = CGRectMake(_currentPageView.frame.origin.x + pageSize.width, 0,
                                     pageSize.width, pageSize.height);
    if (_currentPageIndex < _photoPages.count - 1)
    {
        _nextPageView.image = [self getPhotoByIndex:(_currentPageIndex + 1) bigORsmall:YES];
    }
    
    _currentPageView.alpha = _prevPageView.alpha = _nextPageView.alpha = 1;
    
}

-(void)showScroll{
    
    if (_scrollView == nil) {
        CGRect screenBounds = CGRectMake(0, 0, 320, self.view.bounds.size.height);
        _scrollView = [[UIScrollView alloc] initWithFrame:screenBounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.contentSize = screenBounds.size; //self.view.frame.size;
        if (FromBeautyCenter) {
            _scrollView.alpha = 0.0;
        } else {
            _scrollView.alpha = 1.0;
        }
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
        _prevPageView = [[UIImageView alloc] initWithFrame:screenBounds];
        _prevPageView.backgroundColor = [UIColor clearColor];
        _prevPageView.clipsToBounds = YES;
        _prevPageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:_prevPageView];
        
        _currentPageView = [[UIImageView alloc] initWithFrame:screenBounds];
        _currentPageView.backgroundColor = [UIColor clearColor];
        _currentPageView.clipsToBounds = YES;
        _currentPageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:_currentPageView];
        
        _nextPageView = [[UIImageView alloc] initWithFrame:screenBounds];
        _nextPageView.backgroundColor = [UIColor clearColor];
        _nextPageView.clipsToBounds = YES;
        _nextPageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:_nextPageView];
        
        
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_delayTimer invalidate];
    _delayTimer = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGSize pageSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height);
    NSInteger page = floor((scrollView.contentOffset.x - pageSize.width / 2) / pageSize.width) + 1;
    
    if (_currentPageIndex == page || page > _photoPages.count - 1 || page < 0)
    {
        return;
    }
    
    UIImageView *tempPageView;
    
    UIImage *imageCurrent = nil;
    
    if (_currentPageIndex + 1 == page)
    {
        tempPageView = _currentPageView;
        _currentPageView = _nextPageView;
        _nextPageView = _prevPageView;
        _prevPageView = tempPageView;
        
        if ((page + 1) < _photoPages.count)
        {
            
            imageCurrent = [self getPhotoByIndex:(page + 1) bigORsmall:NO];
        }
        _nextPageView.image = imageCurrent;
    }
    else
    {
        tempPageView = _currentPageView;
        _currentPageView = _prevPageView;
        _prevPageView = _nextPageView;
        _nextPageView = tempPageView;
        
        if ((page - 1) >= 0)
        {
            
            imageCurrent = [self getPhotoByIndex:(page - 1) bigORsmall:NO];
            
        }
        
        _prevPageView.image = imageCurrent;
        
    }
    
    _currentPageIndex = page;
    _currentPageView.frame = CGRectMake(_currentPageIndex * pageSize.width, 0,
                                        pageSize.width, pageSize.height);
    _prevPageView.frame = CGRectMake(_currentPageView.frame.origin.x - pageSize.width, 0,
                                     pageSize.width, pageSize.height);
    _nextPageView.frame = CGRectMake(_currentPageView.frame.origin.x + pageSize.width, 0,
                                     pageSize.width, pageSize.height);
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadPageViewsDelay];
}

#pragma mark -
#pragma mark Private
- (void)loadPageViewsDelayed
{
    _delayTimer = nil;
    
    _currentPageView.image = [self getPhotoByIndex:_currentPageIndex bigORsmall:YES];
    
    if (_currentPageIndex > 0)
    {
        _prevPageView.image = [self getPhotoByIndex:(_currentPageIndex - 1) bigORsmall:YES];
    }
    
    if (_currentPageIndex < _photoPages.count - 1)
    {
        _nextPageView.image = [self getPhotoByIndex:(_currentPageIndex + 1) bigORsmall:YES];
    }
}

- (void)loadPageViewsDelay
{
    [_delayTimer invalidate];
    _delayTimer = [NSTimer  scheduledTimerWithTimeInterval:kDelayTime target:self selector:@selector(loadPageViewsDelayed) userInfo:nil repeats:NO];
}


///网格展示图片



-(void)showAllPhotos{
    
    
    
    if (grouppersons == nil) {
        
        
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(78, 78);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        //    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        grouppersons = [[UICollectionView alloc] initWithFrame:grouppersonsFrame collectionViewLayout:flowLayout];
        grouppersons.dataSource=self;
        grouppersons.delegate=self;
        [grouppersons setBackgroundColor:[UIColor clearColor]];

        [grouppersons registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewIdentifier"];
        
        [self.view addSubview:grouppersons];
        
    }
    
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    
    return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_photoPages count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *kCellID = @"CollectionViewIdentifier";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    if (kCellID == nil) {
        
        cell = [[UICollectionViewCell alloc] init];
        
    }
    
    else{
        // 删除cell中的子对象,刷新覆盖问题。
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    //    GroupInfo *ginfo = [self.personslist objectAtIndex:indexPath.row];
    ALAsset *asset = [_photoPages objectAtIndex:indexPath.row];
    UIImage* photoThumbnail = [UIImage imageWithCGImage:asset.thumbnail];
    
    UIImageView *myimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 78, 78)];
    //    [myimage setImageWithURL:[NSURL URLWithString:ginfo.headimage]
    //            placeholderImage:[UIImage imageNamed:@"qz_weizhiyonghu.png"]];
    myimage.image = photoThumbnail;
    myimage.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:myimage];
    
    
    return cell;
    
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewLayoutAttributes *attributes = [grouppersons layoutAttributesForItemAtIndexPath:indexPath];
   
    _currentPageIndex = indexPath.row;
    
    lastIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
    
    if (FromBeautyCenter) {
        viewStatus = 3;
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        [self showScroll];
        
        [doneBtn setAlpha:1.0f];
        [doneBtn setUserInteractionEnabled:YES];
        [self.view bringSubviewToFront:doneBtn];
        [self.view bringSubviewToFront:titleView];
        [self.view bringSubviewToFront:titleLabel];
        [self updatePageViews];
        [UIView animateWithDuration:0.4f animations:^{
            [_scrollView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
            [grouppersons setFrame:CGRectMake(-320, 44, 320, self.view.frame.size.height-44)];
            
            _scrollView.alpha = 1.0f;
            [toGridBtn setTitle:titleTextString forState:UIControlStateNormal];
            toGridBtn.alpha = 1.0f;
            titleLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            _scrollView.userInteractionEnabled = YES;
            
            toGridBtn.userInteractionEnabled = YES;
        }];
    } else {
        
    
    [self updatePageViews];
    [UIView animateWithDuration:0.4f animations:^{
        
        [_scrollView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        [grouppersons setFrame:CGRectMake(-320, 44, 320, self.view.frame.size.height-44)];
        
        _scrollView.alpha = 1.0f;
        toGridBtn.alpha = 1.0f;
        titleLabel.alpha = 0.0f;
        doneBtn.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        _scrollView.userInteractionEnabled = YES;
        
        toGridBtn.userInteractionEnabled = YES;
        
        doneBtn.userInteractionEnabled = YES;
    }];
    
    }
}

-(void)showAssetGroup{
    
    groupsTable = [[UITableView alloc] initWithFrame:groupsFrame style:UITableViewStylePlain];
    groupsTable.delegate = self;
    groupsTable.dataSource = self;
    groupsTable.backgroundColor = [UIColor clearColor];
//    [groupsTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    groupsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:groupsTable];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    MTPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[MTPictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ALAssetsGroup *assetsGroup = [self.groups objectAtIndex:indexPath.row];
    
   
    
    [cell setUpCell:[assetsGroup valueForProperty:ALAssetsGroupPropertyName] titieImage:[self.titleImages objectAtIndex:indexPath.row] index:indexPath];
    
    
    return cell;
}



#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 123+32;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.assetsGroup = [self.groups objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"PictrureGroupID"];
    [self loadAssetsWithGroup];
    
    [UIView animateWithDuration:0.4f animations:^{
        [groupsTable setFrame:CGRectMake(-320, 44, 320, self.view.frame.size.height-44)];
        [_scrollView setFrame:CGRectMake(320, 0, 320, self.view.frame.size.height)];
        [grouppersons setFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
        
        _scrollView.alpha = 0.0f;
        [toGridBtn setTitle:TEXT(@"GUI_TEXT_ASSETS_PHOTOS") forState:UIControlStateNormal];
        toGridBtn.alpha = 1.0f;
        [doneBtn setAlpha:0.0f];
        [doneBtn setUserInteractionEnabled:NO];

    } completion:^(BOOL finished) {
        
        _scrollView.userInteractionEnabled = NO;
        
        toGridBtn.userInteractionEnabled = YES;
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    _resignActiveNotification = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification
                                                                                  object:nil
                                                                                   queue:[NSOperationQueue mainQueue]
                                                                              usingBlock:^(NSNotification *note) {
                                                                                  if (_scrollView.alpha == 1)
                                                                                  doneBtn.userInteractionEnabled = NO;
                                                                                  
                                                                                  
                                                                              }];
    
    _becomeActiveNotification = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                                                     object:nil
                                                                                      queue:[NSOperationQueue mainQueue]
                                                                                 usingBlock:^(NSNotification *notification) {
                                                                                     
                                                                                     if (FromCamera)
                                                                                         [self loadImageFromLibrarys];
                                                                                     if (FromBeautyCenter) {
                                                                                         
                                                                                         
                                                                                       NSInteger row = [[NSUserDefaults standardUserDefaults] integerForKey:@"PictrureGroupID"];
                                                                                        
                                                                                         self.assetsGroup = [self.groups objectAtIndex:row];
                                                                                         [self loadAssetsWithGroup];
                                                                                         
                                                                                         if (_scrollView.alpha == 1)
                                                                                             
                                                                                            _currentPageView.image = nil;
                                                                                            _prevPageView.image = nil;
                                                                                            _nextPageView.image = nil;
                                                                                         
                                                                                             [self updatePageViews];

                                                                                         
                                                                                         doneBtn.userInteractionEnabled = YES;
                                                                                     }
                                                                                     
                                                                                 }];
    
}
*/

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (FromBeautyCenter){

            [self loadGroups];
//        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"PictrureGroupID"];

    }


}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:_becomeActiveNotification];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}



@end



