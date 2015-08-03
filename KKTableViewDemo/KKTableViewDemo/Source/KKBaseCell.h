//
//  KKBaseCell.h
//  KKTableView
//
//  Created by yiyang on 15/7/30.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKBaseCell : UITableViewCell

/**
 *  返回cell的reuseIdentifier
 *
 *  @return <#return value description#>
 */
+ (NSString *)cellReuseIdentifier;

/**
 *  返回cell对应的nib
 *
 *  @return <#return value description#>
 */
+ (UINib *)nib;

@end
