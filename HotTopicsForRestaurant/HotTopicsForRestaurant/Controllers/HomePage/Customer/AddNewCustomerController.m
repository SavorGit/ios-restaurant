//
//  AddNewCustomerController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "AddNewCustomerController.h"
#import "MultiSelectAddressController.h"
#import "RDAddressManager.h"
#import "AddCustomerRequest.h"
#import "SAVORXAPI.h"
#import "NSArray+json.h"

@interface AddNewCustomerController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIView * bottomView;

@property (nonatomic, strong) UIImageView * logoImageView;
@property (nonatomic, strong) UILabel * logoLabel;

//必填
@property (nonatomic, strong) UITextField * firstTelField; //手机号
@property (nonatomic, strong) UITextField * nameField; //姓名

//非必填
@property (nonatomic, strong) UITextField * secondTelField; //第二个手机号

//性别
@property (nonatomic, strong) UIButton * maleButton;
@property (nonatomic, strong) UIButton * femaleButton;
@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, strong) UILabel * consumptionLabel;
@property (nonatomic, copy) NSString * consumptionLevel;

@property (nonatomic, strong) UILabel * birthdayLabel;
@property (nonatomic, copy) NSString * birthday;

@property (nonatomic, strong) UITextField * placeField;
@property (nonatomic, strong) UITextField * invoiceField;

@property (nonatomic, strong) UIDatePicker * datePicker;
@property (nonatomic, strong) UIView * blackView;

@property (nonatomic, strong) UIImagePickerController * picker;

@end

@implementation AddNewCustomerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"新增客户";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"导入通讯录" style:UIBarButtonItemStyleDone target:self action:@selector(addCustomerFromSystemAddress)];
    [self createAddNewCustomerUI];
}

