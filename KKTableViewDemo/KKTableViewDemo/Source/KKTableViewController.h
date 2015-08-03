//
//  KKTableViewController.h
//  KKTableView
//
//  Created by yiyang on 15/7/29.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKPageInfo.h"
#import "KKTableViewDataSource.h"

/**
 *  下拉刷新和加载更多的动画效果枚举
 */
typedef NS_ENUM(NSUInteger, KKAnimStatus){
    /**
     *  开始动画
     */
    KKAnimStart = 1,
    /**
     *  结束动画
     */
    KKAnimStop
};

@interface KKTableViewController : UIViewController<UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) KKPageInfo *pageInfo;

@property (nonatomic, strong) KKTableViewDataSource *dataSource;

/**
 *  相当于 [tableView reloadData]，子类可视情况重写该方法
 */
- (void)reloadTableData;

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
 *  @param status <#status description#>
 */
- (void)tableViewInfiniteScrollingWithStatus:(KKAnimStatus)status;

/**
 *  设置下拉刷新的动画效果
 *
 *  @param status <#status description#>
 */
- (void)tableViewPullToRefreshViewWithStatus:(KKAnimStatus)status;

#pragma mark - Configure Table

/**
 *  配置、初始化tableView，子类可视情况重写该方法
 */
- (void)configureTableView;

/**
 *  配置KKTableViewDataSource
 */
- (void)configureDataSource;

@end
