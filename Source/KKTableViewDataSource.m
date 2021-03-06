//
//  KKTableViewDataSource.m
//  KKTableView
//
//  Created by yiyang on 15/7/29.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import "KKTableViewDataSource.h"
#import "KKBaseCell.h"

@interface KKTableViewDataSource ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *configureBlocks;

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

- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = self.cellIdentifier;
    id item = [self itemAtIndexPath:indexPath];
    
    if (self.cellClassConfigureBlock) {
        identifier = self.cellClassConfigureBlock(item);
    }
    
    return identifier;

}

- (CellConfigureBlock)cellConfigureBlockForIdentifier:(NSString *)identifier {
    CellConfigureBlock configureBlock = [self.configureBlocks objectForKey:identifier];
    if (!configureBlock) {
        configureBlock = self.configureBlock;
    }
    
    return configureBlock;
    
}

- (void)registerConfigureBlock:(CellConfigureBlock)block forIdentifier:(NSString *)identifier {
    [self.configureBlocks setObject:[block copy] forKey:identifier];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id item = [self itemAtIndexPath:indexPath];
    
    NSString *identifier = [self cellIdentifierForIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    CellConfigureBlock configureBlock = [self.configureBlocks objectForKey:identifier];
    if (!configureBlock) {
        configureBlock = self.configureBlock;
    }
    
    NSAssert(configureBlock != nil, @"cell configure block is nil! Can't configure the cell with identifier: %@", identifier);
    
    configureBlock(cell, item);
    return cell;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self itemAtIndexPath:indexPath];
    
    NSString *identifier = [self cellIdentifierForIndexPath:indexPath];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    CellConfigureBlock configureBlock = [self.configureBlocks objectForKey:identifier];
    if (!configureBlock) {
        configureBlock = self.configureBlock;
    }
    
    NSAssert(configureBlock != nil, @"cell configure block is nil! Can't configure the cell with identifier: %@", identifier);
    
    configureBlock(cell, item);
    return cell;
}

#pragma mark - Getter & Setter
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (NSMutableDictionary *)configureBlocks {
    if (_configureBlocks == nil) {
        _configureBlocks = [NSMutableDictionary new];
    }
    return _configureBlocks;
}

@end
