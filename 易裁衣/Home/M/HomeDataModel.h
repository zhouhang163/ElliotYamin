//
//  HomeDataModel.h
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/22.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdsModel : NSObject
@property (nonatomic, copy) NSString *title;///<<#注释#>
@property (nonatomic, copy) NSString *pic;///<<#注释#>
@property (nonatomic, copy) NSString *url;///<<#注释#>

@end

@interface AdwareModel : NSObject

@property (nonatomic, copy) NSString *title;///<<#注释#>
@property (nonatomic, copy) NSString *pic;///<<#注释#>
@property (nonatomic, copy) NSString *url;///<<#注释#>

@end

@interface RecommendModel : NSObject


@end

@interface HomeDataModel : NSObject

@property (nonatomic, strong) NSMutableArray *ad;///<<#注释#>
@property (nonatomic, strong) NSMutableArray *adware;///<注释
@property (nonatomic, strong) NSMutableArray *recommend;///<注释
+ (NSDictionary *)mj_objectClassInArray;
@end
