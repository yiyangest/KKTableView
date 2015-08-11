//
//  DemoCollectionViewController.m
//  KKTableViewDemo
//
//  Created by yiyang on 15/8/11.
//  Copyright © 2015年 yiyang. All rights reserved.
//

#import "DemoCollectionViewController.h"
#import "Masonry.h"

#import "PersonCollectionCell.h"
#import "Person.h"
#import "UIViewController+KKDataView.h"

@interface DemoCollectionViewController ()<KKDataViewControllerDelegate>

@end

@implementation DemoCollectionViewController

- (void)loadView {
    [super loadView];
    
    [self kk_loadWithDataViewType:KKDataViewTypeCollectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.kk_collectionView];
    
    [self.kk_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
    }];
    
    [self requestForData];
    
}

- (void)kk_dataViewWillRefresh {
    [self requestForData];
}

- (void)kk_dataViewWillLoadMore {
    [self requestForData];
}

// 模拟网络请求
- (void)requestForData {
    
    NSMutableArray *array = [NSMutableArray new];
    
    for (int i = 0; i < 40; i ++) {
        NSString *name = [NSString stringWithFormat:@"%d", i];
        Person *person = [Person new];
        person.username = name;
        person.userno = i;
        [array addObject:person];
    }
    
    if (self.kk_pageInfo.currentPage == 1) {
        [self.kk_dataSource clearItems];
    }
    
    [self.kk_dataSource addItemsArray:array];
    
    [self kk_dataViewInfiniteScrollingWithStatus:KKAnimStop];
    [self kk_dataViewPullToRefreshViewWithStatus:KKAnimStop];
    
    [self kk_reloadViewData];
}

- (void)kk_dataViewDidConfigureDataView {
    [self.kk_collectionView registerClass:[PersonCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([PersonCollectionCell class])];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(100, 80);
    self.kk_collectionView.collectionViewLayout = layout;
}

- (void)kk_dataViewDidConfigureDataSource {
    
    self.kk_dataSource.cellIdentifier = NSStringFromClass([PersonCollectionCell class]);
    self.kk_dataSource.configureBlock = ^(PersonCollectionCell *cell, Person *model) {
        [cell configureWithPerson:model];
    };
}

@end
