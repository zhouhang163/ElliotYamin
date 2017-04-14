//
//  NearbyMasterModel.h
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/23.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearbyMasterModel : NSObject

@property (copy, nonatomic) NSString *name;

@property (nonatomic, assign) int count;///<<#注释#>

@property (nonatomic, copy) NSString *desc;///<<#注释#>

@property (nonatomic, assign) CGFloat collectionHeight;///<<#注释#>

@property (nonatomic, assign) CGFloat height;///<<#注释#>

@property (nonatomic, assign) NSString *dateStr;///<<#注释#>

@property (nonatomic, strong) NSArray *images;///<图片数组


@end
