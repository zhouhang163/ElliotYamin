//
//  ZQJNearbyMasterCell2.m
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/29.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import "ZQJNearbyMasterCell2.h"
#import "ZQJNearbyMasterCollectionCell.h"

static NSString *cellReuseID = @"cellReuseID";

@interface ZQJNearbyMasterCell2 ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation ZQJNearbyMasterCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[ZQJNearbyMasterCollectionCell class] forCellWithReuseIdentifier:cellReuseID];
}


- (void)setModel:(NearbyMasterModel *)model{
    _model = model;
    self.descLab.text = model.desc;
    self.nameLab.text = @"是、收到";
    self.secLab.text = @"帅帅哒所多";
    // 没图片就高度为0 （约束是可以拖出来的哦哦）
    CGFloat width = SCREEN_WIDTH - 80;
    if (self.model.images.count==0)
    {
        self.height.constant = 0;
    }
    else
    {
        if (self.model.images.count == 1)
        {
            self.height.constant = width / 1.5;
        }
        else
        {
            CGFloat height = ((self.model.images.count - 1) / 3 + 1) * (width / 3) + (self.model.images.count - 1) / 3 * 15;
            self.height.constant = height;
        }
    }
    self.timeLab.text = model.dateStr;
}
- (IBAction)btnShow:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.viewShowWidth.constant = 110;
    }else{
        self.viewShowWidth.constant = 0;
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self.contentView layoutSubviews];
    }];
}

#pragma mark - colletionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZQJNearbyMasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseID forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = SCREEN_WIDTH - 80 - 20;
    if (self.model.images.count!=0)
    {
        if (self.model.images.count == 1)
        {
            return CGSizeMake(width / 2, width / 1.5);
        }
        else
        {
            return CGSizeMake(width / 3, width / 3);
        }
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

@end
