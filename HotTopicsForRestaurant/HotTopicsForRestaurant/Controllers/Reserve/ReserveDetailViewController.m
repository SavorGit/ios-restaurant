//
//  ReserveDetailViewController.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ReserveDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "UpdateReInforRequest.h"
#import "DeleteReserveRequest.h"
#import "AddNewReserveViewController.h"
#import "SAVORXAPI.h"
#import "NSArray+json.h"
#import "upLoadConsumeTickRequest.h"
#import "RDFrequentlyUsed.h"

@interface ReserveDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property(nonatomic, strong) ReserveModel *dataModel;

@property(nonatomic, strong) UILabel *roomTitleLab;
@property(nonatomic, strong) UILabel *reserTimeLab;
@property(nonatomic, strong) UILabel *peopleNumLab;
@property(nonatomic, strong) UILabel *remarkLab;
@property(nonatomic, strong) UILabel *remarkConetentLab;
//
@property(nonatomic, strong) UIImageView *heardImgView;
@property(nonatomic, strong) UILabel *nameLab;
@property(nonatomic, strong) UILabel *phoneLab;

@property(nonatomic, assign) BOOL isUploading;

@property (nonatomic, strong) UIImagePickerController * picker;


@end

@implementation ReserveDetailViewController

- (instancetype)initWithDataModel:(ReserveModel *)model
{
    if (self = [super init]) {
        self.dataModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfor];
    [self creatSubViews];

}

