//
//  UIcollectionDemo.m
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/24.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import "UIcollectionDemo.h"
#import "customFlowLayout.h"

@interface UIcollectionDemo ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation UIcollectionDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI{
    customFlowLayout *layout = [[customFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH*0.7, SCREEN_HEIGHT*0.7);
    UICollectionView *collection = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    collection.backgroundColor = [UIColor whiteColor];
    collection.delegate = self;
    collection.dataSource = self;
    [self.view addSubview:collection];
    [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH*0.7-100)/2, (SCREEN_HEIGHT*0.7-300)/2, 100, 300)];
    view.backgroundColor = [UIColor redColor];
    [cell.contentView addSubview:view];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
