//
//  CustomerDetailViewController.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2018/1/2.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "CustomerDetailViewController.h"
#import "RDFrequentlyUsed.h"
#import "UIImageView+WebCache.h"
#import "CustomerTagView.h"
#import "CustomerPayHistory.h"
#import "CustomDetailInforRequest.h"
#import "UIView+Additional.h"
#import "AddNewRemarkViewController.h"
#import "EditCustomerTagViewController.h"
#import "SAVORXAPI.h"
#import "NSArray+json.h"
#import "upLoadConsumeTickRequest.h"

@interface CustomerDetailViewController ()<UITableViewDelegate,UITableViewDataSource,EditCustomerTagDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIImageView *heardImgView;
@property (nonatomic, strong) CustomerTagView *tagView;
@property (nonatomic, strong) CustomerPayHistory * historyView;
@property (nonatomic, strong) UIView * bottomView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) RDAddressModel *adressModel;

@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *phoneLab;
@property (nonatomic, strong) UILabel *consumeLab;
@property (nonatomic, strong) UILabel *birthdayLab;
@property (nonatomic, strong) UILabel *originLab;
@property (nonatomic, strong) UILabel *remarkContentLab;

@property(nonatomic, assign) BOOL isUploading;
@property (nonatomic, strong) UIImagePickerController * picker;


@end

@implementation CustomerDetailViewController

- (instancetype)initWithDataModel:(RDAddressModel *)model{
    
    if (self = [super init]) {
        self.adressModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfor];
    [self CustomerDataRequest];
    [self creatSubViews];
    
}

- (void)initInfor{
    
    self.title = @"详细资料";
    self.isUploading = NO;
    self.view.backgroundColor = UIColorFromRGB(0xece6de);
    self.dataArray = [NSMutableArray new];
    
}

