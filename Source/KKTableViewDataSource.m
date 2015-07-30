//
//  KKTableViewDataSource.m
//  KKTableView
//
//  Created by yiyang on 15/7/29.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import "KKTableViewDataSource.h"

@interface KKTableViewDataSource ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation KKTableViewDataSource

#pragma mark - Init

- (instancetype)initWithIdentifier:(NSString *)identifier configureBlock:(CellConfigureBlock)block {
    self = [super init];
    if (self) {
        _cellIdentifier = [identifier copy];
        _configureBlock = [block copy];
    }
    return self;
}

#pragma mark - Public
- (void)addItem:(id)item {
    [self.dataArray addObject:item];
}

- (void)addItemsArray:(NSArray *)items {
    if (items == nil || [items count] == 0) {
        return;
    }
    [self.dataArray addObjectsFromArray:items];
}

- (void)clearItems {
    [self.dataArray removeAllObjects];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [self.dataArray count]) {
        return nil;
    }
    
    id item = [self.dataArray objectAtIndex:indexPath.row];
    return item;
}

- (NSArray *)items {
    return [NSArray arrayWithArray:self.dataArray];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = self.cellIdentifier;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewDataSource:identifierForIndexPath:)]) {
        identifier = [self.delegate tableViewDataSource:self identifierForIndexPath:indexPath];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureBlock(cell, item);
    return cell;
}

#pragma mark - Getter & Setter
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

@end