- (void)createAddNewCustomerUI
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    CGFloat height = 0;
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 120 * scale)];
    self.topView.backgroundColor = [UIColor whiteColor];
    
    self.bottomView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    
    self.nameField = [self textFieldWithPlaceholder:@"请输入姓名" leftImageNamed:@""];
    [self.topView addSubview:self.nameField];
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(60 * scale);
        make.width.mas_equalTo(kMainBoundsWidth-125 * scale);
    }];
    [self addLineTo:self.nameField];
    
    self.firstTelField = [self textFieldWithPlaceholder:@"请输入手机号" leftImageNamed:@""];
    [self.topView addSubview:self.firstTelField];
    [self.firstTelField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameField.mas_bottom);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(60 * scale);
        make.width.mas_equalTo(kMainBoundsWidth-125 * scale);
    }];
    
    self.secondTelField = [self textFieldWithPlaceholder:@"请输入手机号" leftImageNamed:@""];
    
    UIButton * logoButton = [Helper buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangRegular(14 * scale) backgroundColor:[UIColor clearColor] title:@""];
    [logoButton addTarget:self action:@selector(logoButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:logoButton];
    [logoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.nameField.mas_right);
        make.bottom.mas_equalTo(self.firstTelField.mas_bottom);
        make.width.mas_equalTo(110 * scale);
    }];
    
    self.logoImageView = [[UIImageView alloc] init];
    [logoButton addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20 * scale);
        make.right.mas_equalTo(-25 * scale);
        make.width.height.mas_equalTo(60 * scale);
    }];
    self.logoImageView.layer.cornerRadius = 30 * scale;
    self.logoImageView.layer.masksToBounds = YES;
    self.logoImageView.backgroundColor = [UIColor grayColor];
    
    self.logoLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentCenter];
    self.logoLabel.text = @"上传头像";
    [logoButton addSubview:self.logoLabel];
    [self.logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10 * scale);
        make.width.mas_equalTo(90 * scale);
        make.height.mas_equalTo(15 * scale);
        make.top.mas_equalTo(self.logoImageView.mas_bottom).offset(5 *scale);
    }];
    
    UIButton * addTelButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    addTelButton.frame = CGRectMake(0, 0, 20 * scale, 20 * scale);
    [addTelButton addTarget:self action:@selector(addTelButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.firstTelField.rightView = addTelButton;
    self.firstTelField.rightViewMode = UITextFieldViewModeAlways;
    
    UILabel * optionalTopicLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(16 * scale) alignment:NSTextAlignmentLeft];
    optionalTopicLabel.text = @"以下为选填内容（可不填）";
    [self.bottomView addSubview:optionalTopicLabel];
    [optionalTopicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(18 * scale);
    }];
    height += 15 * scale + 18 * scale;

    UIView * gender = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32 * scale, 18 * scale)];
    [self.bottomView addSubview:gender];
    [gender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(optionalTopicLabel.mas_bottom).offset(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(60 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 15 * scale);
    }];
    [self addLineTo:gender];
    height += 15 * scale + 60 * scale;

    UIImageView * genderImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [genderImageView setImage:[UIImage imageNamed:@""]];
    [gender addSubview:genderImageView];
    [genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(18 * scale);
    }];

    self.maleButton = [Helper buttonWithTitleColor:kAPPMainColor font:kPingFangRegular(15 * scale) backgroundColor:[UIColor clearColor] title:@"男" cornerRadius:3.f];
    self.femaleButton = [Helper buttonWithTitleColor:kAPPMainColor font:kPingFangRegular(15 * scale) backgroundColor:[UIColor clearColor] title:@"女" cornerRadius:3.f];

    self.maleButton.layer.borderColor = kAPPMainColor.CGColor;
    self.maleButton.layer.borderWidth = .5f;
    [gender addSubview:self.maleButton];
    [self.maleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(genderImageView.mas_right).offset(25.f);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(50 * scale);
        make.height.mas_equalTo(25 * scale);
    }];
    [self.maleButton addTarget:self action:@selector(genderButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.femaleButton.layer.borderColor = kAPPMainColor.CGColor;
    self.femaleButton.layer.borderWidth = .5f;
    [gender addSubview:self.femaleButton];
    [self.femaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.maleButton.mas_right).offset(30 * scale);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(50 * scale);
        make.height.mas_equalTo(25 * scale);
    }];
    [self.femaleButton addTarget:self action:@selector(genderButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];

    UIButton * consumptionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:consumptionButton];
    [consumptionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(gender.mas_bottom).offset(0);
        make.left.height.right.mas_equalTo(gender);
    }];
    [self addLineTo:consumptionButton];
    height += 60 * scale;

    UIImageView * consumptionImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [consumptionImageView setImage:[UIImage imageNamed:@""]];
    [consumptionButton addSubview:consumptionImageView];
    [consumptionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(18 * scale);
    }];

    self.consumptionLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x999999) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    self.consumptionLabel.text = @"请选择消费能力";
    [consumptionButton addSubview:self.consumptionLabel];
    [self.consumptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo(consumptionImageView.mas_right).offset(15 * scale);
    }];
    [self addLeftDetailImageTo:consumptionButton];

    UIButton * birthdayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:birthdayButton];
    [birthdayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(consumptionButton.mas_bottom).offset(0);
        make.left.height.right.mas_equalTo(consumptionButton);
    }];
    [self addLineTo:birthdayButton];
    [birthdayButton addTarget:self action:@selector(birthdayButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    height += 60 * scale;

    UIImageView * birthdayImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [birthdayImageView setImage:[UIImage imageNamed:@""]];
    [birthdayButton addSubview:birthdayImageView];
    [birthdayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(18 * scale);
    }];

    self.birthdayLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x999999) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    self.birthdayLabel.text = @"请选择生日";
    [birthdayButton addSubview:self.birthdayLabel];
    [self.birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo(consumptionImageView.mas_right).offset(15 * scale);
    }];
    [self addLeftDetailImageTo:birthdayButton];

    self.placeField = [self textFieldWithPlaceholder:@"请输入籍贯" leftImageNamed:@""];
    [self.bottomView addSubview:self.placeField];
    [self.placeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(birthdayButton.mas_bottom).offset(0);
        make.left.height.right.mas_equalTo(birthdayButton);
    }];
    [self addLineTo:self.placeField];
    height += 60 * scale;

    self.invoiceField = [self textFieldWithPlaceholder:@"请输入发票信息" leftImageNamed:@""];
    [self.bottomView addSubview:self.invoiceField];
    [self.invoiceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.placeField.mas_bottom).offset(0);
        make.left.height.right.mas_equalTo(self.placeField);
    }];
    [self addLineTo:self.invoiceField];
    height += 60 * scale;
    
    UIButton * saveButton = [Helper buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangRegular(16 * scale) backgroundColor:kAPPMainColor title:@"保存" cornerRadius:20 * scale];
    [self.bottomView addSubview:saveButton];
    [saveButton addTarget:self action:@selector(saveButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60 * scale);
        make.bottom.mas_equalTo(-40 * scale);
        make.height.mas_equalTo(40 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 120 * scale);
    }];
    height += 120 * scale;
    
    self.bottomView.frame = CGRectMake(0, 0, kMainBoundsWidth, height);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.topView;
    self.tableView.tableFooterView = self.bottomView;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.blackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6f];
    
    [self.blackView addSubview:self.datePicker];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, self.datePicker.frame.origin.y - 50, kMainBoundsWidth, 50)];
    view.backgroundColor = UIColorFromRGB(0xffffff);
    [self.blackView addSubview:view];
    
    UIButton * cancle = [Helper buttonWithTitleColor:UIColorFromRGB(0x333333) font:kPingFangRegular(18) backgroundColor:[UIColor clearColor] title:@"取消"];
    cancle.frame = CGRectMake(10, 10, 60, 40);
    [view addSubview:cancle];
    [cancle addTarget:self.blackView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * button = [Helper buttonWithTitleColor:UIColorFromRGB(0x333333) font:kPingFangRegular(18) backgroundColor:[UIColor clearColor] title:@"完成"];
    button.frame = CGRectMake(kMainBoundsWidth - 70, 10, 60, 40);
    [view addSubview:button];
    [button addTarget:self action:@selector(dateDidBeChoose) forControlEvents:UIControlEventTouchUpInside];
}

