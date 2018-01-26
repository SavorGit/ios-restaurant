//
//  AddNewPayViewController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/26.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "AddNewPayViewController.h"
#import "CustomerListViewController.h"
#import "CustomerTagView.h"
#import "CustomerPayHistory.h"
#import "RDAddressManager.h"
#import "EditCustomerTagViewController.h"
#import "SAVORXAPI.h"
#import "AddPayHistoryRequest.h"
#import "NSArray+json.h"
#import "OnlyGetCustomerLabelRequest.h"

@interface AddNewPayViewController ()<UITableViewDelegate, UITableViewDataSource, CustomerListDelegate, EditCustomerTagDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UITextField * firstTelField; //手机号
@property (nonatomic, strong) UITextField * nameField; //姓名

@property (nonatomic, strong) UIImagePickerController * picker;

@property (nonatomic, strong) UIImageView * logoImageView;
@property (nonatomic, strong) UILabel * logoLabel;
@property (nonatomic, strong) CustomerTagView * tagView;
@property (nonatomic, strong) CustomerPayHistory * historyView;

@property (nonatomic, strong) UIView * bottomView;

@property (nonatomic, strong) NSMutableArray * tagSource;

@property (nonatomic, strong) RDAddressModel * model;

@property (nonatomic, strong) NSMutableArray * customerList;

@end

@implementation AddNewPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"添加消费记录";
    
    [self createAddNewPayView];
    self.customerList = [[NSMutableArray alloc] init];
    [self preLoadingCustomerList];
}

- (void)preLoadingCustomerList
{
    [[RDAddressManager manager] getOrderCustomerBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        
        for (NSString * key in nameKeys) {
            [self.customerList addObjectsFromArray:[addressBookDict objectForKey:key]];
        }
        
        [self.tableView reloadData];
        
    } authorizationFailure:^(NSError *error) {
        
    }];
}

