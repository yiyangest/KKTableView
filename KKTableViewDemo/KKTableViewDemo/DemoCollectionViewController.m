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

@implementation DemoCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
    }];
    
    [self refresh];
}

- (void)refresh {
    [super refresh];
    
    [self requestForData];
}

- (void)loadMore {
    [super loadMore];
    
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
    
    if (self.pageInfo.currentPage == 1) {
        [self.dataSource clearItems];
    }
    
    [self.dataSource addItemsArray:array];
    
    [self collectionViewInfiniteScrollingWithStatus:KKAnimStop];
    [self collectionViewPullToRefreshViewWithStatus:KKAnimStop];
    
    [self reloadCollectionViewData];
}

- (void)configureCollectionView {
    [super configureCollectionView];
    
    
    [self.collectionView registerClass:[PersonCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([PersonCollectionCell class])];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(100, 80);
    self.collectionView.collectionViewLayout = layout;
}

- (void)configureDataSource {
    [super configureDataSource];
    
    self.dataSource.cellIdentifier = NSStringFromClass([PersonCollectionCell class]);
    self.dataSource.configureBlock = ^(PersonCollectionCell *cell, Person *model) {
        [cell configureWithPerson:model];
    };
}

@end
