//
//  ZQJAnimationIaunch.m
//  易裁衣
//
//  Created by UT—ZQJ on 2017/4/5.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import "ZQJAnimationIaunch.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ZQJAnimationIaunch ()

@property (nonatomic, strong)MPMoviePlayerController *mediaPlayer;///<视频播放控制器
@property (nonatomic, strong) UIButton *skipBtn;///<跳过btn
@property (nonatomic, strong) UIButton *enterBtn;///<进入btn
@property (nonatomic, copy) enterAppBlcok enterBlcok;///<进入appBlock



@end

@implementation ZQJAnimationIaunch

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.mediaPlayer prepareToPlay];
    [self.mediaPlayer play];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [self creatUI];
    
}

- (void)creatUI{
    self.mediaPlayer = [[MPMoviePlayerController alloc]initWithContentURL:self.videoUrl];
    self.mediaPlayer.shouldAutoplay = YES;
    self.mediaPlayer.view.userInteractionEnabled = YES;
    self.mediaPlayer.repeatMode = MPMovieRepeatModeNone;
    self.mediaPlayer.controlStyle = MPMovieControlStyleNone;
    self.mediaPlayer.movieSourceType = MPMovieSourceTypeFile;
    self.mediaPlayer.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:self.mediaPlayer.view];
//    UIView *view = [[UIView alloc]initWithFrame:self.view.bounds];
//    view.backgroundColor = [UIColor clearColor];
//    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skip:)]];
//    [self.mediaPlayer.view addSubview:view];
    self.skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipBtn.tag = 66;
    self.skipBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.skipBtn.layer.borderWidth = 2;
    self.skipBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.skipBtn.titleLabel.textColor = [UIColor whiteColor];
    [self.mediaPlayer.view addSubview:self.skipBtn];
    [self.skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [self.skipBtn addTarget:self action:@selector(enterApp:) forControlEvents:UIControlEventTouchUpInside];
    [self.skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mediaPlayer.view).offset(-kPadingX);
        make.top.equalTo(self.mediaPlayer.view).and.offset(kPadingY);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    self.enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.enterBtn.tag = 666;
    self.enterBtn.layer.cornerRadius = 8;
    self.enterBtn.layer.masksToBounds = YES;
    self.enterBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    self.enterBtn.titleLabel.textColor = [UIColor whiteColor];
    self.enterBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.enterBtn.layer.borderWidth = 2;
    [self.enterBtn addTarget:self action:@selector(enterApp:) forControlEvents:UIControlEventTouchUpInside];
    [self.enterBtn setTitle:@"进入App" forState:UIControlStateNormal];
    [self.mediaPlayer.view addSubview:self.enterBtn];
    [self.enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mediaPlayer.view);
        make.centerY.equalTo(self.mediaPlayer.view);
        make.size.mas_equalTo(CGSizeMake(0, 40));
    }];
    
}



- (void)enterApp:(UIButton *)sender{
    if (self.enterBlcok) {
        self.enterBlcok();
    }
}

- (void)enterAppBlock:(enterAppBlcok)block{
    if (block) {
        self.enterBlcok = block;
    }
}

- (void)playFished:(NSNotification *)sender{
    [self.enterBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.mediaPlayer.view layoutIfNeeded];
    }];
    [self.mediaPlayer setRepeatMode:MPMovieRepeatModeOne];
    [self.mediaPlayer play];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
