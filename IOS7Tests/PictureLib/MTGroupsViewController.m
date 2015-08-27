//
//  MTGroupsViewController.m
//  CollectDemo
//
//  Created by mtt0156 on 14-4-1.
//  Copyright (c) 2014年 lin zhibin. All rights reserved.
//

#import "MTGroupsViewController.h"
#import "MTAssetsViewController.h"
#import "MTPictureCell.h"
#import "AlbumAuthoryHelpView.h"
#import "GroupTitleCell.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface MTGroupsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@property (nonatomic, strong) NSMutableArray *assets;

@property (nonatomic, strong) NSMutableDictionary *titleImages;
@property (nonatomic, strong) UIView *customNavView;

@property (assign) BOOL firstInit;

@end

@implementation MTGroupsViewController

@synthesize assetsLibrary,groups,groupsTable,assets,titleImages;
@synthesize rightbutton,titleLabel,customNavView;


- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//头部和底部按钮
-(void)showNav{
    
    customNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [customNavView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:customNavView];
   
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


//没有权限页面
-(void)noPermissionView{
    
    AlbumAuthoryHelpView *helpView = [[[NSBundle mainBundle] loadNibNamed:@"AlbumAuthoryHelpView" owner:self options:nil] firstObject];
    helpView.frame = CGRectMake(0, 44, 320, self.view.frame.size.height-44);
    [self.view addSubview:helpView];
    [self.view bringSubviewToFront:helpView];
    
}

- (ALAssetsLibrary *)defaultAssetsLibrary {
	static dispatch_once_t pred = 0;
	static ALAssetsLibrary *library = nil;
	dispatch_once(&pred, ^{
		library = [[ALAssetsLibrary alloc] init];
	});
	return library;
}

//创建目录
-(NSString *)createImagesTitle{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSLog(@"documentsDirectory%@",documentsDirectory);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *imagesDirectory = [documentsDirectory stringByAppendingPathComponent:@"titleImages"];
    // 创建目录
    [fileManager createDirectoryAtPath:imagesDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    return  imagesDirectory;
}

//保存文件
-(BOOL)saveImage:(UIImage *)image filename:(NSString *)name {
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[self createImagesTitle] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",name]];   // 保存文件的名称
    BOOL result = [UIImagePNGRepresentation(image)writeToFile: filePath    atomically:YES];
    
    return result;
}

//文件路径
-(NSString *)filepathstring:(NSString *)filename{
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[self createImagesTitle] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",filename]];
    return filePath;
}

//判断文件是否存在
-(BOOL)imageExistsAtPath:(NSString*)imagepath{
    
    return [[NSFileManager defaultManager] fileExistsAtPath:imagepath];
    
}

//加载所有相册
-(void)loadGroups{
    
    if (!self.assetsLibrary)
        self.assetsLibrary = [self defaultAssetsLibrary];
    
    if (!self.groups)
        self.groups = [[NSMutableArray alloc] init];
    else
        [self.groups removeAllObjects];
    
    if (!self.titleImages)
        self.titleImages = [[NSMutableDictionary alloc] init];
    else
        [self.titleImages removeAllObjects];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group)
        {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
//            NSLog(@"group.numberOfAssets%i",group.numberOfAssets);
            if (group.numberOfAssets > 0){
                NSLog(@"type %@  %i",[group valueForProperty:ALAssetsGroupPropertyType],[[group valueForProperty:ALAssetsGroupPropertyType] intValue]);
                
                if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == 16) {
                    [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets]-1] options:NSEnumerationConcurrent usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                        
                        if (result) {
                            if ([self imageExistsAtPath:[self filepathstring:[group valueForProperty:ALAssetsGroupPropertyName]]]) {
                                UIImage *tempimage = [UIImage imageWithContentsOfFile:[self filepathstring:[group valueForProperty:ALAssetsGroupPropertyName]]];
                                
                                [titleImages setObject:tempimage forKey:[group valueForProperty:ALAssetsGroupPropertyName]];
                            } else {
                                UIImage *tempimage = [UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage];
                                tempimage = [tempimage thumbnailWithSize:CGSizeMake(320, 123+32)];
                                [self saveImage:tempimage filename:[group valueForProperty:ALAssetsGroupPropertyName]];
                                [titleImages setObject:tempimage forKey:[group valueForProperty:ALAssetsGroupPropertyName]];
                                
                                tempimage = nil;
                            }
                            
                            [self.groups insertObject:group atIndex:0];
                            
                        }
                        
                    }];

                }
                else{
                    [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:0] options:NSEnumerationConcurrent usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    
                    if (result) {
                        if ([self imageExistsAtPath:[self filepathstring:[group valueForProperty:ALAssetsGroupPropertyName]]]) {
                            
                            UIImage *tempimage = [UIImage imageWithContentsOfFile:[self filepathstring:[group valueForProperty:ALAssetsGroupPropertyName]]];
                            
                            [titleImages setObject:tempimage forKey:[group valueForProperty:ALAssetsGroupPropertyName]];
                        }
                        else {
                            UIImage *tempimage = [UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage];
                            tempimage = [tempimage thumbnailWithSize:CGSizeMake(320, 123+32)];
                            [self saveImage:tempimage filename:[group valueForProperty:ALAssetsGroupPropertyName]];
                        
                            [titleImages setObject:tempimage forKey:[group valueForProperty:ALAssetsGroupPropertyName]];
                            tempimage = nil;
                        }
                        
                        [self.groups addObject:group];
                    }
                    
                }];
                    
            }
                
               
                
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.groupsTable reloadData];
                [self firstIn];
            });
        }
    };
    
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        
//        [self noPermissionView];
        
    };
    
    // Enumerate Camera roll first
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
    if (!_FromCamera) {
    // Then all other groups
    NSUInteger type =
    ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent |
        ALAssetsGroupFaces ;//| ALAssetsGroupPhotoStream;
    
    [self.assetsLibrary enumerateGroupsWithTypes:type
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
    }
        
    });
}

