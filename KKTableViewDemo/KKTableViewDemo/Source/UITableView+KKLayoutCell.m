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

@implementation UITableView (KKLayoutCellInvalidateCache)

+ (void)load {
    SEL selectors[] = {
        @selector(reloadData),
        @selector(insertSections:withRowAnimation:),
        @selector(deleteSections:withRowAnimation:),
        @selector(reloadSections:withRowAnimation:),
        @selector(moveSection:toSection:),
        @selector(insertRowsAtIndexPaths:withRowAnimation:),
        @selector(deleteRowsAtIndexPaths:withRowAnimation:),
        @selector(reloadRowsAtIndexPaths:withRowAnimation:),
        @selector(moveRowAtIndexPath:toIndexPath:)
    };
    
    for (NSInteger index = 0; index < sizeof(selectors) / sizeof(SEL); index ++) {
        SEL originSelector = selectors[index];
        SEL newSelector = NSSelectorFromString([@"kk_" stringByAppendingString:NSStringFromSelector(originSelector)]);
        
        Method originalMethod = class_getInstanceMethod(self, originSelector);
        Method newMethod = class_getInstanceMethod(self, newSelector);
        
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

- (void)kk_reloadData {
    [self.kk_cellHeightCache.sections removeAllObjects];
    
    [self kk_reloadData];
    
}

- (void)kk_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        if (idx < self.kk_cellHeightCache.sections.count) {
            
            [self.kk_cellHeightCache.sections insertObject:@[].mutableCopy atIndex:idx];
        }
    }];
    
    [self kk_insertSections:sections withRowAnimation:animation];
}

- (void)kk_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        if (idx < self.kk_cellHeightCache.sections.count) {
            
            [self.kk_cellHeightCache.sections removeObjectAtIndex:idx];
        }
    }];
    
    [self kk_deleteSections:sections withRowAnimation:animation];
}

- (void)kk_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        if (idx < self.kk_cellHeightCache.sections.count) {
            NSMutableArray *rows = self.kk_cellHeightCache.sections[idx];
            for (NSInteger row = 0; row < rows.count; row ++) {
                rows[row] = @(_KKLayoutCellHeightCacheAbsentValue);
            }
        }
    }];
    
    [self kk_reloadSections:sections withRowAnimation:animation];
}

- (void)kk_moveSection:(NSInteger)section toSection:(NSInteger)newSection {
    
    NSInteger sectionCount = self.kk_cellHeightCache.sections.count;
    if (section < sectionCount && newSection < sectionCount) {
        [self.kk_cellHeightCache.sections exchangeObjectAtIndex:section withObjectAtIndex:newSection];
    }
    
    [self kk_moveSection:section toSection:newSection];
}

- (void)kk_insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [self.kk_cellHeightCache buildHeightCacheAtIndexPaths:indexPaths];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        NSMutableArray *rows = self.kk_cellHeightCache.sections[indexPath.section];
        [rows insertObject:@(_KKLayoutCellHeightCacheAbsentValue) atIndex:indexPath.row];
    }];
    
    [self kk_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)kk_deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    
    [self kk_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)kk_reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    
    [self kk_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
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
