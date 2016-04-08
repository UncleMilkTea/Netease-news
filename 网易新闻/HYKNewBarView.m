//
//  HYKNewBarView.m
//  网易新闻
//
//  Created by 侯玉昆 on 16/2/22.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

#import "HYKNewBarView.h"
#import "HYKNewBarCell.h"
#import "HYKBar.h"

#define ID @"identifier"

@interface HYKNewBarView ( )<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)NSMutableArray *array;

//@property(strong,nonatomic) NSIndexPath *indexPath;

@end
@implementation HYKNewBarView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.delegate = self;
        
        self.dataSource = self;
        
        [self registerClass:[HYKNewBarCell class] forCellWithReuseIdentifier:ID];
        
        self.bounces = NO;
        
        self.showsHorizontalScrollIndicator = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self loadWebResquesWithUrlStr:@"http://127.0.0.1/ios/topic_news.json"];
            
              [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scrollToItemIndex:) name:@"index" object:nil];

        });
    }
    return self;
}

- (void)scrollToItemIndex:(NSNotification *)notify{
    
    
    
   NSIndexPath * indexPath = notify.object;
    
    [self reloadData];
    
    NSLog(@"导航栏跳转到%@", indexPath);
     
    [self selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
   
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//! 发送网络请求的方法
- (void)loadWebResquesWithUrlStr:(NSString *)urlStr {
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:0 timeoutInterval:8] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data && !connectionError) {

        NSDictionary  *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        NSArray *array = dic[@"tList"];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *dic = obj;
            
//            NSLog(@"%@",dic);
            
            HYKBar *model = [HYKBar modelWithDict:dic];
            
            [self.array addObject:model];
            
        }];
            
            //! 发送通知将模型数据传送给主界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NewChanneDataLoadSuccess" object:self.array];
            
            [self reloadData];
            
            //! 主界面默认显示第一个
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            
            [self selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            
        }else{
            
            NSLog(@"导航栏处,请求失败%@",connectionError);
   //这个用于运行在手机上没有数据源文件的时候
            NSString *path =[[NSBundle mainBundle]pathForResource:@"topic_news.json" ofType:nil];
            
            NSData *data = [NSData dataWithContentsOfFile:path];
            
            NSDictionary  *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
            NSArray *array = dic[@"tList"];
            
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSDictionary *dic = obj;
                
                //            NSLog(@"%@",dic);
                
                HYKBar *model = [HYKBar modelWithDict:dic];
                
                [self.array addObject:model];
                
            }];
            
            //! 发送通知将模型数据传送给主界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NewChanneDataLoadSuccess" object:self.array];
            
            [self reloadData];
            
            //! 主界面默认显示第一个
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            
            [self selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            
        }
    }];
        
}
//! 自动布局
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HYKBar *model = self.array[indexPath.item];
    
    return [self getNewsBarWith:model.tname];
}

//! 导航栏label自适应
- (CGSize)getNewsBarWith:(NSString *)tname{
    
    UILabel *label = [[UILabel alloc]init];
    
    label.text = tname;
    
    label.font  =[UIFont systemFontOfSize:18];
    
//    label.backgroundColor = [UIColor whiteColor];
    
    [label sizeToFit];
    
    return label.bounds.size;
}

#pragma mark 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSLog(@"导航栏的cell个数%zd个",self.array.count);
    
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HYKNewBarCell *cell  =[self dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    HYKBar *model = self.array[indexPath.item];
    
    cell.model = model;
    
    return cell;
}

//! 选中模型
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //! 取出模型
    HYKBar *model = self.array[indexPath.item];
    
    //! 重新给选中cell赋值
    HYKNewBarCell *cell =  (HYKNewBarCell *) [collectionView cellForItemAtIndexPath:indexPath];
    
    cell.model = model;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectNewsBar" object:indexPath];
}

//! 取消选中
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //! 取出模型
    HYKBar *model = self.array[indexPath.item];
    
    //! 重新给选中cell赋值
    HYKNewBarCell *cell =  (HYKNewBarCell *) [collectionView cellForItemAtIndexPath:indexPath];
    
    cell.model = model;
    
}

#pragma mark 懒加载
- (NSMutableArray *)array {
    
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
@end
