//
//  UIViewController+KKTableView.h
//  KKTableViewDemo
//
//  Created by yiyang on 15/8/3.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKPageInfo.h"
#import "KKTableViewDataSource.h"
#import "KKTableViewConstant.h"

@protocol KKTableViewControllerDelegate <NSObject>

@optional
- (void)kk_tableViewWillRefresh;
- (void)kk_tableViewWillLoadMore;

- (void)kk_tableViewDidConfigureTableView;
- (void)kk_tableViewDidConfigureDataSource;

@end

@interface UIViewController (KKTableView)

@property (nonatomic, strong) UITableView *kk_tableView;

@property (nonatomic, strong) KKPageInfo *kk_pageInfo;

@property (nonatomic, strong) KKTableViewDataSource *kk_dataSource;

@property (nonatomic, weak) id<KKTableViewControllerDelegate> kk_delegate;

- (void)kk_loadView;

- (void)kk_reloadTableData;

- (void)kk_refresh;

- (void)Kk_loadMore;

- (void)kk_tableViewInfiniteScrollingWithStatus:(KKAnimStatus)status;

- (void)kk_tableViewPullToRefreshViewWithStatus:(KKAnimStatus)status;

- (void)kk_configureTableView;

- (void)kk_configureDataSource;

@end
