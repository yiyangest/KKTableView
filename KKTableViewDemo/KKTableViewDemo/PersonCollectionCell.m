//
//  PersonCollectionCell.m
//  KKTableViewDemo
//
//  Created by yiyang on 15/8/11.
//  Copyright © 2015年 yiyang. All rights reserved.
//

#import "PersonCollectionCell.h"
#import "Person.h"
#import "Masonry.h"

@interface PersonCollectionCell ()

@property (nonatomic, strong) UILabel *nameLabel;

- (void)initialize;

@end

@implementation PersonCollectionCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)initialize {
    _nameLabel = [UILabel new];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
//        make.top.greaterThanOrEqualTo(self.contentView.mas_top).offset(35);
    }];
}

@end

@implementation PersonCollectionCell (Configure)

- (void)configureWithPerson:(Person *)person {
    self.nameLabel.text = person.username;
}

@end