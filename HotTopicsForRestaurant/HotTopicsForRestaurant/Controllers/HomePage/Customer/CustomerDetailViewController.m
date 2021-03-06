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
#import "AddNewCustomerController.h"
#import "AddPayHistoryRequest.h"
#import "GetConsumRecordRequest.h"
#import "AddCustomerRequest.h"
#import "NSArray+json.h"
#import "LookImageViewController.h"

#import "MJRefresh.h"

@interface CustomerDetailViewController ()<UITableViewDelegate,UITableViewDataSource,EditCustomerTagDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CustomerPayHistoryDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIImageView *heardImgView;
@property (nonatomic, strong) UIImageView *sexImgView;
@property (nonatomic, strong) CustomerTagView *tagView;
@property (nonatomic, strong) CustomerPayHistory * historyView;
@property (nonatomic, strong) UIView * bottomView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) RDAddressModel *adressModel;
@property (nonatomic, strong) RDAddressModel *netAddressModel;

@property (nonatomic, strong) NSArray *consumListArray; //消费记录数据
@property (nonatomic, copy)   NSString *minId; //消费记录上拉ID
@property (nonatomic, strong) NSString *currectTickUrl;

@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *phoneLab;
@property (nonatomic, strong) UILabel *consumeLab;
@property (nonatomic, strong) UILabel *birthdayLab;
@property (nonatomic, strong) UILabel *originLab;
@property (nonatomic, strong) UILabel *tickInforLab;
@property (nonatomic, strong) UILabel *remarkContentLab;

@property(nonatomic, assign) BOOL isUploading;
@property (nonatomic, strong) UIImagePickerController * picker;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *firstBgView;
@property (nonatomic, strong) UIView *secondBgView;
@property (nonatomic, strong) UIView *thirdBgView;
@property (nonatomic, assign) BOOL  isRequest;

@end

@implementation CustomerDetailViewController

- (instancetype)initWithDataModel:(RDAddressModel *)model{
    
    if (self = [super init]) {
        self.adressModel = model;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isRequest == YES) {
        [self CustomerDataRequest];
    }else{
        self.isRequest = YES;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfor];
    [self getConsumRecordRequest:1];
    [self creatSubViews];
    
}

- (void)initInfor{
    
    self.title = @"详细资料";
    self.isUploading = NO;
    self.isRequest = YES;
    self.view.backgroundColor = UIColorFromRGB(0xece6de);
    self.dataArray = [NSMutableArray new];
    
}

#pragma mark - 底部刷新
- (void)footerRefresh{
    [self.tableView.mj_footer endRefreshing];
    [self getConsumRecordRequest:2];
}

