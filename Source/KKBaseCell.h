//
//  KKBaseCell.h
//  KKTableView
//
//  Created by yiyang on 15/7/30.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKBaseCell : UITableViewCell

+ (NSString *)cellReuseIdentifier;

+ (UINib *)nib;

@end
