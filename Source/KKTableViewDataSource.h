//
//  KKTableViewDataSource.h
//  KKTableView
//
//  Created by yiyang on 15/7/29.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void(^CellConfigureBlock)(id cell, id item);
typedef Class(^CellClassConfigureBlock)(id item);

/**
 *  UITableViewDataSource for only one section
 */
@interface KKTableViewDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) CellConfigureBlock configureBlock;

/**
 * 配置cell类别和item之间关系的block
 */
@property (nonatomic, copy) CellClassConfigureBlock cellClassConfigureBlock;

/**
 *  通过cell的identifier和配置方法初始化dataSource，通常用于单一类别cell的dataSource
 *
 *  @param identifier <#identifier description#>
 *  @param block      <#block description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithIdentifier:(NSString *)identifier configureBlock:(CellConfigureBlock)block;

/**
 *  注册绑定cell配置方法和cell类，如table有多种cell，则可调用多次该方法注册各个cell类别
 *
 *  @param block     cell对应的配置方法
 *  @param className cell的类名
 */
- (void)registerConfigureBlock:(CellConfigureBlock)block forCellClassName:(NSString *)className;

#pragma mark - 增、删数据源数组
- (void)addItem:(id)item;
- (void)addItemsArray:(NSArray *)items;
- (void)clearItems;

#pragma mark - 只读类方法
- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (CellConfigureBlock)cellConfigureBlockForIdentifier:(NSString *)identifier;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)items;

@end
