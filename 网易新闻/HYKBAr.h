//
//  HYKBAr.h
//  网易新闻
//
//  Created by 侯玉昆 on 16/2/22.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYKBar : NSObject

@property(copy,nonatomic) NSString *tname;

@property(copy,nonatomic) NSString *tid;

+ (instancetype)modelWithDict:(NSDictionary *)dict;
@end