- (void)initInfor{
    
    self.title = @"预定信息";
    self.isUploading = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
}
- (void)creatSubViews{
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    CGFloat remarkHeight = [RDFrequentlyUsed getHeightByWidth:kMainBoundsWidth - 30 - 40 title:self.dataModel.remark font:[UIFont systemFontOfSize:15]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(kMainBoundsWidth - 20);
    }];
    
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0,0,kMainBoundsWidth - 20, 360 + remarkHeight *scale);
    
    UIView *topBgView = [[UIView alloc] init];
    topBgView.backgroundColor = UIColorFromRGB(0xeee8e0);
    topBgView.frame = CGRectMake(0,20,kMainBoundsWidth - 20, 340 + remarkHeight *scale);
    [topView addSubview:topBgView];

    self.roomTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.roomTitleLab.backgroundColor = [UIColor clearColor];
    self.roomTitleLab.font = [UIFont systemFontOfSize:15];
    self.roomTitleLab.textColor = [UIColor grayColor];
    self.roomTitleLab.text = self.dataModel.room_name;
    self.roomTitleLab.textAlignment = NSTextAlignmentCenter;
    [topBgView addSubview:self.roomTitleLab];
    [self.roomTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 30), 25 *scale));
        make.centerX.mas_equalTo(topBgView);
        make.top.mas_equalTo(15);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor blackColor];
    [topBgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 20), 1));
        make.centerX.mas_equalTo(topBgView);
        make.top.mas_equalTo(self.roomTitleLab.mas_bottom).offset(14);
    }];
    
    self.reserTimeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.reserTimeLab.backgroundColor = [UIColor clearColor];
    self.reserTimeLab.font = [UIFont systemFontOfSize:15];
    self.reserTimeLab.textColor = [UIColor grayColor];
    self.reserTimeLab.text = [NSString stringWithFormat:@"预定时间：%@ %@",self.dataModel.time_str, self.dataModel.moment_str];
    self.reserTimeLab.textAlignment = NSTextAlignmentLeft;
    [topBgView addSubview:self.reserTimeLab];
    [self.reserTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 30), 25 *scale));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(lineView.mas_bottom).offset(15);
    }];
    
    self.peopleNumLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.peopleNumLab.backgroundColor = [UIColor clearColor];
    self.peopleNumLab.font = [UIFont systemFontOfSize:15];
    self.peopleNumLab.textColor = [UIColor grayColor];
    self.peopleNumLab.text = [NSString stringWithFormat:@"就餐人数：%@",self.dataModel.person_nums];
    self.peopleNumLab.textAlignment = NSTextAlignmentLeft;
    [topBgView addSubview:self.peopleNumLab];
    [self.peopleNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 30), 25 *scale));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.reserTimeLab.mas_bottom).offset(10);
    }];
    
    self.remarkLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.remarkLab.backgroundColor = [UIColor clearColor];
    self.remarkLab.font = [UIFont systemFontOfSize:15];
    self.remarkLab.textColor = [UIColor grayColor];
    self.remarkLab.text = @"备注:";
    self.remarkLab.textAlignment = NSTextAlignmentLeft;
    [topBgView addSubview:self.remarkLab];
    [self.remarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 18 *scale));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.peopleNumLab.mas_bottom).offset(10);
    }];
    
    self.remarkConetentLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.remarkConetentLab.backgroundColor = [UIColor clearColor];
    self.remarkConetentLab.font = [UIFont systemFontOfSize:15];
    self.remarkConetentLab.textColor = [UIColor grayColor];
    self.remarkConetentLab.text = self.dataModel.remark;
    self.remarkConetentLab.textAlignment = NSTextAlignmentLeft;
    self.remarkConetentLab.numberOfLines = 0;
    [topBgView addSubview:self.remarkConetentLab];
    [self.remarkConetentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 30 - 40, remarkHeight *scale));
        make.left.mas_equalTo(self.remarkLab.mas_right);
        make.top.mas_equalTo(self.peopleNumLab.mas_bottom).offset(10);
    }];
    
    UIView *cuBgView = [[UIView alloc] init];
    cuBgView.backgroundColor = [UIColor whiteColor];
    cuBgView.layer.borderWidth = .5f;
    cuBgView.layer.cornerRadius = 4.f;
    cuBgView.layer.masksToBounds = YES;
    cuBgView.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    [topBgView addSubview:cuBgView];
    [cuBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 30 - 20) , 80 *scale));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.remarkConetentLab.mas_bottom).offset(20);
    }];
    
    self.heardImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.heardImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.heardImgView.layer.masksToBounds = YES;
    self.heardImgView.layer.cornerRadius = 25 *scale;
    self.heardImgView.backgroundColor = [UIColor cyanColor];
    [cuBgView addSubview:self.heardImgView];
    [self.heardImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50 *scale);
        make.height.mas_equalTo(50 *scale);
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(10);
    }];
    [self.heardImgView sd_setImageWithURL:[NSURL URLWithString:self.dataModel.face_url] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLab.backgroundColor = [UIColor clearColor];
    self.nameLab.font = [UIFont systemFontOfSize:15];
    self.nameLab.textColor = [UIColor grayColor];
    self.nameLab.text = self.dataModel.order_name;
    self.nameLab.textAlignment = NSTextAlignmentLeft;
    [cuBgView addSubview:self.nameLab];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 25));
        make.left.mas_equalTo(self.heardImgView.mas_right).offset(10);
        make.top.mas_equalTo(self.heardImgView.mas_top).offset(2);
    }];
    
    self.phoneLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.phoneLab.backgroundColor = [UIColor clearColor];
    self.phoneLab.font = [UIFont systemFontOfSize:15];
    self.phoneLab.textColor = [UIColor grayColor];
    self.phoneLab.text = self.dataModel.order_mobile;
    self.phoneLab.textAlignment = NSTextAlignmentLeft;
    [cuBgView addSubview:self.phoneLab];
    [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 25));
        make.left.mas_equalTo(self.heardImgView.mas_right).offset(10);
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(2);
    }];
    
    UIImageView *rightImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    rightImgView.contentMode = UIViewContentModeScaleAspectFill;
    rightImgView.layer.masksToBounds = YES;
    rightImgView.backgroundColor = [UIColor cyanColor];
    [cuBgView addSubview:rightImgView];
    [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20 *scale);
        make.height.mas_equalTo(20 *scale);
        make.centerY.mas_equalTo(cuBgView);
        make.right.mas_equalTo(- 30);
    }];
    
    UILabel *lookfileLab = [[UILabel alloc] initWithFrame:CGRectZero];
    lookfileLab.backgroundColor = [UIColor clearColor];
    lookfileLab.font = [UIFont systemFontOfSize:14];
    lookfileLab.textColor = [UIColor lightGrayColor];
    lookfileLab.text = @"查看资料";
    lookfileLab.textAlignment = NSTextAlignmentLeft;
    [cuBgView addSubview:lookfileLab];
    [lookfileLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60 *scale);
        make.height.mas_equalTo(20 *scale);
        make.centerY.mas_equalTo(cuBgView);
        make.right.mas_equalTo(rightImgView.mas_left);
    }];
    
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.backgroundColor = [UIColor clearColor];
    deleteBtn.titleLabel.textColor = [UIColor whiteColor];
    [deleteBtn setTitle:@"删除预定" forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    deleteBtn.layer.borderColor = [UIColor redColor].CGColor;
    deleteBtn.layer.borderWidth = 1.f;
    deleteBtn.layer.cornerRadius = 5.f;
    deleteBtn.layer.masksToBounds = YES;
    [deleteBtn addTarget:self action:@selector(deleteClicked) forControlEvents:UIControlEventTouchUpInside];
    [topBgView addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cuBgView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(topBgView.mas_centerX).offset(- 80);
        make.width.mas_equalTo(80 *scale);
        make.height.mas_equalTo(35 *scale);
    }];
    
    UIButton * modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    modifyBtn.backgroundColor = [UIColor clearColor];
    modifyBtn.titleLabel.textColor = [UIColor whiteColor];
    [modifyBtn setTitle:@"修改预定" forState:UIControlStateNormal];
    modifyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [modifyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    modifyBtn.layer.borderColor = [UIColor redColor].CGColor;
    modifyBtn.layer.borderWidth = 1.f;
    modifyBtn.layer.cornerRadius = 5.f;
    modifyBtn.layer.masksToBounds = YES;
    [modifyBtn addTarget:self action:@selector(modifyClicked) forControlEvents:UIControlEventTouchUpInside];
    [topBgView addSubview:modifyBtn];
    [modifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cuBgView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(topBgView.mas_centerX).offset(80);
        make.width.mas_equalTo(80 *scale);
        make.height.mas_equalTo(35 *scale);
    }];
    
    self.tableView.tableHeaderView = topView;
    [self creatBottomView];
    
}

