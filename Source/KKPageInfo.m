//
//  KKPageInfo.m
//  KKTableView
//
//  Created by yiyang on 15/7/29.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import "KKPageInfo.h"

@implementation KKPageInfo

-(id)init
{
    self = [super init];
    
    self.pageSize = 20;
    self.currentPage = 1;
    
    return self;
}

-(NSDictionary*)toDictionary
{
    NSMutableDictionary *ret = [NSMutableDictionary new];
    [ret setObject:[NSString stringWithFormat:@"%ld", (long)_currentPage] forKey:@"currentPage"];
    [ret setObject:[NSString stringWithFormat:@"%ld", (long)_pageSize] forKey:@"pageSize"];
    
    return ret;
}

-(NSObject*)toObject:(NSDictionary *)dic
{
    if ([dic objectForKey:@"size"]) {
        self.pageSize = [[dic objectForKey:@"size"] integerValue];
    }
    if ([dic objectForKey:@"currentPage"]) {
        self.currentPage = [[dic objectForKey:@"currentPage"] integerValue];
    }
    if ([dic objectForKey:@"total"]) {
        self.totalCount = [[dic objectForKey:@"total"] integerValue];
    }
    if ([dic objectForKey:@"totalPage"]) {
        self.totalPage = [[dic objectForKey:@"totalPage"] integerValue];
    }
    
    return self;
}

-(BOOL)haveMore
{
    return self.totalPage > self.currentPage;
}


@end
