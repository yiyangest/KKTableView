//
//  KKTableViewController.m
//  KKTableView
//
//  Created by yiyang on 15/7/29.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import "KKTableViewController.h"
#import "SVPullToRefresh.h"
#import "UITableView+KKLayoutCell.h"

@interface KKTableViewController ()



@end

@implementation KKTableViewController

#pragma mark - Life cycle
- (void)loadView {
    [super loadView];
    
    [self configureTableView];
    
    [self configureDataSource];
    
    
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public

- (void)reloadTableData {
    [self.tableView reloadData];
}

- (void)refresh {
    self.pageInfo.currentPage = 1;
}

- (void)loadMore {
    self.pageInfo.currentPage += 1;
}

#pragma mark - Private

- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    KKTableViewController *__weak weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
}

- (void)configureDataSource {
    self.dataSource = [[KKTableViewDataSource alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = self.dataSource.cellIdentifier;
    CGFloat height = [tableView kk_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath];
    return height;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tableViewInfiniteScrollingWithStatus:(KKAnimStatus)status {
    switch (status) {
        case KKAnimStart:
        {
            [self.tableView.infiniteScrollingView startAnimating];
        }
        break;
        case KKAnimStop:
        {
            [self.tableView.infiniteScrollingView stopAnimating];
        }
            
        default:
            break;
    }
}

- (void)tableViewPullToRefreshViewWithStatus:(KKAnimStatus)status {
    switch (status) {
        case KKAnimStart:
        {
            [self.tableView.pullToRefreshView startAnimating];
        }
        break;
        case KKAnimStop:
        {
            [self.tableView.pullToRefreshView stopAnimating];
        }
            
        default:
            break;
    }
}

#pragma mark - Getter & Setter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
    }
    return _tableView;
}

- (KKPageInfo *)pageInfo {
    if (_pageInfo == nil) {
        _pageInfo = [KKPageInfo new];
    }
    
    return _pageInfo;
}

@end
