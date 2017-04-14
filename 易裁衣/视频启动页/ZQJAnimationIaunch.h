//
//  ZQJAnimationIaunch.h
//  易裁衣
//
//  Created by UT—ZQJ on 2017/4/5.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^enterAppBlcok)(void);

@interface ZQJAnimationIaunch : UIViewController

@property (nonatomic, strong) NSURL *videoUrl;///<视频url

- (void)enterAppBlock:(enterAppBlcok)block;

@end
