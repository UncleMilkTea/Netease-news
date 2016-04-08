//
//  HYKNewBarCell.m
//  网易新闻
//
//  Created by 侯玉昆 on 16/2/22.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

#import "HYKNewBarCell.h"

@interface HYKNewBarCell ()

@property(strong,nonatomic) UILabel *namelabel;

@end

@implementation HYKNewBarCell



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.namelabel = [[UILabel alloc]init];
        
        [self.contentView addSubview:_namelabel];
    }
    return self;
}


- (void)setModel:(HYKBar*)model {
    
    _model = model;
    
    _namelabel.text = model.tname;
    
    _namelabel.textAlignment = NSTextAlignmentCenter;
    
    _namelabel.font = [UIFont systemFontOfSize:14];
    
    if (self.isSelected) {
        
        self.selected = YES;
        _namelabel.textColor = [UIColor redColor];
        
        _namelabel.font = [UIFont systemFontOfSize:18];
        
        [_namelabel sizeToFit];
        
        _namelabel.frame = self.namelabel.bounds;
        
        
    }else {
        
        _namelabel.textColor = [UIColor blackColor];
        
        _namelabel.font = [UIFont systemFontOfSize:14];
        
        [_namelabel sizeToFit];
        
        _namelabel.frame = CGRectMake((self.bounds.size.width - self.namelabel.bounds.size.width)/2, (self.bounds.size.height - self.namelabel.bounds.size.height)/2,self.namelabel.bounds.size.width, self.namelabel.bounds.size.height);
    }

    
}
@end
