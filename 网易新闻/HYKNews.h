//
//  HYKNews.h
//  网易新闻
//
//  Created by 侯玉昆 on 16/2/22.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYKNews : NSObject

//! 新闻标题
@property(copy,nonatomic) NSString *title;

//! 新闻网页
@property(copy,nonatomic) NSString *url;

//! 新闻配图
@property(copy,nonatomic) NSString *imgsrc;

//! 新闻摘要
@property(copy,nonatomic) NSString *digest;

//! 新闻跟帖数
@property(strong,nonatomic) NSNumber *replyCount;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)modelWithDict:(NSDictionary *)dict;



@end