- (void)createAddNewPayView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 190 * scale)];
    self.topView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    
    self.nameField = [self textFieldWithPlaceholder:@"请输入客户名称" leftImageNamed:@"tjyd_khmc"];
    [self.topView addSubview:self.nameField];
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(30 * scale);
        make.width.mas_equalTo(kMainBoundsWidth-125 * scale);
    }];
    
    self.firstTelField = [self textFieldWithPlaceholder:@"请输入手机号" leftImageNamed:@"tjyd_sj"];
    self.firstTelField.keyboardType = UIKeyboardTypePhonePad;
    [self.topView addSubview:self.firstTelField];
    [self.firstTelField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameField.mas_bottom).offset(30 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(30 * scale);
        make.width.mas_equalTo(kMainBoundsWidth-125 * scale);
    }];
    [self.firstTelField addTarget:self action:@selector(telNumberValueDidChange) forControlEvents:UIControlEventEditingChanged];
    
    UIButton * logoButton = [Helper buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangRegular(14 * scale) backgroundColor:UIColorFromRGB(0x9c8c83) title:@"" cornerRadius:5 * scale];
    [logoButton addTarget:self action:@selector(logoButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:logoButton];
    [logoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35 * scale);
        make.left.mas_equalTo(self.nameField.mas_right).offset(15 * scale);
        make.width.height.mas_equalTo(80 * scale);
    }];
    
    self.logoImageView = [[UIImageView alloc] init];
    [self.logoImageView setImage:[UIImage imageNamed:@"xuanzekh"]];
    [logoButton addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-15 * scale);
        make.width.height.mas_equalTo(33 * scale);
    }];
    
    self.logoLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0xf6f2ed) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentCenter];
    self.logoLabel.text = @"选择客户";
    [logoButton addSubview:self.logoLabel];
    [self.logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoImageView.mas_bottom).offset(10 *scale);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(15 * scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = VCBackgroundColor;
    [self.topView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstTelField.mas_bottom).offset(15 * scale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(5 * scale);
    }];
    
    UILabel * tagLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(16 * scale) alignment:NSTextAlignmentLeft];
    [self.topView addSubview:tagLabel];
    tagLabel.text = @"标签";
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(18 * scale);
    }];
    
    UIButton * editTagButton = [Helper buttonWithTitleColor:kAPPMainColor font:kPingFangRegular(14 * scale) backgroundColor:[UIColor clearColor] title:@"编辑" cornerRadius:3.f];
    [editTagButton addTarget:self action:@selector(editButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    editTagButton.layer.borderColor = kAPPMainColor.CGColor;
    editTagButton.layer.borderWidth = .5f;
    [self.topView addSubview:editTagButton];
    [editTagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(15 * scale);
        make.right.mas_equalTo(-15 * scale);
        make.height.mas_equalTo(20 * scale);
        make.width.mas_equalTo(40 * scale);
    }];
    
    self.tagView = [[CustomerTagView alloc] initWithFrame:CGRectMake(0, 190 * scale, kMainBoundsWidth, 40 * scale)];
    [self.tagView reloadTagSource:self.tagSource];
    CGRect rect = self.topView.frame;
    rect.size.height = rect.size.height + self.tagView.frame.size.height + 10 * scale;
    self.topView.frame = rect;
    [self.topView addSubview:self.tagView];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 40 * scale)];
    self.bottomView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    
    UILabel * historyLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(16 * scale) alignment:NSTextAlignmentLeft];
    [self.bottomView addSubview:historyLabel];
    historyLabel.text = @"消费记录";
    [historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(18 * scale);
    }];
    
    UIButton * historyButton = [Helper buttonWithTitleColor:kAPPMainColor font:kPingFangRegular(14 * scale) backgroundColor:[UIColor clearColor] title:@"添加" cornerRadius:3.f];
    historyButton.layer.borderColor = kAPPMainColor.CGColor;
    historyButton.layer.borderWidth = .5f;
    [historyButton addTarget:self action:@selector(addHistoryButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:historyButton];
    [historyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.right.mas_equalTo(-15 * scale);
        make.height.mas_equalTo(20 * scale);
        make.width.mas_equalTo(40 * scale);
    }];
    
    self.historyView = [[CustomerPayHistory alloc] initWithFrame:CGRectMake(0, 40 * scale, kMainBoundsWidth, 40 * scale)];
    rect = self.bottomView.frame;
    rect.size.height = rect.size.height + self.historyView.frame.size.height + 10 * scale;
    self.bottomView.frame = rect;
    [self.bottomView addSubview:self.historyView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xece6de);
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    self.tableView.tableHeaderView = self.topView;
    self.tableView.tableFooterView = self.bottomView;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UIButton * saveButton = [Helper buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangRegular(17 * scale) backgroundColor:kAPPMainColor title:@"保存" cornerRadius:20 * scale];
    [saveButton addTarget:self action:@selector(saveButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60 * scale);
        make.bottom.mas_equalTo(-30 * scale);
        make.height.mas_equalTo(45 * scale);
        make.right.mas_equalTo(-60 * scale);
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void)saveButtonDidClicked
{
    NSString * name = self.nameField.text;
    NSString * mobile = self.firstTelField.text;
    
    if (isEmptyString(name)) {
        [MBProgressHUD showTextHUDwithTitle:@"请输入客户姓名"];
    }else if (isEmptyString(mobile)){
        [MBProgressHUD showTextHUDwithTitle:@"请输入客户手机号"];
    }
    
    if (self.historyView.imageArray.count > 0) {
        
        MBProgressHUD * hud = [MBProgressHUD showLoadingWithText:@"正在上传消费记录" inView:self.view];
        __block NSInteger resultCount = 0;
        __block NSMutableArray * imagePaths = [[NSMutableArray alloc] init];
        [SAVORXAPI uploadImageArray:self.historyView.imageArray progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            
        } success:^(NSString *path, NSInteger index) {
            
            resultCount++;
            if (resultCount == self.historyView.imageArray.count) {
                [hud hideAnimated:YES];
                [imagePaths addObject:path];
                [self saveCustomerPayHistoryWith:imagePaths];
            }
            
        } failure:^(NSError *error, NSInteger index) {
            
            [self cancelOSSTask];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [hud hideAnimated:YES];
                [MBProgressHUD showTextHUDwithTitle:[NSString stringWithFormat:@"第%ld张图片上传失败",index + 1]];
                return;
            });
            
        }];
        
    }else{
        [MBProgressHUD showTextHUDwithTitle:@"请上传客户用餐小票"];
    }
}

- (void)cancelOSSTask
{
    [SAVORXAPI cancelOSSTask];
}

- (void)saveCustomerPayHistoryWith:(NSArray *)images
{
    NSString * imageJson;
    if (images && images.count > 0) {
        imageJson = [images toReadableJSONString];
    }
    NSString * tagJson;
    if (self.tagView.lightIDArray.count > 0) {
        tagJson = [self.tagView.lightIDArray toReadableJSONString];
    }
    NSString * name = self.nameField.text;
    NSString * telNumber = self.firstTelField.text;
    
    RDAddressModel * model;
    if ([self.model.searchKey containsString:telNumber]) {
        model = self.model;
    }
    
    NSString * customerID;
    if (model && !isEmptyString(model.customer_id)) {
        customerID = model.customer_id;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showLoadingWithText:@"正在保存消费记录" inView:self.view];
    AddPayHistoryRequest * request = [[AddPayHistoryRequest alloc] initWithCustomerID:customerID name:name telNumber:telNumber imagePaths:imageJson tagIDs:tagJson model:model];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.navigationController popViewControllerAnimated:YES];
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDwithTitle:@"保存成功"];
        
        NSDictionary * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            if (result[@"list"]) {
                NSDictionary * list = [result objectForKey:@"list"];
                if ([list isKindOfClass:[NSDictionary class]]) {
                    NSString * customerID = [list objectForKey:@"customer_id"];
                    
                    RDAddressModel * model = [[RDAddressModel alloc] init];
                    model.name = name;
                    [model.mobileArray addObject:telNumber];
                    model.customer_id = customerID;
                    
                    [[RDAddressManager manager] addNewCustomerBook:@[model] success:^{
                        
                    } authorizationFailure:^(NSError *error) {
                        
                    }];
                }
            }
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }else{
            [MBProgressHUD showTextHUDwithTitle:@"保存失败"];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDwithTitle:@"保存失败"];
        
    }];
}

