//
//  HYKCollectionMainViewCell.m
//  网易新闻
//
//  Created by 侯玉昆 on 16/2/22.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

#import "HYKCollectionMainViewCell.h"
#import "HYKNewsTableView.h"



@interface HYKCollectionMainViewCell ()

@property (nonatomic,strong)HYKNewsTableView *tableView;

@end

@implementation HYKCollectionMainViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor purpleColor];
  
#warning 这里的菊花如果不给定tableView的位置,则菊花生成而tableView为加载
        
        _tableView = [[HYKNewsTableView alloc]initWithFrame:self.bounds];
        
        
        [self.contentView addSubview:_tableView];
        
    }
    return self;
}


- (void)setModel:(HYKBar *)model {
    
    _model = model;
    
   self.tableView.model = model;
    
}
@end
