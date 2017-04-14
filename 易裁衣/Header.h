//
//  Header.h
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/20.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define STATUSBAR_HEIGHT ([UIApplication sharedApplication].statusBarFrame.size.height)

#define NAVGATION_HEIGHT self.navigationController.navigationBar.frame.size.height

#define ROOTVC [[[[UIApplication sharedApplication] delegate] window] rootViewController]

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define kPadingX 15

#define kPadingY 15

#define kMargin 8

#define kIconWidth 40

//NavBar高度
#define kNavigationBar_Height 44
#define kStatusBar_Height 20
#define kTabBar_Height  49

#import "SDCycleScrollView.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "AFFMenuDrop.h"
#import "NetworkHelper.h"

#endif /* Header_h */