-(void)loadAssetsWithGroup:(ALAssetsGroup *)assetsGroup{
    
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    else
        [self.assets removeAllObjects];
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        
        if (asset)
        {
            [self.assets addObject:asset];
            
            
        }
        
        else if (self.assets.count > 0)
        {
            
            NSArray *tempArray = [[self.assets reverseObjectEnumerator] allObjects];
            [self.assets removeAllObjects];
            self.assets = [NSMutableArray arrayWithArray:tempArray];
            tempArray = nil;
            MTAssetsViewController *mtpView = [[MTAssetsViewController alloc] init];
            mtpView.assets = self.assets;
            [self.navigationController pushViewController:mtpView animated:YES];
        }
    };
    
    [assetsGroup enumerateAssetsUsingBlock:resultsBlock];
    
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    ALAssetsGroup *assetsGroup = [self.groups objectAtIndex:indexPath.row];
    
    
    UIImageView* titleImage  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 123+32)];
    titleImage.contentMode = UIViewContentModeScaleAspectFill;
    titleImage.clipsToBounds = YES;
    titleImage.image = [titleImages objectForKey:[assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
    [cell.contentView addSubview:titleImage];
    
    UIImageView* titleBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 91+32, 320, 32)];
    //        titleBackground.backgroundColor = [UIColor blackColor];
    titleBackgroundImage.alpha = .7;
    
    titleBackgroundImage.image = [UIImage imageNamed:@"cellbottom"];
    
    [cell.contentView addSubview:titleBackgroundImage];
    
    UIImageView* logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(7, 96+32, 22, 22)];
    
    if (indexPath.row == 0) {
        
        logoImage.image = [UIImage imageNamed:@"相册_icon_camera-roll"];
    }
    else{
        logoImage.image = [UIImage imageNamed:@"相册_icon_相册"];
    }
    
    [cell.contentView addSubview:logoImage];
    
    UILabel* celltitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 91+32, 284, 32)];
    celltitleLabel.font = [UIFont fontWithName:Custom_Font_Family_2 size:16];
    celltitleLabel.textColor = [UIColor whiteColor];
    celltitleLabel.backgroundColor = [UIColor clearColor];
    celltitleLabel.text = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    [cell.contentView addSubview:celltitleLabel];
    
    
    return cell;
}



#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kThumbnailLength;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALAssetsGroup *assetsGroup = [self.groups objectAtIndex:indexPath.row];
    MTAssetsViewController *mtassets = [[MTAssetsViewController alloc] init];
    mtassets.BackBool = YES;
    mtassets.assetsGroup = assetsGroup;
    mtassets.titlestr = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    [self.navigationController pushViewController:mtassets animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)showAssetGroup{
    
    groupsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStylePlain];
    groupsTable.delegate = self;
    groupsTable.dataSource = self;
    [groupsTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    groupsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:groupsTable];
    
}

void Swizzle(Class c1,Class c2,SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c1, orig);
    Method newMethod = class_getInstanceMethod(c2, new);
    if(class_addMethod(c2, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c1, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    _firstInit = YES;
    [self createImagesTitle];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self showAssetGroup];
    [self loadGroups];
    [self showNav];
}


- (void)firstIn{
    
    if (_firstInit) {
        NSLog(@"from camera");
        ALAssetsGroup *assetsGroup = [self.groups objectAtIndex:0];
        
        MTAssetsViewController *mtassets = [[MTAssetsViewController alloc] init];
        mtassets.BackBool = YES;
        mtassets.assetsGroup = assetsGroup;
        mtassets.titlestr = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        [self.navigationController setViewControllers:[NSArray arrayWithObjects:[[self.navigationController viewControllers] objectAtIndex:0],mtassets, nil] animated:NO];
        _firstInit = NO;
        
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
}

@end


