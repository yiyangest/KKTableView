//
//  ViewController.m
//  KKTableView
//
//  Created by yiyang on 15/7/29.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import "ViewController.h"
#import "PersonCell.h"
#import "RightCell.h"
#import "Person.h"
#import "Masonry.h"
#import "UITableView+KKLayoutCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
    }];
    
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh {
    [super refresh];
    
    [self requestForData];
}

- (void)loadMore {
    [super loadMore];
    
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
    
    if (self.pageInfo.currentPage == 1) {
        [self.dataSource clearItems];
    }
    
    [self.dataSource addItemsArray:array];
    
    [self tableViewInfiniteScrollingWithStatus:KKAnimStop];
    [self tableViewPullToRefreshViewWithStatus:KKAnimStop];
    
    [self reloadTableData];
}

// 在configureTableView中，注册cellClass和对应的identifier
- (void)configureTableView {
    [super configureTableView];
    
    [self.tableView kk_registerCellClass:[PersonCell class]];
    [self.tableView kk_registerCellClass:[RightCell class]];
}

// 在configureDataSource中，设置cell的配置block，如果table需要多种类型cell，则需实现MultiCellDataSource协议
- (void)configureDataSource {
    [super configureDataSource];
    
    // 设置多种类型cell的配置条件
    self.dataSource.cellClassConfigureBlock = ^(Person *model) {
        if (model.userno % 3 == 0) {
            return [RightCell class];
        }
        return [PersonCell class];
    };
    
    // 注册多种cell的configureBlock
    [self.dataSource registerConfigureBlock:^(PersonCell *cell, Person *item) {
        [cell configureWithPerson:item];
    } forCellClassName:@"PersonCell"];
    
    [self.dataSource registerConfigureBlock:^(RightCell *cell, Person *item) {
        [cell configureWithPerson:item];
    } forCellClassName:@"RightCell"];
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *identifier = [self tableViewDataSource:self.dataSource identifierForIndexPath:indexPath];
//    
//    CGFloat height = [tableView kk_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath];
//    
//    return height;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

@end
