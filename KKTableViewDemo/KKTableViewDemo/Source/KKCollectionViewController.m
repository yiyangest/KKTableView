//
//  KKCollectionViewController.m
//  KKTableViewDemo
//
//  Created by yiyang on 15/8/11.
//  Copyright © 2015年 yiyang. All rights reserved.
//

#import "KKCollectionViewController.h"
#import "SVPullToRefresh.h"

@interface KKCollectionViewController ()<UICollectionViewDelegate>

@end

@implementation KKCollectionViewController

#pragma mark - Life cycle
- (void)loadView {
    [super loadView];
    
    [self configureCollectionView];
    
    [self configureDataSource];
    
    
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.delegate = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public

- (void)reloadCollectionViewData {
    [self.collectionView reloadData];
}

- (void)refresh {
    self.pageInfo.currentPage = 1;
}

- (void)loadMore {
    self.pageInfo.currentPage += 1;
}

#pragma mark - Private

- (void)configureCollectionView {
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
}

- (void)configureDataSource {
    self.dataSource = [[KKTableViewDataSource alloc] init];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)collectionViewInfiniteScrollingWithStatus:(KKAnimStatus)status {
    switch (status) {
        case KKAnimStart:
        {
            [self.collectionView.infiniteScrollingView startAnimating];
        }
            break;
        case KKAnimStop:
        {
            [self.collectionView.infiniteScrollingView stopAnimating];
        }
            
        default:
            break;
    }
}

- (void)collectionViewPullToRefreshViewWithStatus:(KKAnimStatus)status {
    switch (status) {
        case KKAnimStart:
        {
            [self.collectionView.pullToRefreshView startAnimating];
        }
            break;
        case KKAnimStop:
        {
            [self.collectionView.pullToRefreshView stopAnimating];
        }
            
        default:
            break;
    }
}

#pragma mark - Getter & Setter

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewLayout new]];
    }
    return _collectionView;
}

- (KKPageInfo *)pageInfo {
    if (_pageInfo == nil) {
        _pageInfo = [KKPageInfo new];
    }
    
    return _pageInfo;
}


@end
