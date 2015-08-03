//
//  UIViewController+KKTableView.m
//  KKTableViewDemo
//
//  Created by yiyang on 15/8/3.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import "UIViewController+KKTableView.h"
#import "SVPullToRefresh.h"
#import "UITableView+KKLayoutCell.h"
#import <objc/runtime.h>

@interface UIViewController (KKTableViewPrivate)<UITableViewDelegate, KKTableViewControllerDelegate>

@end

@implementation UIViewController (KKTableViewPrivate)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self.kk_dataSource cellIdentifierForIndexPath:indexPath];
    
    CGFloat height = [tableView kk_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath];
    return height;
}

@end



@implementation UIViewController (KKTableView)

#pragma mark - Configure Table

- (void)kk_configureDataSource {
    self.kk_dataSource = [KKTableViewDataSource new];
    
    if (self.kk_delegate && [self.kk_delegate respondsToSelector:@selector(kk_tableViewDidConfigureDataSource)]) {
        [self.kk_delegate kk_tableViewDidConfigureDataSource];
    }
}

- (void)kk_configureTableView {
    self.kk_tableView.backgroundColor = [UIColor clearColor];
    self.kk_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIViewController *__weak weakSelf = self;
    
    [self.kk_tableView addPullToRefreshWithActionHandler:^{
        [weakSelf kk_refresh];
    }];
    
    [self.kk_tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf Kk_loadMore];
    }];
    
    if (self.kk_delegate && [self.kk_delegate respondsToSelector:@selector(kk_tableViewDidConfigureTableView)]) {
        [self.kk_delegate kk_tableViewDidConfigureTableView];
    }
}

#pragma mark - Public

- (void)kk_refresh {
    self.kk_pageInfo.currentPage = 1;
    NSLog(@"vc category refresh");
    if (self.kk_delegate && [self.kk_delegate respondsToSelector:@selector(kk_tableViewWillRefresh)]) {
        [self.kk_delegate kk_tableViewWillRefresh];
    }
}

- (void)Kk_loadMore {
    self.kk_pageInfo.currentPage += 1;
    if (self.kk_delegate && [self.kk_delegate respondsToSelector:@selector(kk_tableViewWillLoadMore)]) {
        [self.kk_delegate kk_tableViewWillLoadMore];
    }
}

- (void)kk_reloadTableData {
    [self.kk_tableView reloadData];
}

- (void)kk_tableViewInfiniteScrollingWithStatus:(KKAnimStatus)status {
    switch (status) {
        case KKAnimStart:
        {
            [self.kk_tableView.infiniteScrollingView startAnimating];
        }
            break;
        case KKAnimStop:
        {
            [self.kk_tableView.infiniteScrollingView stopAnimating];
        }
            
        default:
            break;
    }
}

- (void)kk_tableViewPullToRefreshViewWithStatus:(KKAnimStatus)status {
    switch (status) {
        case KKAnimStart:
        {
            [self.kk_tableView.pullToRefreshView startAnimating];
        }
            break;
        case KKAnimStop:
        {
            [self.kk_tableView.pullToRefreshView stopAnimating];
        }
            
        default:
            break;
    }
}


#pragma mark - Private

- (void)kk_loadView {
    
    self.kk_delegate = self;
    
    [self kk_configureTableView];
    [self kk_configureDataSource];
    
    self.kk_tableView.dataSource = self.kk_dataSource;
    self.kk_tableView.delegate = self;
}


#pragma mark - Getter & Setter

- (UITableView *)kk_tableView {
    if ([self respondsToSelector:@selector(tableView)]) {
        return [self performSelector:@selector(tableView)];
    }
    
    UITableView *tableView = objc_getAssociatedObject(self, _cmd);
    if (!tableView) {
        tableView = [[UITableView alloc] init];
        objc_setAssociatedObject(self, _cmd, tableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tableView;
}

- (void)setKk_tableView:(UITableView *)kk_tableView {
    if ([self respondsToSelector:@selector(setTableView:)]) {
        [self performSelector:@selector(setTableView:) withObject:kk_tableView];
        return ;
    }
    
    objc_setAssociatedObject(self, @selector(kk_tableView), kk_tableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

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

- (id<KKTableViewControllerDelegate>)kk_delegate {
    id<KKTableViewControllerDelegate> delegate = objc_getAssociatedObject(self, _cmd);
    return delegate;
}

- (void)setKk_delegate:(id<KKTableViewControllerDelegate>)kk_delegate {
    objc_setAssociatedObject(self, @selector(kk_delegate), kk_delegate, OBJC_ASSOCIATION_ASSIGN);
}

@end
