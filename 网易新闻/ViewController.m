//
//  ViewController.m
//  网易新闻
//
//  Created by 侯玉昆 on 16/2/22.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

#import "ViewController.h"
#import "HYKNewBarView.h"
#import "HYKCollectionMainView.h"
#import "HYKNewsTableView.h"
#import "HYKNewsViewController.h"


#define BARWEDITH [UIScreen mainScreen].bounds.size.width
#define MAINHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property(strong,nonatomic) HYKNewsTableView *tableView;

@end

@implementation ViewController

- (HYKNewsTableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[HYKNewsTableView alloc]init];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //! 主界面的UICollectionView
    UICollectionViewFlowLayout *mainLayout = [[UICollectionViewFlowLayout alloc]init];
    
    mainLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    mainLayout.minimumInteritemSpacing = 0;
    mainLayout.minimumLineSpacing = 0;
    mainLayout.itemSize = CGSizeMake(BARWEDITH, MAINHEIGHT);
    
    HYKCollectionMainView *mainView = [[HYKCollectionMainView alloc]initWithFrame:CGRectMake(0, 66, BARWEDITH, MAINHEIGHT) collectionViewLayout:mainLayout];
    
    [self.view addSubview:mainView];
    
    
    //! 导航栏的UICollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.scrollDirection  = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(80, 30);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    HYKNewBarView *newBar = [[HYKNewBarView alloc]initWithFrame:CGRectMake(0, 64, BARWEDITH, 35) collectionViewLayout:layout];
    
    [self.view addSubview:newBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCellOpenPage:) name:@"didSelectCellOpenWeb" object:nil];
    
}

//! 控制器的跳转
- (void)didSelectCellOpenPage:(NSNotification *)notify {
    
//    self.navigationController.navigationBar
   
    [self.navigationController pushViewController:notify.object animated:YES];
    
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)prefersStatusBarHidden{
    
    return NO;
}

@end
