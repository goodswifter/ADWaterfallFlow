//
//  ViewController.m
//  ADWaterfallFlow
//
//  Created by zhongaidong on 16/6/23.
//  Copyright © 2016年 zhongaidong. All rights reserved.
//

#import "ViewController.h"
#import "ADWaterFlowLayout.h"
#import "ADShopCell.h"
#import "MJRefresh.h"
#import "ADShop.h"
#import "MJExtension.h"

@interface ViewController () <UICollectionViewDataSource, ADWaterFlowLayoutDelegate>
/** 所有商品的数据 */
@property (nonatomic, strong) NSMutableArray *shops;
/** CollectionView */
@property (nonatomic, weak) UICollectionView *collectionView;
@end

@implementation ViewController

static NSString * const ADShopId = @"shop";

- (NSMutableArray *)shops {
    if (!_shops) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置布局
    [self setupLayout];
    
    // 添加刷新
    [self setupRefresh];
}

/**
 *  添加刷新
 */
- (void)setupRefresh {
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    // 开始下拉刷新
    [self.collectionView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
    // 隐藏上拉刷新
    self.collectionView.mj_footer.hidden = YES;
}

/**
 *  上拉刷新
 */
- (void)loadMoreShops {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [ADShop mj_objectArrayWithFilename:@"1.plist"];
        [self.shops addObjectsFromArray:shops];
        
        // 刷新数据
        [self.collectionView reloadData];
        
        [self.collectionView.mj_footer endRefreshing];
    });
}

/**
 *  下拉刷新
 */
- (void)loadNewShops {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [ADShop mj_objectArrayWithFilename:@"1.plist"];
        [self.shops removeAllObjects];
        [self.shops addObjectsFromArray:shops];
        
        // 刷新数据
        [self.collectionView reloadData];
        
        // 结束刷新
        [self.collectionView.mj_header endRefreshing];
    });
}

/**
 *  设置布局
 */
- (void)setupLayout {
    // 创建布局
    ADWaterFlowLayout *layout = [[ADWaterFlowLayout alloc] init];
    layout.delegate = self;
    
    // 创建CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    // 注册Cell
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ADShopCell class]) bundle:nil] forCellWithReuseIdentifier:ADShopId];
    
    self.collectionView = collectionView;
}

#pragma mark - ADWaterFlowLayoutDelegate
#pragma mark

- (CGFloat)waterFlowLayout:(ADWaterFlowLayout *)waterFlowLayout heightForItemAtIndex:(NSInteger)index itemWidth:(CGFloat)itemWidth {
    ADShop *shop = self.shops[index];
    return itemWidth * shop.h / shop.w;
}

- (CGFloat)rowMarginInWaterFlowLayout:(ADWaterFlowLayout *)waterFlowLayout {
    return 20;
}

- (CGFloat)columnCountInWaterFlowLayout:(ADWaterFlowLayout *)waterFlowLayout {
    if (self.shops.count <= 50) return 2;
    return 3;
}

- (UIEdgeInsets)edgeInsetsInWaterFlowLayout:(ADWaterFlowLayout *)waterFlowLayout {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - UICollectionViewDataSource
#pragma mark

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.collectionView.mj_footer.hidden = self.shops.count == 0;
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ADShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ADShopId forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 10;
    
    cell.shop = self.shops[indexPath.item];
    
    return cell;
}

@end
