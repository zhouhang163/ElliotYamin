//
//  selectPlaceViewController.m
//  易裁衣
//
//  Created by UT—ZQJ on 2017/3/24.
//  Copyright © 2017年 UT—ZQJ. All rights reserved.
//

#import "selectPlaceViewController.h"
#import "UIcollectionDemo.h"
#define kPadingX 10 
#define kPadingY 10

@interface selectPlaceViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) BOOL isOpenLocation;///<是否开启定位

@property (nonatomic, strong)UIView *viewHeader;//头部视图

@property (nonatomic, strong)UIView *selView;//头部视图

@property (nonatomic, strong) UITableView *tableViewInland;///<国内

@property (nonatomic, strong) UITableView *tableViewForeign;///<国外

@property (nonatomic, strong) NSMutableArray *mInlandCitys;///<国内城市

@property (nonatomic, strong) NSMutableArray *mForeignCitys;///<国外城市

@property (nonatomic, weak) UIScrollView *scrollContent;///<<#注释#>

@property (nonatomic, strong) UILabel *animationLab;///<<#注释#>


@end

@implementation selectPlaceViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isOpenLocation = YES;
    // Do any additional setup after loading the view.
    self.viewHeader = [self setupHeaderView];
    [self setupBottomCloseView];
    [self.view addSubview:self.viewHeader];
    [self setupContenView];
    [self setupData];
}

- (void)setupContenView{
    CGFloat height = SCREEN_HEIGHT-CGRectGetMaxY(self.viewHeader.frame)-40;
    UIScrollView *scrContent = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.viewHeader.frame), SCREEN_WIDTH, height)];
    scrContent.delegate = self;
    scrContent.backgroundColor = [UIColor greenColor];
    scrContent.pagingEnabled = YES;
    scrContent.showsHorizontalScrollIndicator = NO;
    scrContent.contentSize = CGSizeMake(SCREEN_WIDTH*2, height);
    for (int i = 0; i<2; i++) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, height) style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [scrContent addSubview:tableView];
        if (i==0) {
            self.tableViewInland = tableView;
        }else{
            self.tableViewForeign = tableView;
        }
        tableView.tableHeaderView = [self tableHeader:i==0];
    }
    self.scrollContent = scrContent;
    [self.view addSubview:scrContent];
}

