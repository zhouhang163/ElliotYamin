//
//  ZQJEasyLogin.h
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/22.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIButtonClickedType) {
    UIButtonClickedDismiss,//登录界面小时
    UIButtonClickedLogin,
    UIButtonClickedRegister,
    UIButtonClickedForgetPassWord,
    UIButtonClickedSpeedLogin,
    UIButtonClickedOtherLogin
};

@interface ZQJEasyLogin : UIViewController

@end
