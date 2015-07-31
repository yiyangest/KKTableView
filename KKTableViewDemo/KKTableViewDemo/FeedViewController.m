//
//  FeedViewController.m
//  KKTableView
//
//  Created by yiyang on 15/7/30.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import "FeedViewController.h"
#import "UITableView+KKLayoutCell.h"
#import "FDFeedCell.h"
#import "FDFeedEntity.h"

@interface FeedViewController ()

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh {
    [super refresh];
    
    [self request];
}

- (void)loadMore {
    [super loadMore];
    
    [self request];
}

- (void)request {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *feedDicts = rootDict[@"feed"];
        
        // Convert to `FDFeedEntity`
        NSMutableArray *entities = @[].mutableCopy;
        [feedDicts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [entities addObject:[[FDFeedEntity alloc] initWithDictionary:obj]];
        }];
        
        if (self.pageInfo.currentPage == 1) {
            [self.dataSource clearItems];
        }
        
        [self.dataSource addItemsArray:entities];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self tableViewInfiniteScrollingWithStatus:KKAnimStop];
            [self tableViewPullToRefreshViewWithStatus:KKAnimStop];
            [self reloadTableData];
        });

    });
}

- (void)configureTableView {
    [super configureTableView];
}

- (void)configureDataSource {
    [super configureDataSource];
    
    self.dataSource.configureBlock = ^(FDFeedCell *cell, FDFeedEntity *item) {
        cell.entity = item;
    };
    self.dataSource.cellIdentifier = [FDFeedCell cellReuseIdentifier];
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
