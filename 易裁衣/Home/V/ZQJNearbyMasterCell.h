//
//  ZQJNearbyMasterCell.h
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/28.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearbyMasterModel.h"
#import "ZQJNearbyMasterGridView.h"

@interface ZQJNearbyMasterCell : UITableViewCell

@property (nonatomic, strong) ZQJNearbyMasterGridView  *gridView;///<展示图片九宫格
@property (nonatomic, strong) NearbyMasterModel *model;///<<#注释#>

@end
