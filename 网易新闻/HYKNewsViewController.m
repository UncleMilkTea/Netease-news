//
//  HYKNewsViewController.m
//  网易新闻
//
//  Created by 侯玉昆 on 16/2/23.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

#import "HYKNewsViewController.h"

@interface HYKNewsViewController ()

//@property (nonatomic,strong)UIWebView *web;

@end

@implementation HYKNewsViewController

- (instancetype)init {
    
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadWebPage:) name:@"modelurl" object:nil];

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)loadWebPage:(NSNotification *)notiy {
  
    NSLog(@"加载网页%@",notiy.object);
    
    UIWebView *web  =[[UIWebView alloc]initWithFrame:self.view.bounds];

    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:notiy.object]]];
    
    [self.view addSubview:web];
    
}



@end
