//
//  ZQJNearbyMasterGridView.m
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/28.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import "ZQJNearbyMasterGridView.h"
#import "ZQJNearbyMasterCollectionCell.h"

static NSString *cellReuseID = @"cellReuseID";

@interface ZQJNearbyMasterGridView ()<UICollectionViewDelegate,UICollectionViewDataSource>


@end

@implementation ZQJNearbyMasterGridView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH/3);
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZQJNearbyMasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseID forIndexPath:indexPath];
    return  cell;
}

@end
