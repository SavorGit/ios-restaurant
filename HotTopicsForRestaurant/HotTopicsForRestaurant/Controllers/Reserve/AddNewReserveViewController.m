//
//  AddNewReserveViewController.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "AddNewReserveViewController.h"
#import "ReserveSeRoomViewController.h"
#import "ReserveModel.h"
#import "RDBoxModel.h"
#import "AddReserveRequest.h"
#import "GetRoomListRequest.h"
#import "CustomerListViewController.h"
#import "RDAddressManager.h"

@interface AddNewReserveViewController ()<UITextFieldDelegate,UITextViewDelegate,CustomerListDelegate>

@property (nonatomic, strong) UITextView *remarkTextView;
@property (nonatomic, strong) UITextView *currentTextView;
@property (nonatomic, strong) NSMutableArray *roomSource;
@property (nonatomic, strong) ReserveModel * dataModel;
@property (nonatomic, strong) ReserveModel * roomSourceModel;

@property (nonatomic, strong) UIDatePicker * datePicker;
@property (nonatomic, strong) UIView * blackView;

@property (nonatomic, assign) BOOL isAddType;

@end

@implementation AddNewReserveViewController

- (instancetype)initWithDataModel:(ReserveModel *)model andType:(BOOL)isAddType
{
    if (self = [super init]) {
        self.dataModel = model;
        self.isAddType = isAddType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfo];
    [self creatSubViews];
    [self creatDatePickView];
    [self getRoomListRequest];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)  name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initInfo{

    self.roomSource = [NSMutableArray new];
    self.roomSourceModel = [[ReserveModel alloc] init];
    if (self.isAddType == YES) {
        self.title = @"新增预定";
        self.dataModel = [[ReserveModel alloc] init];
    }else{
        self.title = @"修改预定";
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

#pragma mark - 获取包间列表
- (void)getRoomListRequest{
    
    GetRoomListRequest * request = [[GetRoomListRequest alloc] initWithInviteId:[GlobalData shared].userModel.invite_id andMobile:[GlobalData shared].userModel.telNumber];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSArray *resultArr = [response objectForKey:@"result"];
        for (int i = 0 ; i < resultArr.count ; i ++) {
            
            NSDictionary *tmpDic = resultArr[i];
            ReserveModel * tmpModel = [[ReserveModel alloc] initWithDictionary:tmpDic];
            [self.roomSource addObject:tmpModel];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        if ([response objectForKey:@"msg"]) {
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

# pragma mark - 提交数据（新增预定）
- (void)addNewReserveRequest{
    
    NSDictionary *parmDic = @{
                              @"invite_id":[GlobalData shared].userModel.invite_id,
                              @"mobile":[GlobalData shared].userModel.telNumber,
                              @"order_mobile":self.dataModel.order_mobile != nil ? self.dataModel.order_mobile:@"",
                              @"order_name":self.dataModel.order_name,
                              @"order_time":self.dataModel.time_str,
                              @"person_nums":self.dataModel.person_nums != nil ? self.dataModel.person_nums:@"",
                              @"remark":self.dataModel.remark != nil ? self.dataModel.remark:@"",
                              @"room_id":self.roomSourceModel.room_id,
                              @"room_type":self.roomSourceModel.room_type,
                              };
    
    [MBProgressHUD showLoadingWithText:@"提交数据" inView:self.view];
    AddReserveRequest * request = [[AddReserveRequest alloc] initWithPubData:parmDic withType:0];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[response objectForKey:@"code"] integerValue] == 10000) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
            
            NSDictionary * result = [response objectForKey:@"result"];
            if ([result isKindOfClass:[NSDictionary class]]) {
                
                NSString * customerID = [result objectForKey:@"customer_id"];
                
                RDAddressModel * model = [[RDAddressModel alloc] init];
                model.name = self.dataModel.order_name;
                if (!isEmptyString(self.dataModel.order_mobile)) {
                    [model.mobileArray addObject:self.dataModel.order_mobile];
                }
                model.customer_id = customerID;
                model.searchKey = [NSString stringWithFormat:@"%@%@%@", self.dataModel.order_name, self.dataModel.order_mobile, [model.pinYin stringByReplacingOccurrencesOfString:@" " withString:@""]];
                
                [[RDAddressManager manager] addNewCustomerBook:@[model] success:^{
                    
                } authorizationFailure:^(NSError *error) {
                    
                }];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            if (self.isAddType == YES) {
                if (self.backB) {
                    self.backB(@"");
                }
            }
            
        }
        
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

- (void)creatSubViews{
    
    CGFloat scale = kMainBoundsWidth/375.f;
    CGFloat distanceTop = 34.f;
    
    NSArray *imgNameArray = [NSArray arrayWithObjects:@"tjyd_khmc",@"tjyd_sj",@"tjyd_rs",@"tjyd_shjian",@"tjyd_bj", nil];
    NSArray *pHolderArray = [NSArray arrayWithObjects:@"请输入客户名称（必填）",@"请输入手机号",@"请输入用餐人数",@"请选择就餐的时间（必填）",@"请选择就餐的包间（必填）", nil];
    
    NSArray *contentArray = [NSArray arrayWithObjects:self.dataModel.order_name,self.dataModel.order_mobile,self.dataModel.person_nums,self.dataModel.time_str,self.dataModel.room_name, nil];
    
    UIView *seImgBgView = [[UIView alloc] init];
    seImgBgView.backgroundColor = UIColorFromRGB(0x9c8c83);
    seImgBgView.layer.cornerRadius = 5.f;
    seImgBgView.layer.masksToBounds = YES;
    [self.view addSubview:seImgBgView];
    [seImgBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
        make.top.mas_equalTo(distanceTop);
        make.right.mas_equalTo(- 30);
    }];
    
    UIImageView *selectImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    selectImgView.contentMode = UIViewContentModeScaleAspectFill;
    selectImgView.image = [UIImage imageNamed:@"xuanzekh"];
    [seImgBgView addSubview:selectImgView];
    [selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(33 *scale);
        make.height.mas_equalTo(33 *scale);
        make.centerX.mas_equalTo(seImgBgView.mas_centerX);
        make.top.mas_equalTo(10);
    }];
    
    UITapGestureRecognizer * selectImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImgClicked:)];
    selectImgTap.numberOfTapsRequired = 1;
    [seImgBgView addGestureRecognizer:selectImgTap];
    
    UILabel *selectTlabel =[[UILabel alloc] init];
    selectTlabel.text = @"选择客户";
    selectTlabel.font = kPingFangRegular(15);
    selectTlabel.textAlignment = NSTextAlignmentCenter;
    selectTlabel.textColor = UIColorFromRGB(0xf6f2ed);
    [seImgBgView addSubview:selectTlabel];
    [selectTlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70 , 20));
        make.centerX.mas_equalTo(seImgBgView.mas_centerX);
        make.top.mas_equalTo(selectImgView.mas_bottom).offset(7);
    }];
    
    for (int i = 0; i < pHolderArray.count; i ++ ) {
        
        UITextField *inPutTextField = [self textFieldWithPlaceholder:pHolderArray[i] leftImageNamed:imgNameArray[i] andTag:i];
        inPutTextField.delegate = self;
        inPutTextField.returnKeyType = UIReturnKeyDone;
        inPutTextField.enablesReturnKeyAutomatically = YES;
        inPutTextField.tag = i + 10000;
        [self.view addSubview:inPutTextField];
        if (self.isAddType == NO) {
            inPutTextField.text = contentArray[i];
        }
        
        if (i == 0 || i == 1 ) {
            
            [inPutTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 130 , 20 *scale));
                make.left.mas_equalTo(15);
                make.top.mas_equalTo(distanceTop + i *50 *scale);
            }];
            if (i == 1) {
                inPutTextField.keyboardType = UIKeyboardTypeNumberPad;
            }
            
        }else{
            
            [inPutTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 30) , 20 *scale));
                make.left.mas_equalTo(15);
                make.top.mas_equalTo(distanceTop + 12.5 + i *50 *scale);
            }];
            
            if (i == 2) {
                inPutTextField.keyboardType = UIKeyboardTypeNumberPad;
            }
            
            if (i == 3 || i == 4 ) {
                
                UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15 * scale, 17 * scale)];
                UIImageView * rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10 * scale, 17 * scale)];
                [rightImageView setImage:[UIImage imageNamed:@"more"]];
                [rightView addSubview:rightImageView];
                inPutTextField.rightView = rightView;
                inPutTextField.rightViewMode = UITextFieldViewModeAlways;
                
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentLabClicked:)];
                tap.numberOfTapsRequired = 1;
                [inPutTextField addGestureRecognizer:tap];
            }
        }
        [inPutTextField addTarget:self action:@selector(infoTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    self.remarkTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    if (self.isAddType == NO) {
        self.remarkTextView.text = self.dataModel.remark;
        self.remarkTextView.textColor = [UIColor blackColor];
    }else{
        self.remarkTextView.text = @"  记录客户其他信息，方便为TA服务";
        self.remarkTextView.textColor = UIColorFromRGB(0x999999);
    }
    self.remarkTextView.font = kPingFangRegular(15);
    self.remarkTextView.backgroundColor = [UIColor clearColor];
    self.remarkTextView.textAlignment = NSTextAlignmentLeft;
    self.remarkTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.remarkTextView.layer.borderColor = UIColorFromRGB(0xb4b1ad).CGColor;
    self.remarkTextView.layer.borderWidth = .5f;
    self.remarkTextView.keyboardType = UIKeyboardTypeDefault;
    self.remarkTextView.returnKeyType = UIReturnKeyDone;
    self.remarkTextView.scrollEnabled = YES;
    self.remarkTextView.delegate = self;
    self.remarkTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.remarkTextView];
    [self.remarkTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(distanceTop + 10 + 5 *50 *scale);
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(kMainBoundsWidth - 60);
        make.height.mas_equalTo(130 *scale);
    }];
    
    UIButton * saveButton = [Helper buttonWithTitleColor:[UIColor whiteColor] font:kPingFangRegular(18) backgroundColor:UIColorFromRGB(0x922c3e) title:@"保存"];
    saveButton.layer.borderColor = [UIColor clearColor].CGColor;
    saveButton.layer.borderWidth = 1;
    saveButton.layer.cornerRadius = 20;
    [self.view addSubview:saveButton];
    [saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(- 30);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(kMainBoundsWidth - 100);
        make.height.mas_equalTo(40);
    }];
    
}