- (void)creatSubViews{
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    CGFloat tapContentHeight = [RDFrequentlyUsed getHeightByWidth:kMainBoundsWidth - 30 - 40 title:@"标签内容" font:kPingFangRegular(17)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth);
    }];
    
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0,0,kMainBoundsWidth, 360);

    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.font = kPingFangRegular(15);
    titleLab.textColor = UIColorFromRGB(0x922c3e);
    titleLab.text = @"完善客户资料，方便为TA更好的服务";
    titleLab.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 46));
        make.centerX.mas_equalTo(topView);
        make.top.mas_equalTo(0);
    }];
    
    UIView *firstBgView = [[UIView alloc] init];
    firstBgView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    firstBgView.layer.borderColor = UIColorFromRGB(0xdfd9d2).CGColor;
    firstBgView.layer.borderWidth = 0.5f;
    firstBgView.frame = CGRectMake(0,10,kMainBoundsWidth - 20, 340);
    [topView addSubview:firstBgView];
    [firstBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 150));
        make.centerX.mas_equalTo(topView);
        make.top.mas_equalTo(titleLab.mas_bottom);
    }];
    
    self.heardImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.heardImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.heardImgView.layer.masksToBounds = YES;
    self.heardImgView.layer.cornerRadius = 21;
    self.heardImgView.backgroundColor = [UIColor lightGrayColor];
    [firstBgView addSubview:self.heardImgView];
    [self.heardImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(42 *scale);
        make.height.mas_equalTo(42 *scale);
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(10);
    }];
    [self.heardImgView sd_setImageWithURL:[NSURL URLWithString:@"url"] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLab.backgroundColor = [UIColor clearColor];
    self.nameLab.font = kPingFangRegular(16);
    self.nameLab.textColor = UIColorFromRGB(0x222222);
    self.nameLab.text = @"客户名字";
    self.nameLab.textAlignment = NSTextAlignmentLeft;
    [firstBgView addSubview:self.nameLab];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 20));
        make.left.mas_equalTo(self.heardImgView.mas_right).offset(10);
        make.top.mas_equalTo(self.heardImgView);
    }];
    
    self.phoneLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.phoneLab.backgroundColor = [UIColor clearColor];
    self.phoneLab.font = kPingFangRegular(14);
    self.phoneLab.textColor = UIColorFromRGB(0x666666);
    self.phoneLab.text = @"18510378890";
    self.phoneLab.textAlignment = NSTextAlignmentLeft;
    [firstBgView addSubview:self.phoneLab];
    [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(self.heardImgView.mas_right).offset(10);
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(5);
    }];
    
    self.consumeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.consumeLab.backgroundColor = [UIColor clearColor];
    self.consumeLab.font = kPingFangRegular(14);
    self.consumeLab.textColor = UIColorFromRGB(0x666666);
    self.consumeLab.text = @"人均消费能力：1000";
    self.consumeLab.textAlignment = NSTextAlignmentLeft;
    [firstBgView addSubview:self.consumeLab];
    [self.consumeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 20));
        make.left.mas_equalTo(self.heardImgView.mas_right).offset(10);
        make.top.mas_equalTo(self.phoneLab.mas_bottom).offset(5);
    }];
    
    self.birthdayLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.birthdayLab.backgroundColor = [UIColor clearColor];
    self.birthdayLab.font = kPingFangRegular(14);
    self.birthdayLab.textColor = UIColorFromRGB(0x666666);
    self.birthdayLab.text = @"生日：8月23日";
    self.birthdayLab.textAlignment = NSTextAlignmentLeft;
    [firstBgView addSubview:self.birthdayLab];
    [self.birthdayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(self.heardImgView.mas_right).offset(10);
        make.top.mas_equalTo(self.consumeLab.mas_bottom).offset(5);
    }];
    
    self.originLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.originLab.backgroundColor = [UIColor clearColor];
    self.originLab.font = kPingFangRegular(14);
    self.originLab.textColor = UIColorFromRGB(0x666666);
    self.originLab.text = @"籍贯：北京";
    self.originLab.textAlignment = NSTextAlignmentLeft;
    [firstBgView addSubview:self.originLab];
    [self.originLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(self.heardImgView.mas_right).offset(10);
        make.top.mas_equalTo(self.birthdayLab.mas_bottom).offset(5);
    }];
    
    UIButton * doPefectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doPefectBtn.backgroundColor = [UIColor clearColor];
    [doPefectBtn setTitle:@"去完善" forState:UIControlStateNormal];
    doPefectBtn.titleLabel.font = kPingFangRegular(13);
    [doPefectBtn setTitleColor:UIColorFromRGB(0x922c3e) forState:UIControlStateNormal];
    doPefectBtn.layer.borderColor = UIColorFromRGB(0x922c3e).CGColor;
    doPefectBtn.layer.borderWidth = 0.5f;
    doPefectBtn.layer.cornerRadius = 2.f;
    doPefectBtn.layer.masksToBounds = YES;
    [doPefectBtn addTarget:self action:@selector(doPefectClicked) forControlEvents:UIControlEventTouchUpInside];
    [firstBgView addSubview:doPefectBtn];
    [doPefectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLab.mas_top);
        make.right.mas_equalTo(firstBgView.mas_right).offset(- 15);
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(22);
    }];
    
    UIView *secondBgView = [[UIView alloc] init];
    secondBgView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    secondBgView.layer.borderColor = UIColorFromRGB(0xdfd9d2).CGColor;
    secondBgView.layer.borderWidth = 0.5f;
    secondBgView.frame = CGRectMake(0,10,kMainBoundsWidth - 20, 340);
    [topView addSubview:secondBgView];
    [secondBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 100));
        make.centerX.mas_equalTo(topView);
        make.top.mas_equalTo(firstBgView.mas_bottom).offset(10);
    }];
    
    UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tagLabel.backgroundColor = [UIColor clearColor];
    tagLabel.font = kPingFangRegular(16);
    tagLabel.textColor = UIColorFromRGB(0x222222);
    tagLabel.text = @"标签";
    tagLabel.textAlignment = NSTextAlignmentLeft;
    [secondBgView addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 20));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    
    UIButton * editTagButton = [Helper buttonWithTitleColor:kAPPMainColor font:kPingFangRegular(13) backgroundColor:[UIColor clearColor] title:@"编辑" cornerRadius:2.f];
    [editTagButton addTarget:self action:@selector(editButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    editTagButton.layer.borderColor = kAPPMainColor.CGColor;
    editTagButton.layer.borderWidth = .5f;
    [secondBgView addSubview:editTagButton];
    [editTagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tagLabel.mas_top);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(40);
    }];
    
    NSMutableArray *tapArray = [NSMutableArray new];
    for (int i = 0; i < 6; i ++) {
        NSString *value = [NSString stringWithFormat:@"标签%i",i];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:value,@"label_name", nil];
        [tapArray addObject:dic];
        
    }
    self.tagView = [[CustomerTagView alloc] initWithFrame:CGRectMake(0, 190 * scale, kMainBoundsWidth, 40 * scale)];
    [self.tagView reloadTagSource:tapArray];
    CGFloat tagTotalHeight = 30;
    CGFloat tagViewHeight = self.tagView.frame.size.height + 10;
    tagTotalHeight = tagTotalHeight + tagViewHeight;
    [secondBgView addSubview:self.tagView];
    [self.tagView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tagLabel.mas_bottom);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(tagViewHeight);
        make.width.mas_equalTo(kMainBoundsWidth - 30);
    }];
    
    [secondBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(tagTotalHeight);
    }];
    
    
    UIView *thirdBgView = [[UIView alloc] init];
    thirdBgView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    thirdBgView.layer.borderColor = UIColorFromRGB(0xdfd9d2).CGColor;
    thirdBgView.layer.borderWidth = 0.5f;
    [topView addSubview:thirdBgView];
    [thirdBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 100));
        make.centerX.mas_equalTo(topView);
        make.top.mas_equalTo(secondBgView.mas_bottom).offset(10);
    }];
    
    UILabel *remarkLab = [[UILabel alloc] initWithFrame:CGRectZero];
    remarkLab.backgroundColor = [UIColor clearColor];
    remarkLab.font = kPingFangRegular(16);
    remarkLab.textColor = UIColorFromRGB(0x222222);
    remarkLab.text = @"备注";
    remarkLab.textAlignment = NSTextAlignmentLeft;
    [thirdBgView addSubview:remarkLab];
    [remarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 20));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    
    self.remarkContentLab = [Helper labelWithFrame:CGRectZero TextColor:[UIColor grayColor] font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentLeft];
    self.remarkContentLab.text = @"请记录客户其他信息";
    [thirdBgView addSubview:self.remarkContentLab];
    [self.remarkContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 30, 20));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(remarkLab.mas_bottom).offset(15);
    }];
   
    UIButton * editRemarkButton = [Helper buttonWithTitleColor:kAPPMainColor font:kPingFangRegular(13) backgroundColor:[UIColor clearColor] title:@"编辑" cornerRadius:2.f];
    [editRemarkButton addTarget:self action:@selector(editRemarkClicked) forControlEvents:UIControlEventTouchUpInside];
    editRemarkButton.layer.borderColor = kAPPMainColor.CGColor;
    editRemarkButton.layer.borderWidth = .5f;
    [thirdBgView addSubview:editRemarkButton];
    [editRemarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(remarkLab.mas_top);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(40);
    }];
    
    topView.frame = CGRectMake(0,0,kMainBoundsWidth, 46 + 20 + 100 + 150 + tagTotalHeight);
    
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 40 * scale)];
    self.bottomView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    
    UILabel * historyLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x222222) font:kPingFangRegular(16) alignment:NSTextAlignmentLeft];
    [self.bottomView addSubview:historyLabel];
    historyLabel.text = @"消费记录";
    [historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(80 *scale, 20));
    }];
    
    UIButton * historyButton = [Helper buttonWithTitleColor:kAPPMainColor font:kPingFangRegular(13) backgroundColor:[UIColor clearColor] title:@"添加" cornerRadius:2.f];
    historyButton.layer.borderColor = kAPPMainColor.CGColor;
    historyButton.layer.borderWidth = .5f;
    [historyButton addTarget:self action:@selector(addTicketImgDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:historyButton];
    [historyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(historyLabel.mas_top);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(40);
    }];
    
    self.historyView = [[CustomerPayHistory alloc] initWithFrame:CGRectMake(0, 40 * scale, kMainBoundsWidth, 40 * scale)];
    CGRect rect = self.bottomView.frame;
    rect.size.height = rect.size.height + self.historyView.frame.size.height + 10 * scale;
    self.bottomView.frame = rect;
    [self.bottomView addSubview:self.historyView];
    
    [self.historyView addImageWithImage:[UIImage imageNamed:@"tjcre"]];
    [self.historyView addImageWithImage:[UIImage imageNamed:@"tjcre"]];
    [self.historyView addImageWithImage:[UIImage imageNamed:@"tjcre"]];
    rect.size.height = rect.size.height + self.historyView.frame.size.height + 10 * scale;
    self.bottomView.frame = rect;
    
    self.tableView.tableHeaderView = topView;
    self.tableView.tableFooterView = self.bottomView;
    
}

