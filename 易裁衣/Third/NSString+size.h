//
//  NSString+size.h
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/27.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (size)
+(float)measureMutilineStringHeight:(NSString*)str andFont:(UIFont*)wordFont andWidthSetup:(float)width;
@end