- (void)saveClick{
    
    
    if (self.dataModel.order_name == nil) {
        [MBProgressHUD showTextHUDwithTitle:@"客户名称不能为空"];
    }else if (self.dataModel.order_mobile == nil) {
        [MBProgressHUD showTextHUDwithTitle:@"客户电话不能为空"];
    }else if (self.dataModel.time_str == nil){
        [MBProgressHUD showTextHUDwithTitle:@"预定时间不能为空"];
    }else if (self.roomSourceModel.room_id == nil){
        [MBProgressHUD showTextHUDwithTitle:@"包间不能为空"];
    }else{
        [self  addNewReserveRequest];
    }
}

#pragma mark - 选择客户
- (void)selectImgClicked:(UITapGestureRecognizer *)tap{
    
    CustomerListViewController * list = [[CustomerListViewController alloc] init];
    list.delegate = self;
    [self.navigationController pushViewController:list animated:YES];
    
}

#pragma mark - 选择客户数据
- (void)customerListDidSelect:(RDAddressModel *)model{
    
    UITextField *nameField = (UITextField *)[self.view viewWithTag:10000];
    UITextField *phoneField = (UITextField *)[self.view viewWithTag:10001];
    if (!isEmptyString(model.name)) {
        nameField.text = model.name;
        self.dataModel.order_name = model.name;
    }
    if (model.mobileArray.count > 0) {
        phoneField.text = model.mobileArray[0];
        self.dataModel.order_mobile = model.mobileArray[0];
    }
}

