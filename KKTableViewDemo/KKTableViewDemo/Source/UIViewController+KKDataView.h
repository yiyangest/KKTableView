//
//  UIViewController+KKCollectionView.h
//  KKTableViewDemo
//
//  Created by yiyang on 15/8/11.
//  Copyright © 2015年 yiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKPageInfo.h"
#import "KKTableViewDataSource.h"
#import "KKTableViewConstant.h"
#import "KKDataViewControllerDelegate.h"

@interface UIViewController (KKDataView)

@property (nonatomic, readonly) UICollectionView *kk_collectionView;
@property (nonatomic, readonly) UITableView *kk_tableView;

@property (nonatomic, strong) KKPageInfo *kk_pageInfo;

@property (nonatomic, strong) KKTableViewDataSource *kk_dataSource;

@property (nonatomic, weak) id<KKDataViewControllerDelegate> kk_delegate;

- (void)kk_loadWithDataViewType:(KKDataViewType)dataViewType;

- (void)kk_reloadViewData;

- (void)kk_refresh;

- (void)Kk_loadMore;

- (void)kk_dataViewInfiniteScrollingWithStatus:(KKAnimStatus)status;

- (void)kk_dataViewPullToRefreshViewWithStatus:(KKAnimStatus)status;

- (void)kk_configureDataView;

- (void)kk_configureDataSource;

@end
