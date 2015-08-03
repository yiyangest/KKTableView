//
//  UITableView+KKLayoutCell.h
//  KKTableView
//
//  Created by yiyang on 15/7/30.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (KKLayoutCell)

/**
 *  注册cell的class
 *
 *  @param aCellClass <#aCellClass description#>
 */
- (void)kk_registerCellClass:(Class)aCellClass;

/**
 *  注册cell的nib
 *
 *  @param aCellClass <#aCellClass description#>
 */
- (void)kk_registerNibOfCellClass:(Class)aCellClass;

/**
 *  计算cell的高度，有缓存机制，参考http://blog.sunnyxx.com/2015/05/17/cell-height-calculation
 *
 *  @param identifier <#identifier description#>
 *  @param indexPath  <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (CGFloat)kk_heightForCellWithIdentifier:(NSString *)identifier cacheByIndexPath:(NSIndexPath *)indexPath;

@end
