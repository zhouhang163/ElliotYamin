//
//  ZQJEasyHome.m
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/20.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import "ZQJEasyHome.h"
#import "ZQJEasyHomeHeaderCell.h"
#import "HomeDataModel.h"
#import "ZQJEasyWebViewController.h"
#import "ZQJEasyLogin.h"
#import "ZQJEasyNearbyMaster.h"
#import "selectPlaceViewController.h"
#import "ZQJAnimationIaunch.h"




static NSString *cellIdentifier = @"ZQJEasyHomeHeaderCell";
static NSString * cellID = @"cellReuse";

@interface ZQJEasyHome ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ZQJEasyHomeHeaderCellDelegate>

@property (nonatomic, strong) UITableView *tableView;///<列表

@property (nonatomic, strong) NSArray *imagesCell;///<cell显示的图片

@property (nonatomic, strong) NSArray *titlesCell;///<cell显示标题

@property (nonatomic, strong) HomeDataModel *homeData;///<

@property (nonatomic, strong) SDCycleScrollView *sdScroll;///<<#注释#>

@property (nonatomic, strong) ZQJAnimationIaunch *lunchVC;///<<#注释#>


@end

@implementation ZQJEasyHome

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self judgeIsFirst];
}

- (void)judgeIsFirst{
    NSInteger isFirst = [[[NSUserDefaults standardUserDefaults] valueForKey:@"FIRST_ENTER_IN"]  integerValue];
    if (isFirst!=0) {
        return;
    }
    __block typeof(self) weakSelf = self;
    self.lunchVC = [[ZQJAnimationIaunch alloc]init];
    self.lunchVC.videoUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"intro" ofType:@"mp4"]];
    self.lunchVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.lunchVC enterAppBlock:^{
        [UIView animateWithDuration:1.0 animations:^{
            weakSelf.lunchVC.view.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf.lunchVC.view removeFromSuperview];
            weakSelf.lunchVC = nil;
            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"FIRST_ENTER_IN"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }];
    self.lunchVC.view.backgroundColor = [UIColor redColor];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.lunchVC.view];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self.lunchVC.view];

   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 7, 83, 30);
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn setTitle:@"成都市" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationItem setTitle:@"易改衣"];
    
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mapBtn addTarget:self action:@selector(enterehzFilesVC:) forControlEvents:UIControlEventTouchUpInside];
    [mapBtn setImage:[UIImage imageNamed:@"icon_navigationItem_map"] forState:UIControlStateNormal];
    [mapBtn sizeToFit];
    UIBarButtonItem *mapItem = [[UIBarButtonItem alloc] initWithCustomView:mapBtn];

    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuBtn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
    [menuBtn setImage:[UIImage imageNamed:@"menu_photo_big_pic_mode"] forState:UIControlStateNormal];
    [menuBtn sizeToFit];
    UIBarButtonItem * menuItem= [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.rightBarButtonItems  = @[menuItem,mapItem];
    self.imagesCell = @[@"icon_centralplant",@"icon_casepreview",@"icon_vip"];
    self.titlesCell = @[@"参观易改衣中央工厂",@"品牌案例",@"尊贵VIP"];
    [self setupUI];
    [self obtainData];
}

-(void)obtainData{
    
    //启动系统风火轮
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    //前面写服务器给的域名，后面拼接上需要提交的参数，假如参数是key=1
    
    NSString*domainStr=@"https://api.egaiyi.com/wap/app_ad_json2.html";
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    //以GET的形式提交，只需要将上面的请求地址给GET做参数就可以
    [manager GET:domainStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        self.homeData = [HomeDataModel mj_objectWithKeyValues:dic[@"data"]];
        NSMutableArray *temp = [NSMutableArray array];
        for (AdsModel *ad in self.homeData.ad) {
            [temp addObject:ad.pic];
        }
        self.sdScroll.imageURLStringsGroup = temp;
        [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        NSLog(@"%@",error);
    }];
    
}

- (void)setupUI{
 
  //头部滚动视图
    self.sdScroll = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0 , SCREEN_WIDTH, 150) delegate:self placeholderImage:[UIImage imageNamed:@"scrollPlaceholder.jpg"]];
    self.sdScroll.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.sdScroll.pageControlRightOffset = -30;
    self.sdScroll.currentPageDotImage = [UIImage imageNamed:@""];
    self.sdScroll.pageDotImage = [UIImage imageNamed:@""];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kTabBar_Height) style:UITableViewStylePlain];
    self.tableView.tableHeaderView = self.sdScroll;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
}

- (void)menuClick:(UIButton *)sender{
    NSArray *items = [AFFMenuDropItem itemsWithTitles:@[@"扫一扫",@"价目表",@"服务品牌",@"服务保障",@"帮组反馈"] images:@[@"icon_menu_sao",@"icon_menu_price",@"icon_menu_brand",@"icon_menu_server",@"icon_menu_contactus"]];
    AFFMenuDrop *drop = [AFFMenuDrop menuWithItems:items atLocation:EMenuDropLocationRight];
    [drop show];
}

#pragma mark 点击图片回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    ZQJEasyWebViewController *webVC = [[ZQJEasyWebViewController alloc]init];
    NSString *url = ((AdsModel *)self.homeData.ad[index]).url;;
    webVC.urlStr = url;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)handleAdwareChange{
    ZQJEasyWebViewController *webVC = [[ZQJEasyWebViewController alloc]init];
    NSString *url = ((AdwareModel *)self.homeData.adware[0]).url;;
    webVC.urlStr = url;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)handle2Login{
    ZQJEasyLogin *login = [[ZQJEasyLogin alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    [self presentViewController:nav animated:YES completion: nil];
}

- (void)nearbyMaster{
    self.tabBarController.tabBar.hidden=YES;
    //2.如果在push跳转时需要隐藏tabBar，设置self.hidesBottomBarWhenPushed=YES;
    self.hidesBottomBarWhenPushed=YES;
    ZQJEasyNearbyMaster *next=[[ZQJEasyNearbyMaster alloc]init];
    [self.navigationController pushViewController:next animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

#pragma mark tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  indexPath.row==0?327:44;
}

#pragma mark tableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ZQJEasyHomeHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.delegate = self;
        [cell setupData:self.homeData];
        return cell;
    }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
            view.backgroundColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:view];
        }
        cell.imageView.image = [UIImage imageNamed:self.imagesCell[indexPath.row-1]];
        cell.textLabel.text = self.titlesCell[indexPath.row-1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
