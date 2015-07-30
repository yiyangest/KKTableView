//
//  RightCell.h
//  KKTableView
//
//  Created by yiyang on 15/7/30.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import "KKBaseCell.h"

@class Person;

@interface RightCell : KKBaseCell

@end

@interface RightCell (Configure)

- (void)configureWithPerson:(Person *)person;

@end
