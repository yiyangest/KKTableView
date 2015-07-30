//
//  UITableView+KKLayoutCell.m
//  KKTableView
//
//  Created by yiyang on 15/7/30.
//  Copyright (c) 2015年 yiyang. All rights reserved.
//

#import "UITableView+KKLayoutCell.h"
#import "KKBaseCell.h"
#import "KKTableViewDataSource.h"
#import <objc/runtime.h>

#pragma mark - Cache Data Structure

@interface _KKLayoutCellHeightCache : NSObject

@property (nonatomic, strong) NSMutableArray *sections;

@end

static CGFloat const _KKLayoutCellHeightCacheAbsentValue = -1;

@implementation _KKLayoutCellHeightCache

- (void)buildHeightCacheAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) {
        return;
    }
    
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        NSAssert(indexPath.section >= 0, @"indexPath section should > 0");
        
        for (NSInteger section = self.sections.count; section <= indexPath.section; section ++) {
            self.sections[section] = @[].mutableCopy;
        }
        
        NSMutableArray *rows = self.sections[indexPath.section];
        
        for (NSInteger row = rows.count; row <= indexPath.row; row ++) {
            rows[row] = @(_KKLayoutCellHeightCacheAbsentValue);
        }
    }];
}

- (BOOL)hasCachedHeightAtIndexPath:(NSIndexPath *)indexPath {
    [self buildHeightCacheAtIndexPaths:@[indexPath]];
    NSNumber *cached = self.sections[indexPath.section][indexPath.row];
    return ![cached isEqualToNumber:@(_KKLayoutCellHeightCacheAbsentValue)];
}

- (void)cacheHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath {
    [self buildHeightCacheAtIndexPaths:@[indexPath]];
    self.sections[indexPath.section][indexPath.row] = @(height);
}

- (CGFloat)cachedHeightAtIndexPath:(NSIndexPath *)indexPath {
    [self buildHeightCacheAtIndexPaths:@[indexPath]];
    
    return [self.sections[indexPath.section][indexPath.row] floatValue];
}

- (NSMutableArray *)sections {
    if (_sections == nil) {
        _sections = @[].mutableCopy;
    }
    return _sections;
}

@end


#pragma mark - UITableView + KKLayoutCellPrivate
@interface UITableView (KKLayoutCellPrivate)

@property (nonatomic, strong, readonly) _KKLayoutCellHeightCache *kk_cellHeightCache;

- (id)kk_templateCellForReuseIdentifier:(NSString *)identifier;

@end

@implementation UITableView (KKLayoutCellPrivate)

- (id)kk_templateCellForReuseIdentifier:(NSString *)identifier {
    NSMutableDictionary *templateCellDicts = objc_getAssociatedObject(self, _cmd);
    if (!templateCellDicts) {
        templateCellDicts = @{}.mutableCopy;
        objc_setAssociatedObject(self, _cmd, templateCellDicts, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    UITableViewCell *cell = [templateCellDicts objectForKey:identifier];
    if (!cell) {
        cell = [self dequeueReusableCellWithIdentifier:identifier];
        
        NSAssert(cell != nil, @"No such cell register with: %@", identifier);
        
        [templateCellDicts setObject:cell forKey:identifier];
    }
    
    return cell;
    
}

- (_KKLayoutCellHeightCache *)kk_cellHeightCache {
    _KKLayoutCellHeightCache *cache = objc_getAssociatedObject(self, _cmd);
    if (!cache) {
        cache = [_KKLayoutCellHeightCache new];
        objc_setAssociatedObject(self, _cmd, cache, OBJC_ASSOCIATION_RETAIN);
    }
    return cache;
}

@end

#pragma mark -Public API: UITableView + KKLayoutCell

@implementation UITableView (KKLayoutCell)

- (void)kk_registerCellClass:(Class)aCellClass {
    
    NSString *cellIdentifier = NSStringFromClass(aCellClass);
    if ([aCellClass isSubclassOfClass:[KKBaseCell class]]) {
        cellIdentifier = [(id)aCellClass performSelector:@selector(cellReuseIdentifier) withObject:nil];
    }
    
    [self registerClass:aCellClass forCellReuseIdentifier:cellIdentifier];
    
}

- (void)kk_registerNibOfCellClass:(Class)aCellClass {
    NSString *cellIdentifier = NSStringFromClass(aCellClass);
    UINib *nib = nil;
    
    if ([aCellClass isSubclassOfClass:[KKBaseCell class]]) {
        cellIdentifier = [(id)aCellClass performSelector:@selector(cellReuseIdentifier) withObject:nil];
        nib = [(id)aCellClass performSelector:@selector(nib) withObject:nil];
    }
    
    NSAssert(nib != nil, @"register nib is nil of the class: %@!", aCellClass);
    
    [self registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
}

- (CGFloat)kk_heightForCellWithIdentifier:(NSString *)identifier byIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self kk_templateCellForReuseIdentifier:identifier];
    
    [cell prepareForReuse];
    
    KKTableViewDataSource *dataSource = self.dataSource;
    id item = [dataSource itemAtIndexPath:indexPath];
    dataSource.configureBlock(cell, item);
    
    CGSize cellSize = CGSizeZero;
    cellSize = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    if (self.separatorStyle != UITableViewCellSeparatorStyleNone) {
        cellSize.height += 1.0 / [UIScreen mainScreen].scale;
    }
    
    NSLog(@"caculate cell height for IndexPath: %@", @(indexPath.row));
    
    return cellSize.height;
}

- (CGFloat)kk_heightForCellWithIdentifier:(NSString *)identifier cacheByIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.kk_cellHeightCache hasCachedHeightAtIndexPath:indexPath]) {
        return [self.kk_cellHeightCache cachedHeightAtIndexPath:indexPath];
    }
    
    CGFloat height = [self kk_heightForCellWithIdentifier:identifier byIndexPath:indexPath];
    
    [self.kk_cellHeightCache cacheHeight:height atIndexPath:indexPath];
    
    return height;
}

@end