- (void)creatSubViews{
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
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
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self footerRefresh];
    }];
    
    AdjustsScrollViewInsetNever(self, self.tableView);
    
    self.topView = [[UIView alloc] init];
    self.topView.frame = CGRectMake(0,0,kMainBoundsWidth, 360 + 22);

    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.font = kPingFangRegular(15);
    titleLab.textColor = UIColorFromRGB(0x922c3e);
    titleLab.text = @"完善客户资料，方便为TA更好的服务";
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 46));
        make.centerX.mas_equalTo(self.topView);
        make.top.mas_equalTo(0);
    }];
    
    self.firstBgView = [[UIView alloc] init];
    self.firstBgView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    self.firstBgView.layer.borderColor = UIColorFromRGB(0xdfd9d2).CGColor;
    self.firstBgView.layer.borderWidth = 0.5f;
    self.firstBgView.frame = CGRectMake(0,10,kMainBoundsWidth - 20, 340 + 22);
    [self.topView addSubview:self.firstBgView];
    [self.firstBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 145 + 22));
        make.centerX.mas_equalTo(self.topView);
        make.top.mas_equalTo(titleLab.mas_bottom);
    }];
    
    self.heardImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.heardImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.heardImgView.layer.masksToBounds = YES;
    self.heardImgView.layer.cornerRadius = 25 *scale;
    self.heardImgView.backgroundColor = [UIColor clearColor];
    [self.firstBgView addSubview:self.heardImgView];
    [self.heardImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50 *scale);
        make.height.mas_equalTo(50 *scale);
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(10);
    }];
    
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLab.backgroundColor = [UIColor clearColor];
    self.nameLab.font = kPingFangRegular(16);
    self.nameLab.textColor = UIColorFromRGB(0x222222);
    self.nameLab.text = @"";
    self.nameLab.textAlignment = NSTextAlignmentLeft;
    [self.firstBgView addSubview:self.nameLab];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 18));
        make.left.mas_equalTo(self.heardImgView.mas_right).offset(10);
        make.top.mas_equalTo(self.heardImgView);
    }];
    
    self.sexImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.sexImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.sexImgView.backgroundColor = [UIColor clearColor];
    [self.firstBgView addSubview:self.sexImgView];
    [self.sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(13);
        make.top.mas_equalTo(self.heardImgView).offset(2.5);
        make.left.mas_equalTo(self.nameLab.mas_right).offset(5);
    }];
    
    self.phoneLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.phoneLab.backgroundColor = [UIColor clearColor];
    self.phoneLab.font = kPingFangRegular(14);
    self.phoneLab.textColor = UIColorFromRGB(0x666666);
    self.phoneLab.text = @"";
    self.phoneLab.textAlignment = NSTextAlignmentLeft;
    [self.firstBgView addSubview:self.phoneLab];
    [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 42 - 30 - 10 - 67, 18));
        make.left.mas_equalTo(self.heardImgView.mas_right).offset(10);
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(5);
    }];
    
    self.consumeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.consumeLab.backgroundColor = [UIColor clearColor];
    self.consumeLab.font = kPingFangRegular(14);
    self.consumeLab.textColor = UIColorFromRGB(0x666666);
    self.consumeLab.text = @"";
    self.consumeLab.textAlignment = NSTextAlignmentLeft;
    [self.firstBgView addSubview:self.consumeLab];
    [self.consumeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 42 - 30 - 10 - 67, 18));
        make.left.mas_equalTo(self.heardImgView.mas_right).offset(10);
        make.top.mas_equalTo(self.phoneLab.mas_bottom).offset(4);
    }];
    
    self.birthdayLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.birthdayLab.backgroundColor = [UIColor clearColor];
    self.birthdayLab.font = kPingFangRegular(14);
    self.birthdayLab.textColor = UIColorFromRGB(0x666666);
    self.birthdayLab.text = @"";
    self.birthdayLab.textAlignment = NSTextAlignmentLeft;
    [self.firstBgView addSubview:self.birthdayLab];
    [self.birthdayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 42 - 30 - 10 - 67, 18));
        make.left.mas_equalTo(self.heardImgView.mas_right).offset(10);
        make.top.mas_equalTo(self.consumeLab.mas_bottom).offset(4);
    }];
    
    self.originLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.originLab.backgroundColor = [UIColor clearColor];
    self.originLab.font = kPingFangRegular(14);
    self.originLab.textColor = UIColorFromRGB(0x666666);
    self.originLab.text = @"";
    self.originLab.textAlignment = NSTextAlignmentLeft;
    [self.firstBgView addSubview:self.originLab];
    [self.originLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 42 - 30 - 10 - 67, 18));
        make.left.mas_equalTo(self.heardImgView.mas_right).offset(10);
        make.top.mas_equalTo(self.birthdayLab.mas_bottom).offset(4);
    }];
    
    self.tickInforLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.tickInforLab.backgroundColor = [UIColor clearColor];
    self.tickInforLab.font = kPingFangRegular(14);
    self.tickInforLab.textColor = UIColorFromRGB(0x666666);
    self.tickInforLab.numberOfLines = 0;
    self.tickInforLab.text = @"";
    self.tickInforLab.textAlignment = NSTextAlignmentLeft;
    [self.firstBgView addSubview:self.tickInforLab];
    [self.tickInforLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 42 - 30 - 10 - 67, 18));
        make.left.mas_equalTo(self.heardImgView.mas_right).offset(10);
        make.top.mas_equalTo(self.originLab.mas_bottom).offset(4);
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
    [self.firstBgView addSubview:doPefectBtn];
    [doPefectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLab.mas_top);
        make.right.mas_equalTo(self.firstBgView.mas_right).offset(- 15);
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(22);
    }];
    
    self.secondBgView = [[UIView alloc] init];
    self.secondBgView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    self.secondBgView.layer.borderColor = UIColorFromRGB(0xdfd9d2).CGColor;
    self.secondBgView.layer.borderWidth = 0.5f;
    self.secondBgView.frame = CGRectMake(0,10,kMainBoundsWidth - 20, 340);
    [self.topView addSubview:self.secondBgView];
    [self.secondBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 100));
        make.centerX.mas_equalTo(self.topView);
        make.top.mas_equalTo(self.firstBgView.mas_bottom).offset(10);
    }];
    
    UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tagLabel.backgroundColor = [UIColor clearColor];
    tagLabel.font = kPingFangRegular(16);
    tagLabel.textColor = UIColorFromRGB(0x222222);
    tagLabel.text = @"标签";
    tagLabel.textAlignment = NSTextAlignmentLeft;
    [self.secondBgView addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 20));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    
    UIButton * editTagButton = [Helper buttonWithTitleColor:kAPPMainColor font:kPingFangRegular(13) backgroundColor:[UIColor clearColor] title:@"编辑" cornerRadius:2.f];
    [editTagButton addTarget:self action:@selector(editButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    editTagButton.layer.borderColor = kAPPMainColor.CGColor;
    editTagButton.layer.borderWidth = .5f;
    [self.secondBgView addSubview:editTagButton];
    [editTagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tagLabel.mas_top);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(40);
    }];
    
    self.tagView = [[CustomerTagView alloc] initWithFrame:CGRectMake(0, 190 * scale, kMainBoundsWidth, 40 * scale)];
    CGFloat tagTotalHeight = 35;
    CGFloat tagViewHeight = self.tagView.frame.size.height + 15;
    tagTotalHeight = tagTotalHeight + tagViewHeight;
    [self.secondBgView addSubview:self.tagView];
    [self.tagView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tagLabel.mas_bottom);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(tagViewHeight);
        make.width.mas_equalTo(kMainBoundsWidth - 30);
    }];
    
    [self.secondBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(tagTotalHeight);
    }];
    
    
    self.thirdBgView = [[UIView alloc] init];
    self.thirdBgView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    self.thirdBgView.layer.borderColor = UIColorFromRGB(0xdfd9d2).CGColor;
    self.thirdBgView.layer.borderWidth = 0.5f;
    [self.topView addSubview:self.thirdBgView];
    [self.thirdBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 100));
        make.centerX.mas_equalTo(self.topView);
        make.top.mas_equalTo(self.secondBgView.mas_bottom).offset(10);
    }];
    
    UILabel *remarkLab = [[UILabel alloc] initWithFrame:CGRectZero];
    remarkLab.backgroundColor = [UIColor clearColor];
    remarkLab.font = kPingFangRegular(16);
    remarkLab.textColor = UIColorFromRGB(0x222222);
    remarkLab.text = @"备注";
    remarkLab.textAlignment = NSTextAlignmentLeft;
    [self.thirdBgView addSubview:remarkLab];
    [remarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 20));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    
    self.remarkContentLab = [Helper labelWithFrame:CGRectZero TextColor:[UIColor grayColor] font:kPingFangRegular(14) alignment:NSTextAlignmentLeft];
    self.remarkContentLab.text = @"请记录客户其他信息";
    self.remarkContentLab.numberOfLines = 0;
    [self.thirdBgView addSubview:self.remarkContentLab];
    [self.remarkContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 30, 20));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(remarkLab.mas_bottom).offset(15);
    }];
   
    UIButton * editRemarkButton = [Helper buttonWithTitleColor:kAPPMainColor font:kPingFangRegular(13) backgroundColor:[UIColor clearColor] title:@"编辑" cornerRadius:2.f];
    [editRemarkButton addTarget:self action:@selector(editRemarkClicked) forControlEvents:UIControlEventTouchUpInside];
    editRemarkButton.layer.borderColor = kAPPMainColor.CGColor;
    editRemarkButton.layer.borderWidth = .5f;
    [self.thirdBgView addSubview:editRemarkButton];
    [editRemarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(remarkLab.mas_top);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(40);
    }];
    
    self.topView.frame = CGRectMake(0,0,kMainBoundsWidth, 46 + 20 + 100 + 145 + 22 + tagTotalHeight);
    
    
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
    self.historyView.delegate = self;
    CGRect rect = self.bottomView.frame;
    rect.size.height = rect.size.height + self.historyView.frame.size.height + 10 * scale;
    self.bottomView.frame = rect;
    [self.bottomView addSubview:self.historyView];

    self.tableView.tableHeaderView = self.topView;
    self.tableView.tableFooterView = self.bottomView;
    
}

