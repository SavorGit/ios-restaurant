//
//  NewKeyWordBGViewController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/31.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "NewKeyWordBGViewController.h"
#import "ResKeyWordBGCell.h"
#import "GCCKeyChain.h"
#import "GCCGetInfo.h"
#import <AFNetworking/AFNetworking.h>
#import "SAVORXAPI.h"
#import "GCCDLNA.h"

@interface NewKeyWordBGViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) RestaurantServiceModel * model;
@property (nonatomic, assign) BOOL isDefault;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * imageData;
@property (nonatomic, copy) NSString * keyWord;
@property (nonatomic, assign) NSInteger requestCount;
@property (nonatomic, assign) NSInteger resultCount;

@property (nonatomic, strong) NSArray * normalImages;
@property (nonatomic, strong) NSArray * selectImages;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation NewKeyWordBGViewController

- (instancetype)initWithkeyWord:(NSString *)keyWord model:(RestaurantServiceModel *)model isDefault:(BOOL)isDefault
{
    if (self = [super init]) {
        self.keyWord = keyWord;
        self.model = model;
        self.isDefault = isDefault;
        self.selectIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"请选择背景";
    [self createDataSource];
    [self createSubViews];
}

- (void)createDataSource
{
    self.imageData = [NSArray arrayWithObjects:@"1", @"4", @"7", @"2", @"3", @"6", @"8",nil];
    self.normalImages = [NSArray arrayWithObjects:@"keyWord01.jpg", @"keyWord02.jpg", @"keyWord03.jpg", @"keyWord05.jpg", @"keyWord06.jpg", @"keyWord07.jpg", @"keyWord08.jpg",nil];
    self.selectImages = [NSArray arrayWithObjects:@"keyWord01_xz.jpg", @"keyWord02_xz.jpg", @"keyWord03_xz.jpg", @"keyWord05_xz.jpg", @"keyWord06_xz.jpg", @"keyWord07_xz.jpg", @"keyWord08_xz.jpg",nil];
}

- (void)createSubViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = VCBackgroundColor;
    [self.tableView registerClass:[ResKeyWordBGCell class] forCellReuseIdentifier:@"ResKeyWordBGCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 194 * scale;
    self.tableView.sectionFooterHeight = 1;
    self.tableView.sectionHeaderHeight = 10 * scale;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15 * scale);
        make.right.mas_equalTo(-15 * scale);
        make.bottom.mas_equalTo(0);
    }];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 10 * scale)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemDidClicked)];
}

- (void)rightBarButtonItemDidClicked
{
    self.resultCount = 0;
    self.requestCount = 0;
    [MBProgressHUD showLoadingWithText:@"正在投屏" inView:self.view];
    if (!isEmptyString([GlobalData shared].callQRCodeURL)) {
        self.requestCount++;
        [self keyWordShouldUploadWithBaseURL:[GlobalData shared].callQRCodeURL Index:self.selectIndex model:self.model];
    }
    if (!isEmptyString([GlobalData shared].secondCallCodeURL)) {
        self.requestCount++;
        [self keyWordShouldUploadWithBaseURL:[GlobalData shared].secondCallCodeURL Index:self.selectIndex model:self.model];
    }
    if (!isEmptyString([GlobalData shared].thirdCallCodeURL)) {
        self.requestCount++;
        [self keyWordShouldUploadWithBaseURL:[GlobalData shared].thirdCallCodeURL Index:self.selectIndex model:self.model];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.imageData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResKeyWordBGCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ResKeyWordBGCell" forIndexPath:indexPath];
    
    NSString * imageName;
    
    if (self.selectIndex == indexPath.section) {
        imageName = [self.selectImages objectAtIndex:indexPath.section];
    }else{
        imageName = [self.normalImages objectAtIndex:indexPath.section];
    }
    
    [cell configWithImageName:imageName title:self.keyWord];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectIndex != indexPath.section) {
        
        [self backGroundDidSelect:indexPath];
        
    }
}

- (void)backGroundDidSelect:(NSIndexPath *)indexPath
{
    NSIndexPath * lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.selectIndex];
    self.selectIndex = indexPath.section;
    
    [UIView performWithoutAnimation:^{
        [self.tableView reloadRowsAtIndexPaths:@[lastIndexPath, indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)keyWordShouldUploadWithBaseURL:(NSString *)baseURL Index:(NSInteger)index model:(RestaurantServiceModel *)model
{
    NSString *platformUrl = [NSString stringWithFormat:@"%@/command/screend/word", baseURL];
    NSDictionary * parameters = @{@"boxMac" : model.BoxID,
                                  @"deviceId":[GCCKeyChain load:keychainID],
                                  @"deviceName":[GCCGetInfo getIphoneName],
                                  @"templateId":[self.imageData objectAtIndex:index],
                                  @"word":self.keyWord
                                  };
    
    [[AFHTTPSessionManager manager] GET:platformUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 10000) {
            [MBProgressHUD showTextHUDwithTitle:@"欢迎词投屏成功"];
            [self upLogsRequest:@"1"  withModel:model Index:index];
            [model startPlayWord];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
        }else{
            NSString * msg = [responseObject objectForKey:@"msg"];
            if (!isEmptyString(msg)) {
                [MBProgressHUD showTextHUDwithTitle:msg];
            }else{
                [MBProgressHUD showTextHUDwithTitle:@"欢迎词投屏失败"];
            }
            [self upLogsRequest:@"0"  withModel:model Index:index];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.resultCount ++;
        if (self.resultCount == self.requestCount) {
            if ([GlobalData shared].networkStatus == RDNetworkStatusNotReachable) {
                [MBProgressHUD showTextHUDwithTitle:@"网络已断开，请检查网络"];
            }else {
                [MBProgressHUD showTextHUDwithTitle:@"网络连接超时，请重试"];
            }
            [self upLogsRequest:@"0"  withModel:model Index:index];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

- (void)upLogsRequest:(NSString *)reState withModel:(RestaurantServiceModel *)tmpModel Index:(NSInteger)index{
    
    NSDictionary *parmDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",tmpModel.roomID],@"room_id",reState,@"screen_result",@"120",@"screen_time",@"5",@"screen_type",self.keyWord,@"welcome_word",[NSString stringWithFormat:@"%ld", index],@"welcome_template",@"1",@"screen_num", nil];
    [SAVORXAPI upLoadLogRequest:parmDic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
