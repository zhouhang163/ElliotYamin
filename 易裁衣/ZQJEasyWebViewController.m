//
//  ZQJEasyWebViewController.m
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/22.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import "ZQJEasyWebViewController.h"

@interface ZQJEasyWebViewController ()

@property (nonatomic, strong)UIWebView *webView;

@end

@implementation ZQJEasyWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWebView];
}

- (void)initWebView{
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.view addSubview:self.webView];
    NSURL *url = [NSURL URLWithString:self.urlStr];
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 3. 发送请求给服务器
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
