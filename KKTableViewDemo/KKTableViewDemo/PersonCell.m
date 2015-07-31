//
//  PersonCell.m
//  KKTableView
//
//  Created by yiyang on 15/7/29.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import "PersonCell.h"
#import "Person.h"
#import "Masonry.h"

@interface PersonCell ()

@property (nonatomic, strong) UILabel *nameLabel;

- (void)initialize;

@end

@implementation PersonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initialize {
    _nameLabel = [UILabel new];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.top.greaterThanOrEqualTo(self.contentView.mas_top).offset(35);
    }];
}

@end

@implementation PersonCell (Configure)

- (void)configureWithPerson:(Person *)person {
    self.nameLabel.text = person.username;
}

@end