- (void)logoButtonDidClicked
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
    
    // dismiss UIImagePickerController
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.logoImageView setImage:[info objectForKey:UIImagePickerControllerEditedImage]];
    self.logoLabel.text = @"修改头像";
}

// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 上传新增客户信息
- (void)saveButtonDidClicked:(UIButton *)button
{
    if ([self.logoLabel.text isEqualToString:@"修改头像"]) {
        MBProgressHUD * hud = [MBProgressHUD showLoadingWithText:@"正在加载" inView:self.view];
        [SAVORXAPI uploadImage:self.logoImageView.image withImageName:[NSString stringWithFormat:@"%@", [NSDate date]] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            
        } success:^(NSString *path) {
            
            [hud hideAnimated:YES];
            [self saveCustomerWith:button];
            
        } failure:^(NSError *error) {
            
            [hud hideAnimated:YES];
            [self saveCustomerWith:button];
            
        }];
    }
    [self saveCustomerWith:button];
}

- (void)saveCustomerWith:(UIButton *)button
{
    button.enabled = NO;
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    RDAddressModel * model = [[RDAddressModel alloc] init];
    
    NSString * name = self.nameField.text;
    NSString * telNumber1 = self.firstTelField.text;
    NSString * telNumber2 = self.secondTelField.text;
    
    if (isEmptyString(name)) {
        [MBProgressHUD showTextHUDwithTitle:@"请填写用户名称"];
        button.enabled = YES;
        return;
    }else{
        [params setObject:name forKey:@"name"];
        model.name = name;
        model.searchKey = name;
    }
    
    if (isEmptyString(telNumber1) && isEmptyString(telNumber2)) {
        [MBProgressHUD showTextHUDwithTitle:@"请填写用户手机号"];
        button.enabled = YES;
        return;
    }else if (isEmptyString(telNumber1)) {
        [params setObject:[@[telNumber2] toReadableJSONString] forKey:@"usermobile"];
        [model.mobileArray addObject:telNumber2];
        model.searchKey = [model.searchKey stringByAppendingString:telNumber2];
    }else if (isEmptyString(telNumber2)) {
        [params setObject:[@[telNumber1] toReadableJSONString] forKey:@"usermobile"];
        [model.mobileArray addObject:telNumber1];
        model.searchKey = [model.searchKey stringByAppendingString:telNumber1];
    }else{
        [params setObject:[@[telNumber1, telNumber2] toReadableJSONString] forKey:@"usermobile"];
        [model.mobileArray addObject:telNumber1];
        [model.mobileArray addObject:telNumber2];
        model.searchKey = [model.searchKey stringByAppendingString:telNumber1];
        model.searchKey = [model.searchKey stringByAppendingString:telNumber2];
    }
    
    if (self.gender == 1) {
        [params setObject:@"1" forKey:@"sex"];
    }else if (self.gender == 2) {
        [params setObject:@"2" forKey:@"sex"];
    }
    
    if (!isEmptyString(self.consumptionLevel)) {
        [params setObject:self.consumptionLevel forKey:@"consume_ability"];
    }
    
    if (!isEmptyString(self.birthday)) {
        [params setObject:self.birthday forKey:@"birthplace"];
    }
    
    if (!isEmptyString(self.placeField.text)) {
        [params setObject:self.placeField.text forKey:@"birthplace"];
    }
    
    if (!isEmptyString(self.consumptionLabel.text)) {
        [params setObject:self.consumptionLabel.text forKey:@"bill_info"];
    }
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"searchKey CONTAINS %@", model.searchKey];
    NSArray * resultArray = [self.customerList filteredArrayUsingPredicate:predicate];
    if (resultArray && resultArray.count > 0) {
        
        button.enabled = YES;
        [MBProgressHUD showTextHUDwithTitle:@"该客户已经存在"];
        
    }else{
        
        [[RDAddressManager manager] addNewCustomerBook:@[model] success:^{
            
            button.enabled = YES;
            [MBProgressHUD showTextHUDwithTitle:@"添加成功"];
            
            AddCustomerRequest * request = [[AddCustomerRequest alloc] initWithCustomerInfo:params];
            [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
                
            } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
                
            } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
                
            }];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } authorizationFailure:^(NSError *error) {
            
            button.enabled = YES;
            [MBProgressHUD showTextHUDwithTitle:@"添加失败"];
            
        }];
    }
}

