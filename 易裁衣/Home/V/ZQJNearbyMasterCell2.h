//
//  ZQJNearbyMasterCell2.h
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/29.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearbyMasterModel.h"

@interface ZQJNearbyMasterCell2 : UITableViewCell

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UILabel *descLab;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *secLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewShowWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;

@property (nonatomic, strong)  NearbyMasterModel *model;///<moxing


@end
