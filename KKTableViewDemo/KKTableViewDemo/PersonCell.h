//
//  PersonCell.h
//  KKTableView
//
//  Created by yiyang on 15/7/29.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKBaseCell.h"

@class Person;

@interface PersonCell : KKBaseCell

@end

@interface PersonCell (Configure)

- (void)configureWithPerson:(Person *)person;

@end
