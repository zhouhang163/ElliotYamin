//
//  NSString+size.m
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/27.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import "NSString+size.h"

@implementation NSString (size)
//根据字符串长度获取对应的宽度或者高度
+(float)measureMutilineStringHeight:(NSString*)str andFont:(UIFont*)wordFont andWidthSetup:(float)width{
    if (str == nil || width <= 0) return 0;
    CGSize measureSize;
    if(IOS_VERSION < 7.0){
        measureSize = [str sizeWithFont:wordFont constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    }else{
        measureSize = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:wordFont, NSFontAttributeName, nil] context:nil].size;
    }
    return ceil(measureSize.height);
}
@end
