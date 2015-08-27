//
//  MTAssetsViewController.m
//  CollectDemo
//
//  Created by mtt0156 on 14-4-2.
//  Copyright (c) 2014年 lin zhibin. All rights reserved.
//

#import "MTAssetsViewController.h"
#import "MyPageViewController.h"
#import "PageViewControllerData.h"
#import "AlbumAuthoryHelpView.h"

@interface MTAssetsViewController ()

@property (nonatomic, strong) UIImageView *tempImage;

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property(nonatomic, strong) UIButton *leftbutton;
@property(nonatomic, strong) UIButton *rightbutton;
@property(nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *customNavView;

@end

@implementation MTAssetsViewController

@synthesize groupCollection,assets,assetsGroup,tempImage;
@synthesize leftbutton,rightbutton,titleLabel,customNavView;


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showNav{
    
    customNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [customNavView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:customNavView];
    
    leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];

    [leftbutton setTitle:NSLocalizedString(@"GUI_TEXT_ASSETS_CAMERAROLL", @"GUI_TEXT_ASSETS_CAMERAROLL") forState:UIControlStateNormal];
   
    [leftbutton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [leftbutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [leftbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [leftbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [leftbutton setImage:[UIImage imageNamed:@"topbar_btn_back"] forState:UIControlStateNormal];
    [leftbutton.titleLabel setFont:[UIFont fontWithName:Custom_Font_Family_2 size:18]];
    [leftbutton setFrame:CGRectMake(5, 7, 120, 30)];
    [leftbutton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [customNavView addSubview:leftbutton];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 7, 160, 30)];
    [titleLabel setText:NSLocalizedString(@"GUI_TEXT_ASSETS_CAMERAROLL", @"GUI_TEXT_ASSETS_CAMERAROLL")];
    [titleLabel setFont:[UIFont fontWithName:Custom_Font_Family_1 size:20]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    
    [customNavView addSubview:titleLabel];
    
    rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbutton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton setImage:[UIImage imageNamed:@"相册_btn_关闭"] forState:UIControlStateNormal];
    [rightbutton setFrame:CGRectMake(276, 0, 40, 40)];
    [customNavView addSubview:rightbutton];
    
}


- (ALAssetsLibrary *)defaultAssetsLibrary {
	static dispatch_once_t pred = 0;
	static ALAssetsLibrary *library = nil;
	dispatch_once(&pred, ^{
		library = [[ALAssetsLibrary alloc] init];
	});
	return library;
}

//没有权限页面
-(void)noPermissionView{
    
    AlbumAuthoryHelpView *helpView = [[[NSBundle mainBundle] loadNibNamed:@"AlbumAuthoryHelpView" owner:self options:nil] firstObject];
    helpView.frame = CGRectMake(0, 44, 320, self.view.frame.size.height-44);
    [self.view addSubview:helpView];
    [self.view bringSubviewToFront:helpView];
    
}

-(NSMutableArray *)loadImageFromSavePhoto{
    
    __block NSMutableArray*   photoPages = [[NSMutableArray alloc] init];
    
    __block NSMutableArray*  tempArrays = [[NSMutableArray alloc] init];
    
    
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
                    photoPages = [NSMutableArray arrayWithArray:tempArray];
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
                
                if ([photoPages count] == 0) {
                    
                    
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
            
            if ([photoPages count] > 0) {
                self.assets = photoPages;
                [self.groupCollection reloadData];
            }
            else{
                
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"GUI_TEXT_ASSETS_PHOTOS_NULL", @"GUI_TEXT_ASSETS_PHOTOS_NULL")
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"GUI_TEXT_CAMERA_AUTHORISE_OK", @"GUI_TEXT_CAMERA_AUTHORISE_OK")
                                                      otherButtonTitles:nil, nil];
                
                [alert show];
                
            }
            
        });
    });
    
    return  photoPages;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showNav];
    if (groupCollection == nil) {
        
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(80, 80);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        //    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        groupCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44) collectionViewLayout:flowLayout];
        groupCollection.dataSource=self;
        groupCollection.delegate=self;
//        [groupCollection setBackgroundColor:[UIColor blackColor]];
        //        grouppersons.alpha = 0.0f;
        //        grouppersons.userInteractionEnabled = NO;
        [groupCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewIdentifier"];
        
        [self.view addSubview:groupCollection];
        //        [grouppersons selectItemAtIndexPath:[NSIndexPath indexPathWithIndex:_currentPageIndex] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
        //        [grouppersons scrollToItemAtIndexPath:[NSIndexPath indexPathWithIndex:(_currentPageIndex-1)]  atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }
}


-(void)showAllPhotos{
    
    if (groupCollection == nil) {
        
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(80, 80);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        //    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        groupCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(-320, 44, 320, self.view.frame.size.height-44) collectionViewLayout:flowLayout];
        groupCollection.dataSource=self;
        groupCollection.delegate=self;
        [groupCollection setBackgroundColor:[UIColor blackColor]];
        //        grouppersons.alpha = 0.0f;
        //        grouppersons.userInteractionEnabled = NO;
        [groupCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewIdentifier"];
        
        [self.view addSubview:groupCollection];
        //        [grouppersons selectItemAtIndexPath:[NSIndexPath indexPathWithIndex:_currentPageIndex] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
        //        [grouppersons scrollToItemAtIndexPath:[NSIndexPath indexPathWithIndex:(_currentPageIndex-1)]  atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }
    
    
}
//- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition{



//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [assets count];
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
    ALAsset *asset = [assets objectAtIndex:indexPath.row];
    UIImage* photoThumbnail = [UIImage imageWithCGImage:asset.thumbnail];
    
    UIImageView *myimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
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
//    UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    
    /*
    UICollectionViewCell *cell = [self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"%f",cell.frame.origin.y);
    tempImage = [[UIImageView alloc] initWithFrame:cell.frame];
    ALAsset *asset = [assets objectAtIndex:indexPath.row];
    UIImage* photo = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    tempImage.image = photo;
    tempImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:tempImage];
    [UIView animateWithDuration:2.
                          delay:0.
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [tempImage setFrame:self.view.frame];}
                     completion:^(BOOL finished) {
                     
                         [UIView animateWithDuration:2.0 delay:0. options:UIViewAnimationOptionCurveEaseInOut animations:^{
                             [tempImage setFrame:cell.frame];
                             NSLog(@"%f",cell.frame.origin.y);
                         } completion:^(BOOL finished) {
                             [tempImage removeFromSuperview];
                             tempImage = nil;
                         }];
                         
                     }];
    */
    [PageViewControllerData sharedInstance].photoAssets = self.assets;
    MyPageViewController *pageview = [[MyPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageview.backtitlestr = _titlestr;
    NSIndexPath *selectedCell = [self.groupCollection indexPathsForSelectedItems][0];
    pageview.startingIndex = selectedCell.row;
    [self.navigationController pushViewController:pageview animated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    if (!self.assets) {
        assets = [[NSMutableArray alloc] init];
    } else {
        [self.assets removeAllObjects];
    }
    
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [self.assets addObject:result];
        }
        else{
            [self.groupCollection reloadData];
        }
    };
    
    ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
    [self.assetsGroup setAssetsFilter:onlyPhotosFilter];
    [self.assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    titleLabel.text = _titlestr;
//    [self.groupCollection performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