- (void)contentLabClicked:(UIGestureRecognizer *)gesture{
    
    [self.view endEditing:YES];
    
    UIView *tapView = gesture.view;
    if (tapView.tag == 10003) {
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.blackView];
        
    }else if (tapView.tag == 10004){
        
        [self selectRoom];
        
    }
    
}

#pragma mark - 点击选择包间
- (void)selectRoom{
    
    ReserveSeRoomViewController *flVC = [[ReserveSeRoomViewController alloc] initWithArray:self.roomSource];
    float version = [UIDevice currentDevice].systemVersion.floatValue;
    if (version < 8.0) {
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
    } else {;
        flVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    flVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:flVC animated:YES];
    flVC.backDatas = ^(ReserveModel *tmpModel) {
        UILabel *tmpLabel = (UILabel *)[self.view viewWithTag:10004];
        if (!isEmptyString(tmpModel.room_name)) {
            tmpLabel.text = tmpModel.room_name;
            self.roomSourceModel = tmpModel;
        }else{
            tmpLabel.text = @"请选择预定包间";
        }
        [self getRoomListRequest];
    };
    
}

- (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder leftImageNamed:(NSString *)imageName andTag:(NSInteger )fieldTag
{
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectZero];
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    textField.font = kPingFangRegular(15.f);
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.textColor = UIColorFromRGB(0x333333);
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 39 * scale, 21 * scale)];
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24 * scale, 21 * scale)];
    [leftImageView setImage:[UIImage imageNamed:imageName]];
    [leftView addSubview:leftImageView];
    
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:placeholder attributes:
                                      @{NSForegroundColorAttributeName:UIColorFromRGB(0x999999),
                                        NSFontAttributeName:kPingFangRegular(15)
                                        }];
    if (fieldTag == 0 ) {
        [attrString addAttribute:NSForegroundColorAttributeName
                              value:UIColorFromRGB(0x922c3e)
                              range:NSMakeRange(7, 4)];
        [attrString addAttribute:NSFontAttributeName
                              value:kPingFangRegular(15)
                              range:NSMakeRange(7, 4)];
    }else if ( fieldTag == 3 || fieldTag == 4){
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:UIColorFromRGB(0x922c3e)
                           range:NSMakeRange(8, 4)];
        [attrString addAttribute:NSFontAttributeName
                           value:kPingFangRegular(15)
                           range:NSMakeRange(8, 4)];
    }
    textField.attributedPlaceholder = attrString;
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    [textField addSubview:lineView];
    lineView.backgroundColor =UIColorFromRGB(0xb4b1ad);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftView.frame.size.width);
        make.right.mas_equalTo(0.f);
        make.height.mas_equalTo(.5f);
        make.bottom.mas_equalTo(3.f);
    }];
    
    return textField;
}