- (UIView *)setupHeaderView{
    UIView *viewHeader = [UIView new];
    viewHeader.backgroundColor = [UIColor greenColor];
    viewHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140);
    //顶部按钮选择父视图
    self.selView  = [UIView new];
    self.selView.backgroundColor = [UIColor orangeColor];
    self.selView.layer.cornerRadius = 10;
    self.selView.layer.masksToBounds = YES;
    [viewHeader addSubview:self.selView];
    [self.selView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewHeader).offset(40);
        make.centerX.equalTo(viewHeader);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    //滑动视图
    self.animationLab = [UILabel new];
    self.animationLab.layer.cornerRadius = 10;
    self.animationLab.layer.masksToBounds = YES;
    self.animationLab.textAlignment = NSTextAlignmentCenter;
    [viewHeader addSubview:self.animationLab];
    self.animationLab.userInteractionEnabled = YES;
    self.animationLab.backgroundColor = [UIColor whiteColor];
    self.animationLab.text = @"国内";
    self.animationLab.font = [UIFont systemFontOfSize:15];
    [self.animationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selView.mas_top);
        make.left.equalTo(self.selView.mas_left);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    //国内btn
    UIButton *btnInland = [UIButton new];
    btnInland.layer.cornerRadius = 10;
    btnInland.layer.masksToBounds = YES;
    [btnInland setTitle:@"国内" forState:UIControlStateNormal];
    btnInland.tag = 200;
    [btnInland addTarget:self action:@selector(changeData:) forControlEvents:UIControlEventTouchUpInside];
    btnInland.selected = YES;
    [self.selView addSubview:btnInland];
    [btnInland mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selView.mas_top);
        make.left.equalTo(self.selView.mas_left);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
     //国外btn
    UIButton *btnForeign = [UIButton new];
    btnForeign.tag = 300;
    [btnForeign addTarget:self action:@selector(changeData:) forControlEvents:UIControlEventTouchUpInside];
    btnForeign.layer.cornerRadius = 10;
    btnForeign.layer.masksToBounds = YES;
    [btnForeign setTitle:@"国外" forState:UIControlStateNormal];
    [self.selView addSubview:btnForeign];
    [btnForeign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selView.mas_top);
        make.left.equalTo(btnInland.mas_right);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    //搜索
    UITextField *tfSeek = [UITextField new];
    tfSeek.font = [UIFont systemFontOfSize:15];
    tfSeek.textColor = [UIColor whiteColor];
    tfSeek.placeholder = @"搜索城市名称或拼音";
    [viewHeader addSubview:tfSeek];
    UIImageView *leftImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    leftImgV.image = [UIImage  imageNamed:@"lALOtUJk_yQk_36_36.png"];
    tfSeek.leftView = leftImgV;
    tfSeek.leftViewMode = UITextFieldViewModeAlways;
    [tfSeek mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selView.mas_bottom).offset(20);
        make.left.equalTo(viewHeader.mas_left).offset(kPadingX);
        make.right.equalTo(viewHeader.mas_right).offset(-kPadingX);
        make.height.equalTo(@30);
    }];
    //分割线
    UIView *viewLine = [UIView new];
    viewLine.backgroundColor = [UIColor whiteColor];
    [viewHeader addSubview:viewLine];
    [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(tfSeek.mas_leading);
        make.trailing.equalTo(tfSeek.mas_trailing);
        make.top.equalTo(tfSeek.mas_bottom).offset(kPadingX);
        make.bottom.equalTo(viewHeader.mas_bottom).offset(-1);
        make.height.equalTo(@1);
    }];
    return viewHeader;
}

- (UIView *)tableHeader:(BOOL)isInland{
    NSArray *hotCitys = isInland?@[@"北京",@"上海",@"深圳",@"广州",@"成都",@"杭州",@"南京"]:@[@"日本"];
    CGFloat dealY = 0;
    //装载内容视图
    UIView *viewInlandHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    //显示定位标签
    UILabel *locationLab = [[UILabel alloc]initWithFrame:CGRectMake(kPadingX, kPadingY, SCREEN_WIDTH-kPadingX*2, 20)];
    locationLab.font = [UIFont systemFontOfSize:15];
    locationLab.text = @"成都";
    locationLab.userInteractionEnabled = YES;
    [locationLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadLocation)]];
    [viewInlandHeader addSubview:locationLab];
    dealY += kPadingY+20;
    //国内热门城市
    UILabel *hotCityLab = [[UILabel alloc]initWithFrame:CGRectMake(kPadingX, CGRectGetMaxY(locationLab.frame)+10, SCREEN_WIDTH-kPadingX*2, 20)];
    hotCityLab.text = isInland?@"国内热门城市":@"海外热门目的地";
    hotCityLab.textColor = [UIColor lightGrayColor];
    [viewInlandHeader addSubview:hotCityLab];
    dealY += 20+10;
    if (self.isOpenLocation) {
        int totalColumns = 3;
        CGFloat cellW = 50;
        CGFloat cellH = 30;
        CGFloat margin =(SCREEN_WIDTH - kPadingX*2 - totalColumns * cellW) / (totalColumns + 1);
        for(int index = 0; index< hotCitys.count; index++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor orangeColor];
            [btn setTitle:hotCitys[index] forState:UIControlStateNormal];
            btn.titleLabel.textColor = [UIColor whiteColor];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.layer.cornerRadius = 10;
            btn.layer.masksToBounds = YES;
            int row = index / totalColumns;
            int col = index % totalColumns;
            CGFloat cellX = kPadingX + col * (cellW + margin);
            CGFloat cellY = kPadingY + row * (cellH + kPadingY);
            btn.frame = CGRectMake(cellX,dealY + cellY, cellW, cellH);
            [viewInlandHeader addSubview:btn];
            if (index==hotCitys.count-1) {
                dealY += CGRectGetMaxY(btn.frame);
            }
        }
    }
    //全部城市
    UILabel *totleLable = [[UILabel alloc]initWithFrame:CGRectMake(kPadingX, dealY-30, SCREEN_WIDTH-kPadingX*2, 20)];
    totleLable.textColor = [UIColor lightGrayColor];
    totleLable.text = @"全部城市";
    [viewInlandHeader addSubview:totleLable];
    //分割线
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(kPadingX, dealY, SCREEN_WIDTH-kPadingX*2, 1)];
    viewLine.backgroundColor = [UIColor whiteColor];
    [viewInlandHeader addSubview:viewLine];
    viewInlandHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, dealY);
    return viewInlandHeader;
}