- (void) creatBottomView{
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView *bottomBgView = [[UIView alloc] init];
    bottomBgView.backgroundColor = UIColorFromRGB(0xeee8e0);
    bottomBgView.frame = CGRectMake(0,0, kMainBoundsWidth, 240);
    
    self.roomTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.roomTitleLab.backgroundColor = [UIColor clearColor];
    self.roomTitleLab.font = [UIFont systemFontOfSize:15];
    self.roomTitleLab.textColor = [UIColor grayColor];
    self.roomTitleLab.text = @"功能/服务";
    self.roomTitleLab.textAlignment = NSTextAlignmentCenter;
    [bottomBgView addSubview:self.roomTitleLab];
    [self.roomTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 30), 25 *scale));
        make.centerX.mas_equalTo(bottomBgView);
        make.top.mas_equalTo(15 *scale);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor blackColor];
    [bottomBgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 20), 1));
        make.centerX.mas_equalTo(bottomBgView);
        make.top.mas_equalTo(self.roomTitleLab.mas_bottom).offset(14 *scale);
    }];
    

    NSArray *imgNameArray = [NSArray arrayWithObjects:@"zhyc",@"tjcre",@"pxp", nil];
    NSArray *subTitleArray = [NSArray arrayWithObjects:@"致欢迎词",@"推荐特色菜",@"上传小票照片", nil];
    CGFloat distance = (kMainBoundsWidth - 20 - 45 *3)/6;
    CGFloat titleDistance = (kMainBoundsWidth - 20 - 80 *3)/6;
    CGFloat idenDistance = (kMainBoundsWidth - 20 - 45 *3)/6;
    for (int i = 0; i < subTitleArray.count; i ++) {
        
        UIImageView *tmpImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        tmpImgView.contentMode = UIViewContentModeScaleAspectFill;
        tmpImgView.userInteractionEnabled = YES;
        tmpImgView.layer.masksToBounds = YES;
        tmpImgView.image = [UIImage imageNamed:imgNameArray[i]];
        tmpImgView.tag = 10000 + i;
        [bottomBgView addSubview:tmpImgView];
        [tmpImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(45 *scale);
            make.height.mas_equalTo(45 *scale);
            make.top.mas_equalTo(lineView.mas_bottom).offset(20 *scale);
            make.left.mas_equalTo(distance + i *(45 + distance *2));
        }];
        
        UILabel *subTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        subTitleLab.backgroundColor = [UIColor clearColor];
        subTitleLab.font = [UIFont systemFontOfSize:14];
        subTitleLab.textColor = [UIColor grayColor];
        subTitleLab.text = subTitleArray[i];
        subTitleLab.textAlignment = NSTextAlignmentCenter;
        [bottomBgView addSubview:subTitleLab];
        [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80 *scale);
            make.height.mas_equalTo(25 *scale);
            make.top.mas_equalTo(tmpImgView.mas_bottom).offset(5 *scale);
            make.left.mas_equalTo(titleDistance + i *(80 + titleDistance *2));
        }];
        
        UILabel *idenLab = [[UILabel alloc] initWithFrame:CGRectZero];
        idenLab.backgroundColor = [UIColor clearColor];
        idenLab.font = [UIFont systemFontOfSize:14];
        idenLab.textColor = [UIColor blueColor];
        idenLab.layer.borderWidth = .5f;
        idenLab.layer.cornerRadius = 4.f;
        idenLab.layer.masksToBounds = YES;
        idenLab.layer.borderColor = [UIColor blueColor].CGColor;
        idenLab.text = @"已完成";
        idenLab.textAlignment = NSTextAlignmentCenter;
        [bottomBgView addSubview:idenLab];
        [idenLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(45 *scale);
            make.height.mas_equalTo(20 *scale);
            make.top.mas_equalTo(subTitleLab.mas_bottom).offset(5 *scale);
            make.left.mas_equalTo(idenDistance + i *(45 + idenDistance *2));
        }];
        if (i == 0) {
            if (self.dataModel.is_recfood == 1) {
                idenLab.text = @"已完成";
            }else{
                idenLab.text = @"未完成";
                idenLab.textColor = [UIColor redColor];
                idenLab.layer.borderColor = [UIColor redColor].CGColor;
            }
        }else if (i == 1){
            if (self.dataModel.is_welcome == 1) {
                idenLab.text = @"已完成";
            }else{
                idenLab.text = @"未完成";
                idenLab.textColor = [UIColor redColor];
                idenLab.layer.borderColor = [UIColor redColor].CGColor;
            }
        }else if (i == 2){
            if (self.dataModel.is_expense == 1) {
                idenLab.text = @"已完成";
            }else{
                idenLab.text = @"未完成";
                idenLab.textColor = [UIColor redColor];
                idenLab.layer.borderColor = [UIColor redColor].CGColor;
            }
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(funClick:)];
        tap.numberOfTapsRequired = 1;
        [tmpImgView addGestureRecognizer:tap];
    }
    
    self.tableView.tableFooterView = bottomBgView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"UITableViewCell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}