- (void)clickBackData:(NSString *)imgUrl{
    
    self.isRequest = NO;
    LookImageViewController *liVC = [[LookImageViewController alloc] initWithImageURL:imgUrl];
    [self presentViewController:liVC animated:NO completion:^{
        
    }];
}

- (void)doPefectClicked{
    
    RDAddressModel *tmpModel;
    if (!isEmptyString(self.netAddressModel.customer_id)&&!isEmptyString(self.netAddressModel.name)) {
        tmpModel = self.netAddressModel;
    }else{
        tmpModel = self.adressModel;
    }
    AddNewCustomerController * addNew = [[AddNewCustomerController alloc] initWithDataModel:tmpModel];
    [self.navigationController pushViewController:addNew animated:YES];
    
}

- (void)editButtonDidClicked{
    
    EditCustomerTagViewController *etVC = [[EditCustomerTagViewController alloc] initWithModel:self.adressModel andIsCustomer:YES];
    etVC.delegate = self;
    [self.navigationController pushViewController:etVC animated:YES];
    
}

- (void)editRemarkClicked{
    
    AddNewRemarkViewController *anVC = [[AddNewRemarkViewController alloc] initWithCustomerId:self.adressModel.customer_id];
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

- (void)dealWithResultData:(NSDictionary *)dic{
    
    NSDictionary *listDic = dic[@"list"];
    NSArray *labelArray = listDic[@"label"];
    [self.dataArray addObjectsFromArray:labelArray];

    NSString *username = listDic[@"name"];
    NSString *sex = listDic[@"sex"];
    NSMutableString *usermobile = [[NSMutableString alloc] initWithString:listDic[@"mobile"]];
    NSString *usermobile1 = listDic[@"mobile1"];
    NSString *consume_ability = listDic[@"consume_ability"];
    NSString *birthday = listDic[@"birthday"];
    NSString *birthplace = listDic[@"birthplace"];
    NSString *face_url = listDic[@"face_url"];
    NSString *bill_info = listDic[@"bill_info"];
    if (!isEmptyString(usermobile1)) {
        [usermobile appendString:[NSString stringWithFormat:@"/%@",usermobile1]];
    }
    
    self.netAddressModel = [[RDAddressModel alloc] initWithNetDict:listDic];
    self.netAddressModel.birthday = birthday;
    self.netAddressModel.gender = sex;
    self.netAddressModel.birthplace = listDic[@"birthplace"];
    self.netAddressModel.consumptionLevel = [listDic[@"consume_ability_id"] integerValue];
    self.netAddressModel.invoiceTitle = bill_info;
    
    [self.heardImgView sd_setImageWithURL:[NSURL URLWithString:face_url] placeholderImage:[UIImage imageNamed:@"mrtx"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    if (!isEmptyString(username)) {
        CGFloat nameWidth = [RDFrequentlyUsed getWidthByHeight:18.f title:username font:kPingFangRegular(16)];
        [self.nameLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(nameWidth);
        }];
        self.nameLab.text = username;
    }else{
        self.nameLab.text = @"";
    }
    
    if (!isEmptyString(sex)) {
        if ([sex isEqualToString:@"1"]) {
            [self.sexImgView setImage:[UIImage imageNamed:@"nan"]];
        }else{
            [self.sexImgView setImage:[UIImage imageNamed:@"nv"]];
        }
    }
    if (!isEmptyString(usermobile)) {
        self.phoneLab.text = [NSString stringWithFormat:@"电话：%@",usermobile];
    }else{
        self.phoneLab.text = @"";
    }
    CGFloat firstBgHeight = 145 + 22;
    if (!isEmptyString(consume_ability)) {
        self.consumeLab.text =  [NSString stringWithFormat:@"人均消费能力：%@",consume_ability];
        [self.consumeLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.phoneLab.mas_bottom).offset(4);
            make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 42 - 30 - 10 - 67, 18));
        }];
    }else{
        firstBgHeight = firstBgHeight - 22;
        self.consumeLab.text = @"";
        [self.consumeLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.phoneLab.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(150, 0));
        }];
    }
    
    if (!isEmptyString(birthday)) {
        self.birthdayLab.text = [NSString stringWithFormat:@"生日：%@",birthday];
        [self.birthdayLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.consumeLab.mas_bottom).offset(4);
            make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 42 - 30 - 10 - 67, 18));
        }];
    }else{
        firstBgHeight = firstBgHeight - 22;
        self.birthdayLab.text = @"";
        [self.birthdayLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.consumeLab.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(100, 0));
        }];
    }
    
    if (!isEmptyString(birthplace)) {
        self.originLab.text = [NSString stringWithFormat:@"籍贯：%@",birthplace];
        [self.originLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.birthdayLab.mas_bottom).offset(4);
            make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 42 - 30 - 10 - 67, 18));
        }];
    }else{
        firstBgHeight = firstBgHeight - 22;
        self.originLab.text = @"";
        [self.originLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.birthdayLab.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(100, 0));
        }];
    }
    
    NSString *tickContetStr = [NSString stringWithFormat:@"发票信息：%@",bill_info];
    CGFloat remarkHeight = [RDFrequentlyUsed getHeightByWidth:kMainBoundsWidth - 42 - 30 - 10 - 67 title:tickContetStr font:kPingFangRegular(14)];
    if (!isEmptyString(bill_info)) {
        firstBgHeight = firstBgHeight - 22 + remarkHeight + 4;
        self.tickInforLab.text = [NSString stringWithFormat:@"发票信息：%@",bill_info];
        [self.tickInforLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.originLab.mas_bottom).offset(4);
            make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 42 - 30 - 10 - 67, remarkHeight));
        }];
    }else{
        firstBgHeight = firstBgHeight - 22;
        self.tickInforLab.text = @"";
        [self.tickInforLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.originLab.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(100, 0));
        }];
    }
    
    [self.firstBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(firstBgHeight);
    }];

    
    [self.tagView reloadTagSource:self.dataArray];
    CGFloat tagTotalHeight = 35;
    CGFloat tagViewHeight = self.tagView.frame.size.height + 15;
    tagTotalHeight = tagTotalHeight + tagViewHeight;
    [self.tagView  mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(tagViewHeight);
    }];
    [self.secondBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(tagTotalHeight);
    }];
    
    NSString *remarkStr = listDic[@"remark"];
    CGFloat thBgViewHeight = 100.f;
    if (!isEmptyString(remarkStr)) {
        CGFloat remarkContentHeight = [RDFrequentlyUsed getHeightByWidth:kMainBoundsWidth - 30 title:remarkStr font:kPingFangRegular(14)];
        self.remarkContentLab.text = remarkStr;
        [self.remarkContentLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(remarkContentHeight);
        }];
        thBgViewHeight = 80 + remarkContentHeight;
        [self.thirdBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,thBgViewHeight));
            make.centerX.mas_equalTo(self.topView);
            make.top.mas_equalTo(self.secondBgView.mas_bottom).offset(10);
        }];
    }
    
    self.topView.frame = CGRectMake(0,0,kMainBoundsWidth, 46 + 20 + firstBgHeight + thBgViewHeight + tagTotalHeight);
    
    [self.tableView reloadData];
    
}

