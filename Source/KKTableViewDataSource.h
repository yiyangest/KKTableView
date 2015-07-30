//
//  KKTableViewDataSource.h
//  KKTableView
//
//  Created by yiyang on 15/7/29.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class KKTableViewDataSource;

@protocol MutliCellDataSource <NSObject>

- (NSString *)tableViewDataSource: (KKTableViewDataSource *)dataSource identifierForIndexPath:(NSIndexPath *)indexPath;

@end

typedef void(^CellConfigureBlock)(id cell, id item);

/**
 *  UITableViewDataSource for only one section
 */
@interface KKTableViewDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) CellConfigureBlock configureBlock;

@property (nonatomic, weak) id<MutliCellDataSource> delegate;

- (instancetype)initWithIdentifier:(NSString *)identifier configureBlock:(CellConfigureBlock)block;

#pragma mark - 增、删数据源数组
- (void)addItem:(id)item;
- (void)addItemsArray:(NSArray *)items;
- (void)clearItems;

#pragma mark - 只读类方法
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)items;

@end
