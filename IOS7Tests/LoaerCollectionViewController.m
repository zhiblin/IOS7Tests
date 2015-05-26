//
//  LoaerCollectionViewController.m
//  IOS7Tests
//
//  Created by lzb on 15/5/26.
//  Copyright (c) 2015年 pipaw. All rights reserved.
//

#import "LoaerCollectionViewController.h"
#import "LoaerCollectionViewCell.h"
#import "LoaerTwitterCollectionViewFlowLayout.h"

@interface LoaerCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LoaerTwitterCollectionViewDataSource, LoaerTwitterCollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSMutableArray *titleArray;
@end

@implementation LoaerCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
    
    self.titleArray = [[NSMutableArray alloc] init];
    for (int i = 1; i < 6; i++) {
        [self.titleArray addObject:[NSString stringWithFormat:@"%i",i]];
    }
    LoaerTwitterCollectionViewFlowLayout *flowLayout= [[LoaerTwitterCollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 250, self.view.bounds.size.width, 120) collectionViewLayout:flowLayout];
    self.collection.clipsToBounds = NO;
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self.collection registerClass:[LoaerCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    [self.view addSubview:self.collection];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"CollectionCell";
    LoaerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
//    if(section==0)
//    {
//        return 10.0;
//    }
//    else
//    {
        return 20.0;
//    }
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
//    
//    [cell setBackgroundColor:[UIColor purpleColor]];
//}
//
//- (void)collectionView:(UICollectionView *)colView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
//    
//    [cell setBackgroundColor:[UIColor yellowColor]];
//}

#pragma mark - LoaerTwitterCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    NSString *currentString = self.titleArray[fromIndexPath.item];
    
    [self.titleArray removeObjectAtIndex:fromIndexPath.item];
    [self.titleArray insertObject:currentString atIndex:toIndexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView willDeleteToIndexPath:(NSIndexPath *)indexPath{
    
    [self.titleArray removeObjectAtIndex:indexPath.item];
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canDeleteItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark - LoaerTwitterCollectionViewDelegateFlowLayout methods

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"will begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"did begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"will end drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"did end drag");
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
