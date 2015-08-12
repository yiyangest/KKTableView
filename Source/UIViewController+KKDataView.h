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

/**
 *  简化含tableView和collectionView的ViewController Category
 */
@interface UIViewController (KKDataView)

/**
 *  当dataViewType为CollectionView时，可通过kk_collectionView获得该view，如果ViewController中有命名为`collectionView`的属性，则kk_collectionView会返回`collectionView`的值.
 */
@property (nonatomic, readonly) UICollectionView *kk_collectionView;

/**
 *  当dataViewType为TableView时，可通过kk_tableView获得该view，如果ViewController中有命名为`tableView`的属性，则kk_tableView会返回`tableView`的值.
 */
@property (nonatomic, readonly) UITableView *kk_tableView;

/**
 *  当前列表的分页信息
 */
@property (nonatomic, strong) KKPageInfo *kk_pageInfo;

/**
 *  当前列表所使用的数据源
 */
@property (nonatomic, strong) KKTableViewDataSource *kk_dataSource;

/**
 *  KKDataViewControllerDelegate，通常情况下不需要设置此属性，自动指向自己。
 */
@property (nonatomic, weak) id<KKDataViewControllerDelegate> kk_delegate;


/**
 *  根据指定的dataViewType初始化相关view和配置
 *
 *  @param dataViewType dataView的种类，目前有两种：KKDataViewTypeTableView和KKDataViewTypeCollectionView
 */
- (void)kk_loadWithDataViewType:(KKDataViewType)dataViewType;

/**
 *  刷新View数据，相当于tableView和collectionView的 reloadData，ViewController可以重写此方法
 */
- (void)kk_reloadViewData;

/**
 *  下拉刷新，会调用delegate的kk_dataViewWillRefresh
 */
- (void)kk_refresh;

/**
 *  加载更多，会调用delegate的kk_dataViewWillLoadMore
 */
- (void)Kk_loadMore;

/**
 *  设置加载更多的动画效果
 *
 *  @param status 动画效果：开始(KKAnimStart)或者停止(KKAnimStop)
 */
- (void)kk_dataViewInfiniteScrollingWithStatus:(KKAnimStatus)status;

/**
 *  设置下拉刷新的动画效果
 *
 *  @param status 动画效果：开始(KKAnimStart)或者停止(KKAnimStop)
 */
- (void)kk_dataViewPullToRefreshViewWithStatus:(KKAnimStatus)status;

/**
 *  配置dataView，会调用delegate的kk_dataViewDidConfigureDataView
 */
- (void)kk_configureDataView;

/**
 *  配置dataSource, 会调用delegate的kk_dataViewDidConfigureDataSource
 */
- (void)kk_configureDataSource;

@end
