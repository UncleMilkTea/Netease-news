//
//  HYKNewsTableView.m
//  网易新闻
//
//  Created by 侯玉昆 on 16/2/22.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

#import "HYKNewsTableView.h"
#import "HYKNews.h"
#import "HYKNewsTableViewCell.h"
#import "HYKNetWorkTool.h"
#import "MJRefresh.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface HYKNewsTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *array;

//! 转菊花
@property(strong,nonatomic) UIActivityIndicatorView *activityView;

@property(assign,nonatomic) NSInteger index;

@property(strong,nonatomic) UITableViewHeaderFooterView *header;



@end
@implementation HYKNewsTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor greenColor];
        
        self.delegate = self;
        
        self.dataSource = self;
        
        self.index = 10;
        
        // 隐藏 cell 分割线.
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        MJRefreshNormalHeader *herder = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [self loadNewsWithTid:self.model.tid];
            
        }];
        
        [herder setTitle:@"下拉刷新数据" forState:MJRefreshStatePulling];
        
       MJRefreshAutoNormalFooter *footer =  [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [self loadMoreWebDataWith:self.model.tid startIndex:self.index];
           
           
        } ];
        
        [footer setTitle:@"上拉加载更多数据" forState:MJRefreshStatePulling];
        
        self.mj_header = herder;
        
        self.mj_footer = footer;   

    }
    return self;
}

- (void)setModel:(HYKBar *)model{
    
    _model = model;
    
    //! 在载入数据前转菊花
//    [self.activityView startAnimating];
    
    //! 清空数据源
    [self.array removeAllObjects];
    
    [self reloadData];
    
    [self loadNewsWithTid:model.tid];

}

//! 加载新闻数据的方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (void)loadNewsWithTid:(NSString *)tid {
    
     [[[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://c.m.163.com/nc/article/headline/%@/0-20.html",tid]]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         
         if (data && !error) {
             
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             
             [NSThread sleepForTimeInterval:2];
             
//             NSLog(@"主界面端口请求回来的新闻数据%@",dic);
             
             [dic[tid] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 
                 //字典转模型
                 HYKNews *model = [HYKNews modelWithDict:obj];
                 
                 [self.array addObject:model];
                 
             }];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
//                 [self.activityView stopAnimating];
                 
                 [self.mj_header endRefreshing];
                 
                 [self reloadData];
                 
             });
             
         }else {
             
             NSLog(@"HYKNewsTableView请求失败%@",error);
         }
         
     }]resume];

}
#pragma mark 数据源方法



//显示新闻内容的界面跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"界面跳转");
    
    HYKNewsViewController *NVC = [[HYKNewsViewController alloc]init];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectCellOpenWeb" object:NVC];
    
    HYKNews *model = self.array[indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"modelurl" object:model.url];
    
    
    if ([self.jump respondsToSelector:@selector(didSelectCellOpenWeb:)]) {

        [self.jump didSelectCellOpenWeb:NVC];
            }

    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"每个主界面加载新闻的条数%zd",self.array.count);
    
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//加载更多数据
    if (self.index == indexPath.row) {
        
        self.index +=5;
        
//        [self loadMoreWebDataWith:self.model.tid startIndex:indexPath.row];
    }
    
    
    NSString *identifier = @"cell";
    
   HYKNewsTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (nil == cell) {
        cell = [[HYKNewsTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    HYKNews *model = self.array [indexPath.row];
    
    cell.model = model;
    
    return cell;
    
}

//! 加载更多网络数据
- (void)loadMoreWebDataWith:(NSString *)tid startIndex:(NSInteger)index{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //!> 状态栏网络菊花开始旋转
    
    NSString *str = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/headline/%@/%ld-10.html",tid,index];
    
    NSLog(@"加载更多网络数据");
    
    [[HYKNetWorkTool sharedNetWork] getRequest:str KeyAndValue:nil success:^(id obj, NSURLResponse *reponse) {
        
        NSDictionary *dic = obj;
        
        [dic[tid] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            HYKNews *model = [HYKNews modelWithDict:obj];
            
            [self.array addObject:model];
            
        }];
        
        [self reloadData];
        
        [self.mj_footer endRefreshing];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; //!> 状态栏网络菊花停止旋转
        
    } fause:^(NSError *error) {
        
    }];
    
    
    
}

#pragma mark 懒加载
- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        
        _activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.center.x, self.center.y, 10, 10)];
        
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
        [self addSubview:_activityView];
    }
    
    return _activityView;
}

- (NSMutableArray *)array{
    
    if (!_array) {
        
        _array = [NSMutableArray array];
    }
    return _array;
}

//- (void)layoutSubviews{
//    
////    [super layoutSubviews];
//    
//    self .frame = CGRectMake(0, 0,WIDTH , HEIGHT-20-30);
//    
//}

@end
