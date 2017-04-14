//
//  ZQJEasyHomeHeaderCell.m
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/21.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import "ZQJEasyHomeHeaderCell.h"
#import "UIImageView+WebCache.h"

@interface ZQJEasyHomeHeaderCell ()

@property (weak, nonatomic) IBOutlet UIView *cuirVIew;
@property (weak, nonatomic) IBOutlet UIImageView *adwareImgV;

@end
@implementation ZQJEasyHomeHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.cuirVIew addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLogin)]];
    self.adwareImgV.userInteractionEnabled = YES;
    [self.adwareImgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlAdware)]];
}

- (void)setupData:(HomeDataModel *)model{
    [self.adwareImgV sd_setImageWithURL:[NSURL URLWithString:((AdwareModel *)(model.adware[0])).pic] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.adwareImgV.image = image;
    }];
}

- (void)handlAdware{
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleAdwareChange)]) {
        [self.delegate handleAdwareChange];
    }
}
- (IBAction)nearbyMaster:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(nearbyMaster)]) {
        [self.delegate nearbyMaster];
    }
}

- (void)handleLogin{
    if (self.delegate && [self.delegate respondsToSelector:@selector(handle2Login)]) {
        [self.delegate handle2Login];
    }
}

@end
