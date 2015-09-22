//
//  AlbumViewController.m
//  IOS7Tests
//
//  Created by lzb on 15/8/27.
//  Copyright (c) 2015年 loaer. All rights reserved.
//

#import "AlbumViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "NextViewController.h"
#import "AlbumsTableViewController.h"
#define MTScreenWidth  [[UIScreen mainScreen] bounds].size.width
static NSString *CellIdentifier = @"PhotoCell";
@interface AlbumViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *assetArray;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) UIView *customNavView;
@property(nonatomic, strong) UIButton *leftbutton;
@property(nonatomic, strong) UIButton *rightbutton;
@property(nonatomic, strong) UILabel *titleLabel;
@end

@implementation AlbumViewController

@synthesize assetsCollectionView,assetArray,assetsGroup,customNavView,leftbutton,rightbutton,titleLabel;

-(id)initWithGroup:(ALAssetsGroup *)group{
    
    self = [super init];
    if (self)
    {
        assetsGroup = group;
    }
    return self;
}

-(void)showNav{
    
    customNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenWidth, 44)];
    [customNavView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:customNavView];
    
        leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftbutton setTitle:@"选择照片" forState:UIControlStateNormal];
        
        
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
    
    titleLabel.text = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    
    [customNavView addSubview:titleLabel];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
-(void)setUpCollectionView{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.assetsCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-44)  collectionViewLayout:flowLayout];
    //注册
    [self.assetsCollectionView registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:CellIdentifier];
    //设置代理
    self.assetsCollectionView.delegate = self;
    self.assetsCollectionView.dataSource = self;
    self.assetsCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.assetsCollectionView];
}
-(void)filterImageWithGroup:(ALAssetsGroup *)group
{
    [self.assetArray removeAllObjects];
    ALAssetsGroupEnumerationResultsBlock groupEnumerAtion =
    ^(ALAsset *result,NSUInteger index, BOOL *stop)
    {
        if (result!=NULL)
        {
            if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto])
            {
                [self.assetArray addObject:result];
            }
        }
        else
        {
            //主线程中刷新UI
            [self.assetsCollectionView performSelectorOnMainThread:@selector(reloadData)
             
                                             withObject:nil waitUntilDone:YES];
            if(self.assetArray.count > 20)
            [self.assetsCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.assetArray.count-1 inSection:0]  atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        }
        
    };
    [group enumerateAssetsUsingBlock:groupEnumerAtion];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    assetArray = [NSMutableArray new];
    [self setUpCollectionView];
    [self filterImageWithGroup:assetsGroup];
    [self showNav];
}


#pragma mark - collectionView delegate
//设置分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return assetArray.count;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width=MTScreenWidth/4.0;
    return CGSizeMake(width, width);
}
//定义第一个和最后一个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        
        cell = [[UICollectionViewCell alloc] init];
        
    }
    
    else{
        // 删除cell中的子对象,刷新覆盖问题。
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    //    GroupInfo *ginfo = [self.personslist objectAtIndex:indexPath.row];
    ALAsset *asset = [assetArray objectAtIndex:indexPath.row];
    UIImage* photoThumbnail = [UIImage imageWithCGImage:asset.thumbnail];
    
    float width=MTScreenWidth/4.0-2;
    UIImageView *myimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    myimage.image = photoThumbnail;
    myimage.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:myimage];
    
    
    return cell;
    
}

//点击元素触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UIImage *t = [UIImage imageWithCGImage:[[[assetArray objectAtIndex:indexPath.row] defaultRepresentation] fullResolutionImage]];
    
    ALAsset *asset = [assetArray objectAtIndex:indexPath.row];
    UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage
                                           scale:asset.defaultRepresentation.scale
                                     orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
    AlbumsTableViewController* albums = (AlbumsTableViewController*)[[self.navigationController viewControllers] objectAtIndex:[self.navigationController viewControllers].count-2];
    if (albums.selectImage) {
        albums.selectImage(tempImg);
    }
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
