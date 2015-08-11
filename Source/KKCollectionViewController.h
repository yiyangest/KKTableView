//
//  KKCollectionViewController.h
//  KKTableViewDemo
//
//  Created by yiyang on 15/8/11.
//  Copyright © 2015年 yiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKTableViewConstant.h"
#import "KKPageInfo.h"
#import "KKTableViewDataSource.h"

@interface KKCollectionViewController : UIViewController

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) KKPageInfo *pageInfo;

@property (nonatomic, strong) KKTableViewDataSource *dataSource;

/**
 *  相当于 [tableView reloadData]，子类可视情况重写该方法
 */
- (void)reloadCollectionViewData;

/**
 *  下拉刷新
 */
- (void)refresh;

/**
 *  加载更多
 */
- (void)loadMore;

/**
 *  设置加载更多的动画效果
 *
 *  @param status 开始或者停止
 */
- (void)collectionViewInfiniteScrollingWithStatus:(KKAnimStatus)status;

/**
 *  设置下拉刷新的动画效果
 *
 *  @param status 开始或者停止
 */
- (void)collectionViewPullToRefreshViewWithStatus:(KKAnimStatus)status;

#pragma mark - Configure Collection View

/**
 *  配置、初始化tableView，子类可视情况重写该方法
 */
- (void)configureCollectionView;

/**
 *  配置KKTableViewDataSource
 */
- (void)configureDataSource;

@end
