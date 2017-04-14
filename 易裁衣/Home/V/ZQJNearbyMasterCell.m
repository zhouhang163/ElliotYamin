//
//  ZQJNearbyMasterCell.m
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/28.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import "ZQJNearbyMasterCell.h"
#import "ZQJNearbyMasterCollectionCell.h"

static NSString *cellReuseID = @"cellReuseID";

@interface ZQJNearbyMasterCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UIImageView *icon;///<头像

@property (nonatomic, strong) UILabel *nameLab;///<名字

@property (nonatomic, strong) UILabel *descLab;///<描述

@property (nonatomic, strong) UILabel *likeCountLab;///<多少人喜欢

@property (nonatomic, strong) UICollectionView *collectionView;//图片展




@end

@implementation ZQJNearbyMasterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    self.icon = [UIImageView new];
    self.icon.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(kPadingY);
        make.left.mas_equalTo(self.contentView).offset(kPadingX);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    self.nameLab = [UILabel new];
    self.nameLab.text = @"jianchip";
    self.nameLab.font = [UIFont systemFontOfSize:15];
    self.nameLab.textColor = [UIColor darkTextColor];
    [self.contentView addSubview:self.nameLab];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(kPadingY);
        make.left.mas_equalTo(self.icon.mas_right).offset(kPadingX);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-kPadingX*3-50, 20));
    }];
    self.likeCountLab = [UILabel new];
    self.likeCountLab.text = @"喜欢 19";
    self.likeCountLab.font = [UIFont systemFontOfSize:13];
    self.likeCountLab.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.likeCountLab];
    [self.likeCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(kPadingY);
        make.left.mas_equalTo(self.icon.mas_right).offset(kPadingX);
        make.size.mas_equalTo(self.nameLab);
    }];
    //分割线
    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.likeCountLab.mas_bottom).offset(kPadingY);
        make.left.mas_equalTo(self.contentView).offset(kPadingX);
        make.right.mas_equalTo(self.contentView).offset(-kPadingX);
        make.height.mas_equalTo(@1);
    }];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //描述lab
    self.descLab = [UILabel new];
    [self.contentView addSubview:self.descLab];
    [self.descLab preferredMaxLayoutWidth];
    self.descLab.numberOfLines = 0;
    self.descLab.text = @"几种设置UITableView的cell动态高度的方法 - 极客传奇 - 博客园";
    self.descLab.font = [UIFont systemFontOfSize:15];
    self.descLab.textColor = [UIColor darkTextColor];
    [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom);
        make.left.mas_equalTo(self.contentView).offset(kPadingX);
        make.right.mas_equalTo(self.contentView).offset(-kPadingX);
        make.bottom.mas_equalTo(self.contentView).offset(-kPadingY);
    }];
    //分割线
    UIView *lineBottom = [UIView new];
    lineBottom.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:lineBottom];
    [lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.descLab.mas_bottom).offset(1);
        make.left.right.mas_equalTo(self.descLab);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-kPadingX*2, 1));
    }];
    //展示图片
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH/3);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.contentView addSubview:self.collectionView];
    [self.collectionView registerClass:[ZQJNearbyMasterCollectionCell class] forCellWithReuseIdentifier:cellReuseID];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineBottom.mas_bottom);
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(SCREEN_WIDTH/3);
    }];
//    self.gridView = [ZQJNearbyMasterGridView new];
//    self.gridView.backgroundColor = [UIColor redColor];
//    [self addSubview:self.gridView];
//    [self.gridView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.descLab.mas_bottom);
//        make.left.mas_equalTo(self.contentView);
//        make.right.mas_equalTo(self.contentView);
//        make.height.mas_equalTo(@(SCREEN_WIDTH/3));
//        //make.bottom.mas_equalTo(self.contentView).offset(-kPadingY);
//    }];

}

- (void)setModel:(NearbyMasterModel *)model{
    _model = model;
    self.descLab.text = model.desc;
    if (model.images.count>=1&&model.images.count<=3) {
    
       
    }

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZQJNearbyMasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseID forIndexPath:indexPath];
    return  cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.model.images.count!=0) {
        CGFloat width = SCREEN_WIDTH ;
        if (self.model.images.count == 1)
        {
            return CGSizeMake(width / 2, width / 1.5);
        }
        else
        {
            return CGSizeMake(width / 3, width / 3);
        }
    }else{
        return CGSizeZero;
    }
}

@end