- (void)editButtonDidClicked{
    
    EditCustomerTagViewController *etVC = [[EditCustomerTagViewController alloc] initWithModel:self.adressModel];
    etVC.delegate = self;
    [self.navigationController pushViewController:etVC animated:YES];
    
}

- (void)editRemarkClicked{
    
    AddNewRemarkViewController *anVC = [[AddNewRemarkViewController alloc] initWithCustomerId:@""];
    [self.navigationController pushViewController:anVC animated:YES];
    
}

- (void)addTicketImgDidClicked{
    
    //避免多次点击
    if (self.isUploading == NO) {
        [self consumeButtonDidClicked];
    }
    
}

- (void)customerTagDidUpdateWithLightData:(NSArray *)dataSource lightID:(NSArray *)idArray{
    
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
    cell.backgroundColor = UIColorFromRGB(0xece6de);
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}

- (void)CustomerDataRequest{
    
    [self.dataArray removeAllObjects];
    [MBProgressHUD showLoadingWithText:@"" inView:self.view];
    
    NSDictionary *parmDic = @{
                              @"invite_id":[GlobalData shared].userModel.invite_id,
                              @"mobile":[GlobalData shared].userModel.telNumber,
                              @"customer_id":self.adressModel.customer_id == nil ?@"":self.adressModel.customer_id
                              };
    CustomDetailInforRequest * request = [[CustomDetailInforRequest alloc] initWithParamData:parmDic];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *resultDic = [response objectForKey:@"result"];
        NSDictionary *listDic = resultDic[@"list"];
        NSArray *labelArray = listDic[@"label"];
        [self.dataArray addObjectsFromArray:labelArray];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }else{
            [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        
    }];
}

