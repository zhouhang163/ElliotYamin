//
//  ZQJEasyRegister.m
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/22.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import "ZQJEasyRegister.h"

@interface ZQJEasyRegister ()
@property (weak, nonatomic) IBOutlet UITextField *userTf;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;
@property (weak, nonatomic) IBOutlet UITextField *pwTf;
@property (weak, nonatomic) IBOutlet UITextField *tfAgain;
@property (nonatomic, strong) NSTimer *timer;///<<#注释#>
@property (nonatomic, assign) NSInteger sec;///<<#注释#>

@property (weak, nonatomic) IBOutlet UIButton *btnCode;

@end

@implementation ZQJEasyRegister

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    
}

- (IBAction)registerClicked:(UIButton *)sender {
}
- (IBAction)pop2Login:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)getCode:(UIButton *)sender {
    if (![self.btnCode.titleLabel.text isEqualToString:@"获取验证码"]) {
        return;
    }
    self.sec = 60;
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
    NetworkHelper *help = [NetworkHelper shareInstance];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"phone",@"15208436506",nil];
    [help POST:@"https://api.egaiyi.com/api/tmp_3998ab4foRapp/getcodes" Parameters:dic Success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } Failure:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
}

- (void)timerRun{
    [self.btnCode setTitle:[NSString stringWithFormat:@"%ld秒",self.sec] forState:UIControlStateNormal];
    self.sec--;
    if (self.sec==0) {
        [self.timer invalidate];
        self.timer = nil;
        [self.btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
