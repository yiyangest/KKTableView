//
//  UITableView+KKLayoutCell.h
//  KKTableView
//
//  Created by yiyang on 15/7/30.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (KKLayoutCell)

- (void)kk_registerCellClass:(Class)aCellClass;

- (void)kk_registerNibOfCellClass:(Class)aCellClass;

- (CGFloat)kk_heightForCellWithIdentifier:(NSString *)identifier cacheByIndexPath:(NSIndexPath *)indexPath;

@end
