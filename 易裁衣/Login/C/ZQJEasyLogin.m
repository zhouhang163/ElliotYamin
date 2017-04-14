//
//  ZQJEasyLogin.m
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/22.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import "ZQJEasyLogin.h"
#import "ZQJEasyRegister.h"

@interface ZQJEasyLogin ()
@property (weak, nonatomic) IBOutlet UITextField *userTf;
@property (weak, nonatomic) IBOutlet UITextField *pwTf;

@end

@implementation ZQJEasyLogin

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
//登录界面小时
- (IBAction)loginDismiss:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//登录
- (IBAction)login:(id)sender {
    
}
//忘记密码
- (IBAction)forgetPassword:(UIButton *)sender {
    
}
//快速登录
- (IBAction)speedLoginUseIphone:(id)sender {
    
}
//其他登录方式
- (IBAction)otherLoginType:(id)sender {
    
}
//注册界面
- (IBAction)registerAccount:(UIButton *)sender {
    ZQJEasyRegister *registerVc = [[ZQJEasyRegister alloc]init];
    [self.navigationController pushViewController:registerVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