- (void)setupBottomCloseView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor greenColor];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:closeBtn];
    closeBtn.frame = CGRectMake((SCREEN_WIDTH-40)/2, 0, 40, 40);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismissSelPlaceVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:view];
}

- (void)setupData{
    self.mInlandCitys = [NSMutableArray arrayWithArray:@[@"北京",@"上海",@"深圳",@"广州",@"成都",@"杭州",@"南京"]];
    self.mForeignCitys = [NSMutableArray arrayWithArray:@[@"韩国",@"澳大利亚",@"丹麦",@"泰国",@"马来西亚",@"俄罗斯",@"美国"]];
    [self.tableViewInland reloadData];
    [self.tableViewForeign reloadData];
;
}

#pragma mark 界面按钮事件
- (void)dismissSelPlaceVC{
    
}

- (void)changeData:(UIButton *)sender{
    if (sender.tag==200) {
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollContent.contentOffset = CGPointMake(0, self.scrollContent.contentOffset.y);
            self.animationLab.text = @"国内";
            [self.animationLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.selView.mas_top);
                make.left.equalTo(self.selView.mas_left);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollContent.contentOffset = CGPointMake(SCREEN_WIDTH, self.scrollContent.contentOffset.y);
            self.animationLab.text = @"国外";
            [self.animationLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.selView.mas_top);
                make.left.equalTo(self.selView.mas_left).offset(60);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
        }];
    }
}

//定位失败点击重新刷新位子
- (void)reloadLocation{
    UIcollectionDemo *demo = [[UIcollectionDemo alloc]init];
    [self.navigationController pushViewController:demo animated:YES];
}

#pragma mark tableDateSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableView==self.tableViewInland?self.mInlandCitys.count:self.mForeignCitys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellReuseId = @"cellReuseId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseId];
        cell.backgroundColor = [UIColor clearColor];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(kPadingX, 43, SCREEN_WIDTH-kPadingX*2, 1)];
        line.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:line];
    }
    NSArray *temps = tableView==self.tableViewInland?self.mInlandCitys:self.mForeignCitys;
    cell.textLabel.text = temps[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark tableDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *temps = tableView==self.tableViewInland?self.mInlandCitys:self.mForeignCitys;
    
}

#pragma mark scollDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == self.scrollContent) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSLog(@"%f",scrollView.contentOffset.x);
        if (0<scrollView.contentOffset.x && scrollView.contentOffset.x<pageWidth/2) {
            [UIView animateWithDuration:0.25 animations:^{
                [UIView animateWithDuration:0.25 animations:^{
                    self.animationLab.text = @"国内";
                    [self.animationLab mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.selView.mas_top);
                        make.left.equalTo(self.selView.mas_left);
                        make.size.mas_equalTo(CGSizeMake(60, 30));
                    }];
                }];
               
            }];
        }
        if(pageWidth/2<scrollView.contentOffset.x && scrollView.contentOffset.x<pageWidth<pageWidth){
            self.animationLab.text = @"国外";
            [self.animationLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.selView.mas_top);
                make.left.equalTo(self.selView.mas_left).offset(60);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
