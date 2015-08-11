//
//  KKDataViewControllerDelegate.h
//  KKTableViewDemo
//
//  Created by yiyang on 15/8/11.
//  Copyright © 2015年 yiyang. All rights reserved.
//

#ifndef KKDataViewControllerDelegate_h
#define KKDataViewControllerDelegate_h

@protocol KKDataViewControllerDelegate <NSObject>

@optional
- (void)kk_dataViewWillRefresh;
- (void)kk_dataViewWillLoadMore;

- (void)kk_dataViewDidConfigureDataView;
- (void)kk_dataViewDidConfigureDataSource;

@end

#endif /* KKDataViewControllerDelegate_h */
