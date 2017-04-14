//
//  ZQJEasyNearbyMaster.m
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/23.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import "ZQJEasyNearbyMaster.h"
#import "NearbyMasterModel.h"
#import "ZQJNearbyMasterCell.h"
#import "ZQJNearbyMasterCell2.h"
#import "UITableView+FDTemplateLayoutCell.h"

static NSString *reuseID = @"reuseID";


@interface ZQJEasyNearbyMaster ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong) NSArray *temp;///<<#注释#>


@end

@implementation ZQJEasyNearbyMaster

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTab];
    [self setupNearbyData];
}

- (void)setupTab{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    //[self.tableView registerClass:[ZQJNearbyMasterCell class] forCellReuseIdentifier:reuseID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZQJNearbyMasterCell2" bundle:nil] forCellReuseIdentifier:reuseID];
}

- (void)setupNearbyData{
    NetworkHelper *helper = [NetworkHelper shareInstance];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"positionY",@30.55185280561471,@"mid",@"",@"positionX",@104.0645129046418, nil];
    NSDictionary *parmeterDic = [NSDictionary dictionaryWithObjectsAndKeys:@"condition",dic1,@"fetchSize",@20,@"findForward",@false, nil];
    [helper POST:@"https://api.egaiyi.com/api/pm/nearbypms.json" Parameters:parmeterDic Success:^(id responseObject) {
   
    } Failure:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
    NearbyMasterModel *model1 = [[NearbyMasterModel alloc]init];
    model1.desc = @"另外可以设通过设置约束的优先级来控制纯文本和纯图片情况下，上下多出来的间距";
    model1.count = 0;
    model1.images = @[];
    model1.dateStr = @"刚刚";
    
    NearbyMasterModel *model2 = [[NearbyMasterModel alloc]init];
    model2.desc = @"建议翻墙出去看下这篇帖子，你的这个方法性能上是有问题的，而且比较繁建议翻墙出去看下这篇帖子，你的这个方法性能上是有问题的，而且比较繁";
    model2.count = 1;
    model2.images = @[@""];
    model2.dateStr = @"昨天";

    
    NearbyMasterModel *model3 = [[NearbyMasterModel alloc]init];
    model3.desc = @"另外可以设通过设置约束的优先级来控制纯建议翻墙出去看下这篇帖子，你的这个方法性能上是有问题的，而且比较繁距";
    model3.count = 2;
    model3.images = @[@"",@"",@""];
    model3.dateStr = @"3-28 18:23";

    NearbyMasterModel *model4 = [[NearbyMasterModel alloc]init];
    model4.desc = @"建议翻墙出去看下这篇帖子，你的这个方法性能上是有问题的，而且比较繁过设置约束的优先级来控制纯文本和纯图片情况下，上下多出来的间距";
    model4.count = 3;
    model4.images = @[@"",@"",@"",@"",@"",@""];
    model4.dateStr = @"9小时前";

    NearbyMasterModel *model5 = [[NearbyMasterModel alloc]init];
    model5.desc = @"不知奥是不是只是储备不够导致现在情况，请好好反省下自己";
    model5.count = 3;
    model5.images = @[@"",@"",@"",@"",@"",@"",@""];
    model5.dateStr = @"3-22";

    self.temp = @[model1,model2,model3,model4,model5];
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.temp.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    ZQJNearbyMasterCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (cell == nil) {
//        cell = [[ZQJNearbyMasterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
//    }
//    [self configCell:cell indexpath:indexPath];
//    return cell;
    ZQJNearbyMasterCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:reuseID];
    [self configCell:cell2 indexpath:indexPath];
    return cell2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:reuseID configuration:^(id cell) {
        [self configCell:cell indexpath:indexPath];
    }];

}

- (void)configCell:(ZQJNearbyMasterCell2 *)cell indexpath:(NSIndexPath *)indexpath{
    NearbyMasterModel *model = self.temp[indexpath.row];
    cell.model = model;
    [cell.collectionView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
