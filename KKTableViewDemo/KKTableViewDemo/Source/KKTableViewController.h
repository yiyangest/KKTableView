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

typedef NS_ENUM(NSUInteger, KKAnimStatus) {
    KKAnimStart = 1,
    KKAnimStop
};

@interface KKTableViewController : UIViewController<UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) KKPageInfo *pageInfo;

@property (nonatomic, strong) KKTableViewDataSource *dataSource;

- (void)reloadTableData;

- (void)refresh;

- (void)loadMore;

- (void)tableViewInfiniteScrollingWithStatus:(KKAnimStatus)status;

- (void)tableViewPullToRefreshViewWithStatus:(KKAnimStatus)status;

#pragma mark - Configure Table

- (void)configureTableView;

- (void)configureDataSource;

@end
