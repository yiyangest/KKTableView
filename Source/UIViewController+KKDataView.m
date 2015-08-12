//
//  UIViewController+KKCollectionView.m
//  KKTableViewDemo
//
//  Created by yiyang on 15/8/11.
//  Copyright © 2015年 yiyang. All rights reserved.
//

#import "UIViewController+KKDataView.h"
#import "UITableView+KKLayoutCell.h"
#import "SVPullToRefresh.h"
#import <objc/runtime.h>


static const char *kk_data_view;

@interface UIViewController (KKCollectionViewPrivate)<KKDataViewControllerDelegate, UITableViewDelegate>

@property (nonatomic, readonly) UIScrollView *kk_dataView;

@property (nonatomic, assign) KKDataViewType kk_dataViewType;

@end

@implementation UIViewController (KKCollectionViewPrivate)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self.kk_dataSource cellIdentifierForIndexPath:indexPath];
    
    CGFloat height = [tableView kk_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath];
    return height;
}


- (KKDataViewType)kk_dataViewType {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (!number) {
        number = [NSNumber numberWithInteger:KKDataViewTypeTableView];
        objc_setAssociatedObject(self, _cmd, number, OBJC_ASSOCIATION_ASSIGN);
    }
    return [number integerValue];
}

- (void)setKk_dataViewType:(KKDataViewType)kk_dataViewType {
    objc_setAssociatedObject(self, @selector(kk_dataViewType), [NSNumber numberWithInteger:kk_dataViewType], OBJC_ASSOCIATION_ASSIGN);
}


- (UIScrollView *)kk_dataView {
    switch (self.kk_dataViewType) {
        case KKDataViewTypeCollectionView:
            return [self kk_collectionView];
        case KKDataViewTypeTableView:
            return [self kk_tableView];
    }
}

@end

@implementation UIViewController (KKDataView)

#pragma mark - Configure Table

- (void)kk_configureDataSource {
    self.kk_dataSource = [KKTableViewDataSource new];
    
    if (self.kk_delegate && [self.kk_delegate respondsToSelector:@selector(kk_dataViewDidConfigureDataSource)]) {
        [self.kk_delegate kk_dataViewDidConfigureDataSource];
    }
}

