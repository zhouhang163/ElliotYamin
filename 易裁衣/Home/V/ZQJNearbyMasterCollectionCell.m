//
//  ZQJNearbyMasterCollectionCell.m
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/28.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import "ZQJNearbyMasterCollectionCell.h"

@interface ZQJNearbyMasterCollectionCell ()

@property (nonatomic, strong) UIImageView *imgV;

@end

@implementation ZQJNearbyMasterCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    self.imgV = [UIImageView new];
    [self.contentView addSubview:self.imgV];
    self.imgV.backgroundColor = [UIColor redColor];
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kMargin, kMargin, kMargin, kMargin));
    }];
}

@end
