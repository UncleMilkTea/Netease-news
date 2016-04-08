//
//  HYKNewsTableViewCell.m
//  网易新闻
//
//  Created by 侯玉昆 on 16/2/22.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

#import "HYKNewsTableViewCell.h"
#import "UIImageView+WebImage.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface HYKNewsTableViewCell ()

@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong) UILabel *digestLabel;

@property (nonatomic ,strong) UILabel *replayLabel;

@property (nonatomic ,strong) UIImageView *iconView;

@property(strong,nonatomic) UIView *bottomLine;

@end

@implementation HYKNewsTableViewCell

//! 这个方法用来实例化子控件
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _titleLabel = [[UILabel alloc]init];
//    _titleLabel.numberOfLines = 2;
    _titleLabel.font = [UIFont systemFontOfSize:16];
    
    _digestLabel = [[UILabel alloc]init];
    _digestLabel.numberOfLines = 2;
    _digestLabel.font = [UIFont systemFontOfSize:14];
    
    _replayLabel = [[UILabel alloc]init];
    _replayLabel.backgroundColor = [UIColor lightGrayColor];
    _replayLabel.font = [UIFont systemFontOfSize:10];
    
    _iconView = [[UIImageView alloc]init];
    _bottomLine = [[UIView alloc]init];
    _bottomLine.backgroundColor = [UIColor lightGrayColor];
    
    [self.contentView addSubview:_iconView];
    [self.contentView addSubview:_digestLabel];
    [self.contentView addSubview:_replayLabel];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_bottomLine];

    return self;
}
- (void)setModel:(HYKNews *)model {
    
    _model = model;
    
    _titleLabel.text  =model.title;
    
    _digestLabel.text = model.digest;
    
    _replayLabel.text = [NSString stringWithFormat:@"跟帖数:%@",model.replyCount];
    
    [_iconView setWebImageUrlString:model.imgsrc placeholderImage:[UIImage imageNamed:@"侯玉昆"]];
}

//! 用来设置控件的尺寸
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat X = 8;CGFloat Y = 8;CGFloat W = 100;CGFloat H = 64;
    
   
    _iconView.frame = CGRectMake(X, Y, W, H);
    
    _titleLabel.frame = CGRectMake(2*X+W, Y, WIDTH-W+3*X, 15);
    
    _digestLabel.frame = CGRectMake(2*X+W, 15+2*Y, WIDTH-W+3*X, 40);
    
    [_replayLabel sizeToFit];
    _replayLabel.frame = CGRectMake(WIDTH-_replayLabel.bounds.size.width-X, 80-_replayLabel.bounds.size.height-Y, _replayLabel.bounds.size.width, _replayLabel.bounds.size.height);
    
    _bottomLine.frame = CGRectMake(0, 79, WIDTH, 1);
}
@end