- (void)kk_configureDataView {
    
    self.kk_dataView.backgroundColor = [UIColor clearColor];
    
    if (self.kk_dataViewType == KKDataViewTypeTableView) {
        self.kk_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    __weak typeof(&*self)weakSelf = self;
    
    [self.kk_dataView addPullToRefreshWithActionHandler:^{
        [weakSelf kk_refresh];
    }];
    
    [self.kk_dataView addInfiniteScrollingWithActionHandler:^{
        [weakSelf Kk_loadMore];
    }];
    
    if (self.kk_delegate && [self.kk_delegate respondsToSelector:@selector(kk_dataViewDidConfigureDataView)]) {
        [self.kk_delegate kk_dataViewDidConfigureDataView];
    }
}

#pragma mark - Public

- (void)kk_refresh {
    self.kk_pageInfo.currentPage = 1;
    if (self.kk_delegate && [self.kk_delegate respondsToSelector:@selector(kk_dataViewWillRefresh)]) {
        [self.kk_delegate kk_dataViewWillRefresh];
    }
}

- (void)Kk_loadMore {
    self.kk_pageInfo.currentPage += 1;
    if (self.kk_delegate && [self.kk_delegate respondsToSelector:@selector(kk_dataViewWillLoadMore)]) {
        [self.kk_delegate kk_dataViewWillLoadMore];
    }
}

- (void)kk_reloadViewData {
    switch (self.kk_dataViewType) {
        case KKDataViewTypeCollectionView:
            [self.kk_collectionView reloadData];
            break;
        case KKDataViewTypeTableView:
            [self.kk_tableView reloadData];
            break;
    }
}

- (void)kk_dataViewInfiniteScrollingWithStatus:(KKAnimStatus)status {
    switch (status) {
        case KKAnimStart:
        {
            [self.kk_dataView.infiniteScrollingView startAnimating];
        }
            break;
        case KKAnimStop:
        {
            [self.kk_dataView.infiniteScrollingView stopAnimating];
        }
            break;
            
        default:
            break;
    }
}

- (void)kk_dataViewPullToRefreshViewWithStatus:(KKAnimStatus)status {
    switch (status) {
        case KKAnimStart:
        {
            [self.kk_dataView.pullToRefreshView startAnimating];
        }
            break;
        case KKAnimStop:
        {
            [self.kk_dataView.pullToRefreshView stopAnimating];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - Private

- (void)kk_loadWithDataViewType:(KKDataViewType)dataViewType {
    
    self.kk_dataViewType = dataViewType;
    
    self.kk_delegate = self;
    
    [self kk_configureDataView];
    [self kk_configureDataSource];
    
    if (self.kk_dataViewType == KKDataViewTypeTableView) {
        self.kk_tableView.delegate = self;
    }
    
    [self.kk_dataView performSelector:@selector(setDataSource:) withObject:self.kk_dataSource];
}


#pragma mark - Getter & Setter

- (UICollectionView *)kk_collectionView {
    
    if ([self respondsToSelector:@selector(collectionView)]) {
        return [self performSelector:@selector(collectionView)];
    }
    
    if (self.kk_dataViewType != KKDataViewTypeCollectionView) {
        return nil;
    }
    
    UICollectionView *collectionView = objc_getAssociatedObject(self, &kk_data_view);
    if (!collectionView) {
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
        objc_setAssociatedObject(self, &kk_data_view, collectionView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return collectionView;
}

- (UITableView *)kk_tableView {
    if ([self respondsToSelector:@selector(tableView)]) {
        return [self performSelector:@selector(tableView)];
    }
    
    if (self.kk_dataViewType != KKDataViewTypeTableView) {
        return nil;
    }
    
    UITableView *tableView = objc_getAssociatedObject(self, &kk_data_view);
    if (!tableView) {
        tableView = [[UITableView alloc] init];
        objc_setAssociatedObject(self, &kk_data_view, tableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tableView;
}


//- (void)setKk_collectionView:(UICollectionView *)kk_collectionView {
//    if ([self respondsToSelector:@selector(setCollectionView:)]) {
//        [self performSelector:@selector(setCollectionView:) withObject:kk_collectionView];
//        return ;
//    }
//    
//    objc_setAssociatedObject(self, @selector(kk_collectionView), kk_collectionView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

- (KKPageInfo *)kk_pageInfo {
    KKPageInfo *pageInfo = objc_getAssociatedObject(self, _cmd);
    if (!pageInfo) {
        pageInfo = [KKPageInfo new];
        objc_setAssociatedObject(self, _cmd, pageInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return pageInfo;
}

- (void)setKk_pageInfo:(KKPageInfo *)kk_pageInfo {
    objc_setAssociatedObject(self, @selector(kk_pageInfo), kk_pageInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (KKTableViewDataSource *)kk_dataSource {
    KKTableViewDataSource *dataSource = objc_getAssociatedObject(self, _cmd);
    if (!dataSource) {
        dataSource = [KKTableViewDataSource new];
        objc_setAssociatedObject(self, _cmd, dataSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dataSource;
}

- (void)setKk_dataSource:(KKTableViewDataSource *)kk_dataSource {
    objc_setAssociatedObject(self, @selector(kk_dataSource), kk_dataSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<KKDataViewControllerDelegate>)kk_delegate {
    id<KKDataViewControllerDelegate> delegate = objc_getAssociatedObject(self, _cmd);
    return delegate;
}

- (void)setKk_delegate:(id<KKDataViewControllerDelegate>)kk_delegate {
    objc_setAssociatedObject(self, @selector(kk_delegate), kk_delegate, OBJC_ASSOCIATION_ASSIGN);
}

@end
