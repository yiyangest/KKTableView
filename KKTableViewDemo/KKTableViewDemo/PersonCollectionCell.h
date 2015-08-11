//
//  PersonCollectionCell.h
//  KKTableViewDemo
//
//  Created by yiyang on 15/8/11.
//  Copyright © 2015年 yiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;

@interface PersonCollectionCell : UICollectionViewCell

@end

@interface PersonCollectionCell (Configure)

- (void)configureWithPerson:(Person *)person;

@end