#pragma mark - 删除
- (void)deleteClicked{
    
    [self deleteReserveRequest];
}

#pragma mark - 修改
- (void)modifyClicked{
    
    AddNewReserveViewController *arVC = [[AddNewReserveViewController alloc] initWithDataModel:self.dataModel andType:NO];
    [self.navigationController pushViewController:arVC animated:YES];
}

- (void)funClick:(UITapGestureRecognizer *)tapGesture{
    
    NSInteger tmpTag =  tapGesture.view.tag;
    if (tmpTag == 10000) {
        [self upateOrderRequest:@"1" andImgUrl:@""];
    }else if (tmpTag == 10001){
        [self upateOrderRequest:@"2" andImgUrl:@""];
    }else if (tmpTag == 10002){
        //避免多次点击
        if (self.isUploading == NO) {
             [self consumeButtonDidClicked];
        }
    }
}

#pragma mark - 请求功能服务
- (void)upateOrderRequest:(NSString *)type andImgUrl:(NSString *)imgUrl{
    
    NSDictionary *parmDic = @{
                              @"invite_id":[GlobalData shared].userModel.invite_id,
                              @"mobile":[GlobalData shared].userModel.telNumber,
                              @"order_id":self.dataModel.order_id,
                              @"type":type,
                              @"ticket_url":imgUrl,
                              };
    
    UpdateReInforRequest * request = [[UpdateReInforRequest alloc]  initWithPubData:parmDic];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        self.isUploading = NO;
        if ([[response objectForKey:@"code"] integerValue] == 10000) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        self.isUploading = NO;
        if ([response objectForKey:@"msg"]) {
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        self.isUploading = NO;
    }];
    
}