- (void)getConsumRecordRequest:(NSInteger )type{
    
    NSDictionary *parmDic;
    if (type == 1) {
        parmDic = @{   @"type":[NSString stringWithFormat:@"%ld",type],
                       @"customer_id":self.adressModel.customer_id == nil ?@"":self.adressModel.customer_id
                       };
    }else{
        if (self.consumListArray.count > 0) {
            parmDic = @{   @"type":[NSString stringWithFormat:@"%ld",type],
                           @"min_id":self.minId != nil ? self.minId:@"",
                           @"customer_id":self.adressModel.customer_id == nil ?@"":self.adressModel.customer_id
                           };
        }else{
            return;
        }
    }
    GetConsumRecordRequest * request = [[GetConsumRecordRequest alloc] initWithCustomerInfo:parmDic];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        NSDictionary *resultDic = [response objectForKey:@"result"];
        NSArray *listArray = resultDic[@"list"];
        if (listArray.count > 0) {
            self.consumListArray = listArray;
            self.minId = resultDic[@"min_id"];
            [self dealWithConsumResult];
        }else{
        }
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
    
}

- (void)dealWithConsumResult{
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    CGRect rect = CGRectMake(0, 40 * scale, kMainBoundsWidth, 40 * scale);
    if (self.consumListArray.count > 0) {
        for (int i = 0; i < self.consumListArray.count; i ++) {
            NSDictionary *tmpDic = self.consumListArray[i];
//            NSString *recipt = tmpDic[@"recipt"];
            NSString *bigrecipt = tmpDic[@"bigrecipt"];
            [self.historyView addImageWithImgUrl:bigrecipt bigImgUrl:bigrecipt];
        }
    }
    
    rect.size.height = rect.size.height + self.historyView.frame.size.height + 10 * scale;
    self.bottomView.frame = rect;
    [self.tableView reloadData];
}

