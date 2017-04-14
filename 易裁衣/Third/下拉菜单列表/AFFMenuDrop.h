//
//  CustomMenuDrop.h
//  CostomAlertView
//
//  Created by Lydix-Liu on 15/8/14.
//  Copyright (c) 2015年 某隻. All rights reserved.
//

typedef enum {
    EMenuDropLocationCenter,
    EMenuDropLocationLeft,
    EMenuDropLocationRight,
}EMenuDropLocation;

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AFFMenuDropItem;
@class AFFMenuDrop;

/**
 *  下拉菜单代理,提供两种代理方法,可根据实际情况选择,建议使用menuDrop:didSelectItemAtIndex:
 */
@protocol AFFMenuDropDelegate <NSObject>

@optional
/**
 *  菜单代理方法
 *
 *  @param menu 菜单对象
 *  @param item 所选项的对象
 */
- (void)menuDrop:(AFFMenuDrop *)menu didSelectItem:(AFFMenuDropItem *)item;


/**
 *  菜单代理方法
 *
 *  @param menu  菜单对象
 *  @param index 所选项的位置
 */
- (void)menuDrop:(AFFMenuDrop *)menu didSelectItemAtIndex:(NSInteger)index;

@end





/**
 *  下拉菜单
 */
@interface AFFMenuDrop : UIControl <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

/** 菜单位置,默认为：EMenuDropLocationCenter */
@property (nonatomic, assign) EMenuDropLocation location;

/** 菜单标题 */
@property (nonatomic, retain) NSMutableArray *mArrItems;

/** 菜单显示区域 */
@property (nonatomic, retain) UIView *dropView;

/** 代理 */
@property (nonatomic, weak) id<AFFMenuDropDelegate> delegate;

/**
 *  初始化方法
 *
 *  @param items    菜单项
 *  @param location 菜单位置
 *
 *  @return AFFMenuDrop对象
 */
+ (AFFMenuDrop *)menuWithItems:(NSArray *)items atLocation:(EMenuDropLocation)location;

- (id)initWithItems:(NSArray *)items atLocation:(EMenuDropLocation)location;

/**
 *  显示当前menu
 */
- (void)show;

- (void)dismiss;

@end



/**
 *  下拉菜单选项
 */
@interface AFFMenuDropItem : NSObject

@property (nonatomic, strong) NSString *imageName;///< 显示图片

@property (nonatomic, strong) NSString *title;///< 显示名称

@property (nonatomic, assign) NSInteger index;///< 显示位置

+ (AFFMenuDropItem *)initWithTitle:(NSString *)title imageName:(NSString *)imageName;

+ (NSArray *)itemsWithTitles:(NSArray *)titles images:(NSArray *)images;

@end

