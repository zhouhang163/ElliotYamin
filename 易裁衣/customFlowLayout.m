//
//  customFlowLayout.m
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/24.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import "customFlowLayout.h"

@implementation customFlowLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (void)prepareLayout{
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGRect frame = self.collectionView.frame;
    CGFloat insert = (frame.size.width-self.itemSize.width)*0.5;
    self.sectionInset = UIEdgeInsetsMake(0, insert, 0, insert);
    
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    CGRect frame = self.collectionView.frame;
    //获取super已经计算好的坐标
    NSArray *arrRect = [super layoutAttributesForElementsInRect:rect];
    //计算collection的中心点
    CGFloat centerX = self.collectionView.contentOffset.x+self.itemSize.width/2;
    for (UICollectionViewLayoutAttributes *attribute in arrRect) {
      //计算collection的中心点和cell的中心点的距离
        CGFloat delta = ABS(attribute.center.x - centerX);
        CGFloat scale = 1.2 - delta/frame.size.width;
    //设置缩放比例
        attribute.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return arrRect;
}

@end
