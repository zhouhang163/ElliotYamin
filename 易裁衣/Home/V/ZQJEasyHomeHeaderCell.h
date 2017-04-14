//
//  ZQJEasyHomeHeaderCell.h
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/21.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDataModel.h"

@protocol ZQJEasyHomeHeaderCellDelegate <NSObject>

//点击充值跳转web界面
- (void)handleAdwareChange;

//点击到登录界面
- (void)handle2Login;

//附近量体师
- (void)nearbyMaster;

@end

@interface ZQJEasyHomeHeaderCell : UITableViewCell

@property (nonatomic, assign) id<ZQJEasyHomeHeaderCellDelegate>delegate;///<cell操作代理

- (void)setupData:(HomeDataModel *)model;

@end