- (void)CustomerDataRequest{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD showLoadingWithText:@"正在加载客户信息" inView:keyWindow];
    
    if (isEmptyString(self.adressModel.customer_id)) {
        
        NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
        if (!isEmptyString(self.adressModel.name)) {
            [params setObject:self.adressModel.name forKey:@"name"];
        }
        
        if (self.adressModel.mobileArray && self.adressModel.mobileArray.count != 0) {
            if (self.adressModel.mobileArray.count == 1) {
                
                [params setObject:[@[self.adressModel.mobileArray[0]] toReadableJSONString] forKey:@"usermobile"];
                
            }else{
                
                [params setObject:[@[self.adressModel.mobileArray[0], self.adressModel.mobileArray[1]] toReadableJSONString] forKey:@"usermobile"];
                
            }
        }
        
        if (!isEmptyString(self.adressModel.gender)) {
            [params setObject:self.adressModel.gender forKey:@"sex"];
        }
        
        if (!isEmptyString(self.adressModel.birthday)) {
            [params setObject:self.adressModel.birthday forKey:@"birthday"];
        }
        
        if (!isEmptyString(self.adressModel.logoImageURL)) {
            [params setObject:self.adressModel.logoImageURL forKey:@"face_url"];
        }
        
        if (!isEmptyString(self.adressModel.birthplace)) {
            [params setObject:self.adressModel.birthplace forKey:@"birthplace"];
        }
        
        if (self.adressModel.consumptionLevel) {
            [params setObject:[NSString stringWithFormat:@"%ld", self.adressModel.consumptionLevel] forKey:@"consume_ability"];
        }
        
        AddCustomerRequest * request = [[AddCustomerRequest alloc] initWithCustomerInfo:params];
        [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            NSDictionary * result = [response objectForKey:@"result"];
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSDictionary * list = [result objectForKey:@"list"];
                if ([list isKindOfClass:[NSDictionary class]]) {
                    self.adressModel.customer_id = [list objectForKey:@"customer_id"];
                }
            }
            
            [self getCustomerDetailInfo];
            
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            [MBProgressHUD hideHUDForView:keyWindow animated:YES];
            if ([response objectForKey:@"msg"]) {
                [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
            }else{
                [MBProgressHUD showTextHUDwithTitle:@"客户信息有误"];
            }
            
            
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            
            [MBProgressHUD hideHUDForView:keyWindow animated:YES];
            [MBProgressHUD showTextHUDwithTitle:@"请检查网络是否畅通"];
            
        }];
    }else{
        [self getCustomerDetailInfo];
    }
    
}

