//
//  RightCell.m
//  KKTableView
//
//  Created by yiyang on 15/7/30.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import "RightCell.h"
#import "Person.h"
#import "Masonry.h"

@interface RightCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation RightCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        [self initialize];
    }
    
    return self;
}

- (void)initialize {
    self.nameLabel = [UILabel new];
    
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView).priority(MASLayoutPriorityDefaultHigh);
        make.top.greaterThanOrEqualTo(self.contentView.mas_top).offset(55);
    }];
}

@end

@implementation RightCell (Configure)

- (void)configureWithPerson:(Person *)person {
    self.nameLabel.text = person.username;
}

@end
