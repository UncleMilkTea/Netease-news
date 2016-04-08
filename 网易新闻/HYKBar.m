//
//  HYKBAr.m
//  网易新闻
//
//  Created by 侯玉昆 on 16/2/22.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

#import "HYKBar.h"

@implementation HYKBar



+ (instancetype)modelWithDict:(NSDictionary *)dict {
    
    HYKBar *bar = [[HYKBar alloc]init];
    
    [bar setValuesForKeysWithDictionary:dict];
    
    return bar;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end