- (void)getCustomerDetailInfo
{
    [self.dataArray removeAllObjects];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    NSDictionary *parmDic = @{
                              @"invite_id":[GlobalData shared].userModel.invite_id,
                              @"mobile":[GlobalData shared].userModel.telNumber,
                              @"customer_id":self.adressModel.customer_id == nil ?@"":self.adressModel.customer_id
                              };
    CustomDetailInforRequest * request = [[CustomDetailInforRequest alloc] initWithParamData:parmDic];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        NSDictionary *resultDic = [response objectForKey:@"result"];
        [self dealWithResultData:resultDic];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }else{
            [MBProgressHUD showTextHUDwithTitle:@"获取失败"];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        [MBProgressHUD showTextHUDwithTitle:@"网络连接失败，请重试"];
        
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
        self.currectTickUrl = path;
        NSArray *imgArray = [NSArray arrayWithObject:path];
        [self saveCustomerPayHistoryWith:imgArray];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showTextHUDwithTitle:@"小票上传失败"];
        [hud hideAnimated:YES];
        self.isUploading = NO;
    }];
}

#pragma mark - 请求功能消费小票接口
- (void)saveCustomerPayHistoryWith:(NSArray *)images
{
    NSString * imageJson;
    if (images && images.count > 0) {
        imageJson = [images toReadableJSONString];
    }

    MBProgressHUD * hud = [MBProgressHUD showLoadingWithText:@"正在保存消费记录" inView:self.view];
    
    NSString * tagJson = @"";
    if (self.tagView.dataSource.count > 0) {
        NSMutableArray *tagIDArray = [NSMutableArray new];
        for (NSDictionary * tagInfo in self.tagView.dataSource) {
            [tagIDArray addObject:[tagInfo objectForKey:@"label_id"]];
        }
        
        tagJson = [tagIDArray toReadableJSONString];
    }
    
    AddPayHistoryRequest * request = [[AddPayHistoryRequest alloc] initWithCustomerID:self.netAddressModel.customer_id name:self.netAddressModel.name telNumber:self.netAddressModel.mobileArray[0] imagePaths:imageJson tagIDs:tagJson model:self.netAddressModel];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {

        self.isUploading = NO;
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDwithTitle:@"保存成功"];
        [self didSuccessUpLoadImg];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        self.isUploading = NO;
        [hud hideAnimated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }else{
            [MBProgressHUD showTextHUDwithTitle:@"保存失败"];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        self.isUploading = NO;
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDwithTitle:@"保存失败"];
        
    }];
}

- (void)didSuccessUpLoadImg{
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    CGRect rect = CGRectMake(0, 40 * scale, kMainBoundsWidth, 40 * scale);
    
    [self.historyView addImageWithImgUrl:self.currectTickUrl bigImgUrl:self.currectTickUrl];
    
    rect.size.height = rect.size.height + self.historyView.frame.size.height + 10 * scale;
    self.bottomView.frame = rect;
    [self.tableView reloadData];
    
}

- (void)consumeButtonDidClicked
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请选择获取方式" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.picker.allowsEditing = NO;
        self.picker.delegate = self;
        [self presentViewController:self.picker animated:YES completion:nil];
    }];
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.allowsEditing = NO;
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
    
    if (nil == tmpImg) {
        tmpImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
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