#pragma mark - textView代理方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.currentTextView = textView;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"  记录客户其他信息，方便为TA服务"]) {
        self.remarkTextView.textColor = [UIColor grayColor];
        textView.text = @"";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
     }else if (range.location < 100){
         return  YES;
     } else if (textView.text.length == 100) {
        return NO;
     }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"%@",textView.text);
    self.dataModel.remark = textView.text;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    self.dataModel.remark = textView.text;
    [textView resignFirstResponder];
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSLog(@"%@",textField.text);
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
    
}

- (void)infoTextDidChange:(UITextField *)textField
{
    if (textField.tag == 10000) {
        
        self.dataModel.order_name = textField.text;
        
    }else if (textField.tag == 10001){
        
        self.dataModel.order_mobile = textField.text;
        
    }else if (textField.tag == 10002){
        
        self.dataModel.person_nums = textField.text;
        
    }
}

//点击空白处的手势要实现的方法
-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    
    if (self.currentTextView != nil) {
        CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        float bottomY = self.view.frame.size.height - (self.remarkTextView.frame.origin.y + self.remarkTextView.frame.size.height);//得到下边框到底部的距离
        float moveY = bottomY - keyboardFrame.size.height;
        
        if (moveY < 0) {
            [self moveWithDistance:moveY];
        }
    }
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    //恢复到默认y为0的状态，有时候要考虑导航栏要+64
    self.currentTextView = nil;
    [self moveWithDistance:64];
}

- (void)moveWithDistance:(CGFloat )distance{
    
    CGRect frame = self.view.frame;
    frame.origin.y = distance ;
    self.view.frame = frame;
    
}

#pragma mark - 日期选择完成
- (void)dateDidBeChoose
{
    NSDate * date = self.datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"];
    NSDateFormatter *formatterOne = [[NSDateFormatter alloc] init] ;
    [formatterOne setDateFormat:@"yyyy-MM-dd  HH:mm"];
    NSString *selectDateStr = [formatter stringFromDate:date];
    NSString *selectOneStr = [formatterOne stringFromDate:date];
    [self.blackView removeFromSuperview];
    
    UILabel *tmpLabel = (UILabel *)[self.view viewWithTag:10003];
    if (!isEmptyString(selectDateStr)) {
        tmpLabel.text = selectOneStr;
        self.dataModel.time_str = selectDateStr;
    }else{
        tmpLabel.text = @"请选择预定包间";
    }
}

- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kMainBoundsHeight / 3 * 2, kMainBoundsWidth, kMainBoundsHeight / 3)];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
//        _datePicker.minimumDate = [NSDate date];
        _datePicker.backgroundColor = UIColorFromRGB(0xffffff);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:self.dataModel.time_str];//上次设置的日期
        if (!self.dataModel.time_str) {
            date = [NSDate date];
        }
        [_datePicker setDate:date];
    }
    return _datePicker;
}

- (void)creatDatePickView{
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
