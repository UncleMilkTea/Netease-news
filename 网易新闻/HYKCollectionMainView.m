//
//  HYKCollectionMainView.m
//  网易新闻
//
//  Created by 侯玉昆 on 16/2/22.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

#import "HYKCollectionMainView.h"
#import "HYKCollectionMainViewCell.h"
#import "HYKBar.h"

#define ID @"HYKCollectionMainViewCell"
#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface HYKCollectionMainView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(strong,nonatomic) NSMutableArray *array;

@end

@implementation HYKCollectionMainView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
//        self.backgroundColor = [UIColor yellowColor];
        
        self.delegate = self;
        
        self.dataSource = self;
        
        self.pagingEnabled =YES;
        
        self.showsHorizontalScrollIndicator = NO; //!> 隐藏分割线
        
        [self registerClass:[HYKCollectionMainViewCell class] forCellWithReuseIdentifier:ID];
        
        [ [NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dowonLoadModelDataSource:) name:@"NewChanneDataLoadSuccess" object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scrollToItemIndex:) name:@"selectNewsBar" object:nil];
        

    }
    return self;
}

//! 通知调用的方法
- (void)dowonLoadModelDataSource:(NSNotification *)notify{
    
    self.array  = notify.object;
    
    [self reloadData];

}

- (void)scrollToItemIndex:(NSNotification *)notify{
    
    [self scrollToItemAtIndexPath:notify.object atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    [self reloadData];
    
}

//! 移除通知观察者
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 数据源方法

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.contentOffset.x/WIDTH inSection:0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"index" object:indexPath];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSLog(@"主界面的cell个数%zd个",self.array.count);
    
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HYKCollectionMainViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    HYKBar *model = self.array[indexPath.item];
    
    cell.model = model;
    
    return cell;
}

#pragma mark 懒加载

- (NSMutableArray *)array{
    
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
@end