#pragma mark - 上传消费记录信息
- (void)upLoadConsumeTicket:(UIImage *)ticImg;
{
    self.isUploading = YES;
    MBProgressHUD * hud = [MBProgressHUD showLoadingWithText:@"正在加载" inView:self.view];
    [SAVORXAPI uploadComsumeImage:ticImg withImageName:[NSString stringWithFormat:@"%@_%@", [GlobalData shared].userModel.telNumber, [Helper getCurrentTimeWithFormat:@"yyyyMMddHHmmss"]] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        
    } success:^(NSString *path) {
        
        [hud hideAnimated:YES];
        [self upateConsumeTicketRequest:path];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showTextHUDwithTitle:@"小票上传失败"];
        [hud hideAnimated:YES];
        self.isUploading = NO;
    }];
}

#pragma mark - 请求功能消费小票接口
- (void)upateConsumeTicketRequest:(NSString *)imgUrl{
    
    NSArray *ticktesArray = [NSArray arrayWithObjects:imgUrl,nil];
    NSString *ticketStr = [ticktesArray toJSONString];
    
    NSDictionary *parmDic = @{
                              @"invite_id":[GlobalData shared].userModel.invite_id,
                              @"mobile":[GlobalData shared].userModel.telNumber,
                              @"order_id":@"",
                              @"customer_id":@"",
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
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
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