- (void)addHistoryButtonDidClicked
{
    [self endEditing];
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请选择添加方式" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
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
    
    // dismiss UIImagePickerController
    [self dismissViewControllerAnimated:YES completion:nil];
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    CGRect rect = self.bottomView.frame;
    rect.size.height = rect.size.height - self.historyView.frame.size.height - 10 * scale;
    
    UIImage *tmpImg = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (nil == tmpImg) {
        tmpImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [self.historyView addImageWithImage:tmpImg];
    rect.size.height = rect.size.height + self.historyView.frame.size.height + 10 * scale;
    self.bottomView.frame = rect;
    [self.tableView reloadData];
}

// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editButtonDidClicked
{
    [self endEditing];
    
    if ([self.model.searchKey containsString:self.firstTelField.text]){
        
    }else{
        self.model = nil;
    }
    
    EditCustomerTagViewController * editTag = [[EditCustomerTagViewController alloc] initWithModel:self.model andIsCustomer:NO];
    if (self.tagView.lightIDArray && self.tagView.lightIDArray.count > 0) {
        [editTag didSelectWithIDs:self.tagView.lightIDArray];
    }
    editTag.delegate = self;
    [self.navigationController pushViewController:editTag animated:YES];
}

- (void)customerTagDidUpdateWithLightData:(NSArray *)dataSource lightID:(NSArray *)idArray
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    CGRect rect = self.topView.frame;
    
    rect.size.height = rect.size.height - self.tagView.frame.size.height - 10 * scale;
    [self.tagView reloadTagSource:dataSource];
    rect.size.height = rect.size.height + self.tagView.frame.size.height + 10 * scale;
    self.topView.frame = rect;
    [self.tableView reloadData];
    self.tagView.lightIDArray = [[NSMutableArray alloc] initWithArray:idArray];
}

- (void)telNumberValueDidChange
{
    NSString *str = self.firstTelField.text;
    if (str.length == 11) {
        NSString * searchKey = str;
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"searchKey CONTAINS %@", searchKey];
        NSArray * resultArray = [self.customerList filteredArrayUsingPredicate:predicate];
        if (resultArray.count > 0) {
            
            RDAddressModel * model = [resultArray firstObject];
            [self customerListDidSelect:model];
            [self onlyGetCustomerLabelWithCustomerID:model.customer_id];
            
        }
    }
    
    if (str.length > 20) {
        self.firstTelField.text = [str substringToIndex:20];
    }
}

- (void)customerListDidSelect:(RDAddressModel *)model
{
    self.model = model;
    self.nameField.text = model.name;
    if (model.mobileArray && model.mobileArray.count > 0) {
        self.firstTelField.text = [model.mobileArray firstObject];
    }
    [self onlyGetCustomerLabelWithCustomerID:model.customer_id];
}

- (void)logoButtonDidClicked
{
    [self endEditing];
    CustomerListViewController * list = [[CustomerListViewController alloc] init];
    list.delegate = self;
    [self.navigationController pushViewController:list animated:YES];
}

- (void)onlyGetCustomerLabelWithCustomerID:(NSString *)customerID
{
    if (isEmptyString(customerID)) {
        return;
    }
    
    OnlyGetCustomerLabelRequest * request = [[OnlyGetCustomerLabelRequest alloc] initWithCustomerID:customerID];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSArray * list = [result objectForKey:@"list"];
            if ([list isKindOfClass:[NSArray class]]) {
                
                NSMutableArray * idArray = [NSMutableArray new];
                for (NSDictionary * dict in list) {
                    NSString * labelID = [dict objectForKey:@"label_id"];
                    [idArray addObject:labelID];
                }
                
                [self customerTagDidUpdateWithLightData:list lightID:idArray];
            }
            
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

- (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder leftImageNamed:(NSString *)imageName
{
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectZero];
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    textField.font = kPingFangRegular(15.f * scale);
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.textColor = UIColorFromRGB(0x333333);
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37 * scale, 21 * scale)];
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24 * scale, 21 * scale)];
    [leftImageView setImage:[UIImage imageNamed:imageName]];
    [leftView addSubview:leftImageView];
    
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholder attributes:
                                      @{NSForegroundColorAttributeName:UIColorFromRGB(0x999999),
                                        NSFontAttributeName:kHiraginoSansW3(15.f * scale)
                                        }];
    textField.attributedPlaceholder = attrString;
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = UIColorFromRGB(0xb4b1ad);
    [textField addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(.5f);
    }];
    
    return textField;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = UIColorFromRGB(0xece6de);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    return 5.f * scale;
}

- (NSMutableArray *)tagSource
{
    if (!_tagSource) {
        _tagSource = [[NSMutableArray alloc] init];
        }
    return _tagSource;
}

- (void)endEditing;
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
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
