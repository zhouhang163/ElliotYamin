//
//  ZQJEasyTabbarControl.m
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/20.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//  底部控制器

//*****vc***********//
#import "ZQJEasyHome.h"
#import "ZQJEasyUser.h"
#import "ZQJEasyOrder.h"
#import "ZQJEasyTabbarControl.h"

@interface ZQJEasyTabbarControl ()

@property (nonatomic, strong) UINavigationController *navHome;

@property (nonatomic, strong) UINavigationController *navOrder;

@property (nonatomic, strong) UINavigationController *navUser;


@end

@implementation ZQJEasyTabbarControl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTabbar];
}

- (void)setupTabbar{
    self.tabBar.barTintColor = [UIColor whiteColor];
    ZQJEasyHome *home = [[ZQJEasyHome alloc]init];
    self.navHome = [[UINavigationController alloc]initWithRootViewController:home];
    self.navHome.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"主页" image:[UIImage imageNamed:@"icon_home_gray"] tag:0];
    [self.navHome.tabBarItem setSelectedImage:[UIImage imageNamed:@"icon_home_green"]];

    
    ZQJEasyOrder *order = [[ZQJEasyOrder alloc]init];
    self.navOrder = [[UINavigationController alloc]initWithRootViewController:order];
    self.navOrder.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"订单" image:[UIImage imageNamed:@"icon_orderdan_gray"] tag:1];
    [self.navOrder.tabBarItem setSelectedImage:[UIImage imageNamed:@"icon_orderdan_green"]];
    
    ZQJEasyUser *user = [[ZQJEasyUser alloc]init];
    self.navUser = [[UINavigationController alloc]initWithRootViewController:user];
    self.navUser.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"icon_mine_gray"] tag:2];
    [self.navUser.tabBarItem setSelectedImage:[UIImage imageNamed:@"icon_mine_green"]];
   
    self.viewControllers = @[self.navHome,self.navOrder,self.navUser];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
