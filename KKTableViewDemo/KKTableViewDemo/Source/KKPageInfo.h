//
//  KKPageInfo.h
//  KKTableView
//
//  Created by yiyang on 15/7/29.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKPageInfo : NSObject

@property(nonatomic)NSInteger           pageSize;
@property(nonatomic)NSInteger           currentPage;
@property(nonatomic)NSInteger           totalPage;
@property(nonatomic)NSInteger           totalCount;

-(BOOL)haveMore;

@end