- (void)birthdayButtonDidClicked
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.blackView];
}

- (void)genderButtonDidClicked:(UIButton *)button
{
    if (button == self.maleButton) {
        
        [self.femaleButton setBackgroundColor:[UIColor clearColor]];
        [self.femaleButton setTitleColor:kAPPMainColor forState:UIControlStateNormal];
        
        [self.maleButton setBackgroundColor:kAPPMainColor];
        [self.maleButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        
        self.gender = 1;
        
    }else if (button == self.femaleButton) {
        
        [self.maleButton setBackgroundColor:[UIColor clearColor]];
        [self.maleButton setTitleColor:kAPPMainColor forState:UIControlStateNormal];
        
        [self.femaleButton setBackgroundColor:kAPPMainColor];
        [self.femaleButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        
        self.gender = 2;
    }
}

- (void)addCustomerFromSystemAddress
{
    MultiSelectAddressController * address = [[MultiSelectAddressController alloc] init];
    address.customerList = self.customerList;
    [self.navigationController pushViewController:address animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = UIColorFromRGB(0xece6de);
    
    return cell;
}

- (void)addTelButtonDidClicked:(UIButton *)button
{
    self.firstTelField.rightView = nil;
    
    [button removeFromSuperview];
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    [self.topView addSubview:self.secondTelField];
    [self addLineTo:self.firstTelField];
    
    self.topView.frame = CGRectMake(0, 0, kMainBoundsWidth, 180 * scale);
    
    [self.secondTelField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstTelField.mas_bottom);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(60 * scale);
        make.right.mas_equalTo(-100 * scale);
    }];
    [self.tableView reloadData];
}

- (void)dateDidBeChoose
{
    NSDate * date = self.datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.birthdayLabel.text = [formatter stringFromDate:date];
    [self.blackView removeFromSuperview];
    self.birthday = [formatter stringFromDate:date];
}

- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kMainBoundsHeight / 3 * 2, kMainBoundsWidth, kMainBoundsHeight / 3)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.maximumDate = [NSDate date];
        _datePicker.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _datePicker;
}

- (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder leftImageNamed:(NSString *)imageName
{
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectZero];
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    textField.font = kPingFangRegular(15.f * scale);
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.textColor = UIColorFromRGB(0x333333);
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32 * scale, 18 * scale)];
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18 * scale, 18 * scale)];
    [leftImageView setImage:[UIImage imageNamed:imageName]];
    [leftView addSubview:leftImageView];
    
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholder attributes:
                                      @{NSForegroundColorAttributeName:UIColorFromRGB(0x999999),
                                        NSFontAttributeName:kHiraginoSansW3(15.f * scale)
                                        }];
    textField.attributedPlaceholder = attrString;
    
    return textField;
}

- (void)addLeftDetailImageTo:(UIView *)view
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageView setImage:[UIImage imageNamed:@""]];
    imageView.backgroundColor = [UIColor blueColor];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20 * scale);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
}

- (void)addLineTo:(UIView *)view
{
    UIView * line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor grayColor];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(.5f);
    }];
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
