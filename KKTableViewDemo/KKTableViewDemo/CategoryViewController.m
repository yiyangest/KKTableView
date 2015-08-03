//
//  CategoryViewController.m
//  KKTableViewDemo
//
//  Created by yiyang on 15/8/3.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import "CategoryViewController.h"
#import "UIViewController+KKTableView.h"
#import "Masonry.h"
#import "PersonCell.h"
#import "RightCell.h"
#import "Person.h"
#import "UITableView+KKLayoutCell.h"

@interface CategoryViewController ()<KKTableViewControllerDelegate, UITableViewDelegate>

@end

@implementation CategoryViewController

- (void)loadView {
    [super loadView];
    
    [self kk_loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.kk_tableView];
    
    [self.kk_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self kk_refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)kk_tableViewWillRefresh {
    NSLog(@"vc refresh");
    [self requestForData];
}

- (void)kk_tableViewWillLoadMore {
    NSLog(@"vc load more");
    [self requestForData];
}

// 模拟网络请求
- (void)requestForData {
    
    NSMutableArray *array = [NSMutableArray new];
    
    for (int i = 0; i < 40; i ++) {
        NSString *name = [NSString stringWithFormat:@"%d", i];
        Person *person = [Person new];
        person.username = name;
        person.userno = i;
        [array addObject:person];
    }
    
    if (self.kk_pageInfo.currentPage == 1) {
        [self.kk_dataSource clearItems];
    }
    
    [self.kk_dataSource addItemsArray:array];
    
    [self kk_tableViewInfiniteScrollingWithStatus:KKAnimStop];
    [self kk_tableViewPullToRefreshViewWithStatus:KKAnimStop];
    
    [self kk_reloadTableData];
}


- (void)kk_tableViewDidConfigureTableView {
    [self.kk_tableView kk_registerCellClass:[PersonCell class]];
    
    [self.kk_tableView kk_registerCellClass:[RightCell class]];
}

- (void)kk_tableViewDidConfigureDataSource {
    self.kk_dataSource.cellClassConfigureBlock = ^(Person *model) {
        if (model.userno % 3 == 0) {
            return [RightCell class];
        }
        return [PersonCell class];
    };
    
    [self.kk_dataSource registerConfigureBlock:^(PersonCell *cell, Person *item) {
        [cell configureWithPerson:item];
    } forCellClassName:@"PersonCell"];
    
    [self.kk_dataSource registerConfigureBlock:^(RightCell *cell, Person *item) {
        [cell configureWithPerson:item];
    } forCellClassName:@"RightCell"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end