#pragma mark - 请求功能消费小票接口
- (void)upateConsumeTicketRequest:(NSString *)imgUrl{
    
    NSArray *ticktesArray = [NSArray arrayWithObjects:@"http:devp.oss.littlehotspot.com/20171227193659.jpg", @"http:devp.oss.littlehotspot.com/2017122.jpg",@"http:devp.oss.littlehotspot.com/59.jpg",nil];
    NSString *ticketStr = [ticktesArray toJSONString];
    
    NSDictionary *parmDic = @{
                              @"invite_id":[GlobalData shared].userModel.invite_id,
                              @"mobile":[GlobalData shared].userModel.telNumber,
                              @"order_id":self.dataModel.order_id,
                              @"customer_id":self.dataModel.customer_id,
                              @"recipt":ticketStr,
                              };
    
    upLoadConsumeTickRequest * request = [[upLoadConsumeTickRequest alloc]  initWithPubData:parmDic];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        self.isUploading = NO;
        if ([[response objectForKey:@"code"] integerValue] == 10000) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        self.isUploading = NO;
        if ([response objectForKey:@"msg"]) {
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        self.isUploading = NO;
    }];
    
}

#pragma mark - 删除预定信息
- (void)deleteReserveRequest{
    
    NSDictionary *parmDic = @{
                              @"invite_id":[GlobalData shared].userModel.invite_id,
                              @"mobile":[GlobalData shared].userModel.telNumber,
                              @"order_id":self.dataModel.order_id
                              };
    
    DeleteReserveRequest * request = [[DeleteReserveRequest alloc]  initWithPubData:parmDic];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if ([[response objectForKey:@"code"] integerValue] == 10000) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        if ([response objectForKey:@"msg"]) {
        }
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
    
}

#pragma mark - 上传消费记录信息
- (void)upLoadConsumeTicket:(UIImage *)ticImg;
{
    self.isUploading = YES;
    MBProgressHUD * hud = [MBProgressHUD showLoadingWithText:@"正在加载" inView:self.view];
    [SAVORXAPI uploadComsumeImage:ticImg withImageName:[NSString stringWithFormat:@"%@", [Helper getCurrentTimeWithFormat:@"yyyyMMddHHmmss"]] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        
    } success:^(NSString *path) {
        
        [hud hideAnimated:YES];
        [self upateConsumeTicketRequest:path];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showTextHUDwithTitle:@"小票上传失败"];
        [hud hideAnimated:YES];
         self.isUploading = NO;
    }];
}


- (void)consumeButtonDidClicked
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请选择获取方式" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.picker.allowsEditing = YES;
        self.picker.delegate = self;
        [self presentViewController:self.picker animated:YES completion:nil];
    }];
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.allowsEditing = YES;
        self.picker.delegate = self;
        [self presentViewController:self.picker animated:YES completion:nil];
    }];
    [alert addAction:cancleAction];
    [alert addAction:photoAction];
    [alert addAction:cameraAction];
    [self presentViewController:alert animated:YES completion:nil];
}

// 选择图片成功调用此方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *tmpImg = [info objectForKey:UIImagePickerControllerEditedImage];
    [self upLoadConsumeTicket:tmpImg];

}

// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
