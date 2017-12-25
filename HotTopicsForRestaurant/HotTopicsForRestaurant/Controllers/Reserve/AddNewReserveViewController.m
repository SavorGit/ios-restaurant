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

@interface AddNewReserveViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) UITextView *remarkTextView;
@property (nonatomic, strong) UITextView *currentTextView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *roomSource;
@property (nonatomic, strong) ReserveModel * dataModel;
@property (nonatomic, strong) ReserveModel * roomSourceModel;

@property (nonatomic, strong) UIDatePicker * datePicker;
@property (nonatomic, strong) UIView * blackView;

@end

@implementation AddNewReserveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfo];
    [self creatSubViews];
    [self creatDatePickView];
    [self getRoomListRequest];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)  name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initInfo{
    
    self.title = @"新增预定";
    self.dataSource = [NSMutableArray new];
    self.roomSource = [NSMutableArray new];
    self.dataModel = [[ReserveModel alloc] init];
    self.roomSourceModel = [[ReserveModel alloc] init];
    
    for (int i = 0; i < 10; i ++) {
        
        ReserveModel *tmpModel = [[ReserveModel alloc] init];
        tmpModel.name = @"快活林";
        tmpModel.roomId = [NSString stringWithFormat:@"%i",i];
        
        [self.dataSource addObject:tmpModel];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

#pragma mark - 获取包间列表
- (void)getRoomListRequest{
    
    [self.dataSource removeAllObjects];
    
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
    
    [self.dataSource removeAllObjects];
    [MBProgressHUD showLoadingWithText:@"" inView:self.view];
    
    NSDictionary *parmDic = @{
                              @"invite_id":[GlobalData shared].userModel.invite_id,
                              @"mobile":[GlobalData shared].userModel.telNumber,
                              @"order_mobile":@"18510376666",
                              @"order_name":@"郭襄",
                              @"order_time":@"2017-12-25",
                              @"person_nums":@"5",
                              @"remark":@"5",
                              @"room_id":self.roomSourceModel.roomId,
                              @"room_type":self.roomSourceModel.room_type,
                              };
    AddReserveRequest * request = [[AddReserveRequest alloc] initWithPubData:parmDic withType:0];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *resultArr = [response objectForKey:@"result"];
        NSArray * sameArr ;
        if ([[NSFileManager defaultManager] fileExistsAtPath:UserSelectDishPath]) {
            sameArr = [NSArray arrayWithContentsOfFile:UserSelectDishPath];
        }
        for (int i = 0 ; i < resultArr.count ; i ++) {
            
            NSDictionary *tmpDic = resultArr[i];
            ReserveModel * tmpModel = [[ReserveModel alloc] initWithDictionary:tmpDic];
            [self.dataSource addObject:tmpModel];
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
    CGFloat distanceTop = 60.f;
    
    NSArray *pHolderArray = [NSArray arrayWithObjects:@"请输入客户名称",@"请输入手机号",@"请输入用餐人数",@"请选择预定时间",@"请选择预定包间", nil];
    
    UIImageView *selectImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    selectImgView.contentMode = UIViewContentModeScaleAspectFill;
    selectImgView.layer.borderWidth = 0.f;
    selectImgView.layer.cornerRadius = 5.f;
    selectImgView.layer.borderColor = [UIColor clearColor].CGColor;
    selectImgView.layer.masksToBounds = YES;
    selectImgView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:selectImgView];
    [selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70 *scale);
        make.height.mas_equalTo(70 *scale);
        make.top.mas_equalTo(distanceTop);
        make.right.mas_equalTo(- 30);
    }];
    
    for (int i = 0; i < pHolderArray.count; i ++ ) {
        
        UITextField *inPutTextField = [self textFieldWithPlaceholder:pHolderArray[i] leftImageNamed:@"tianjia"];
        inPutTextField.delegate = self;
        inPutTextField.returnKeyType = UIReturnKeyDone;
        inPutTextField.enablesReturnKeyAutomatically = YES;
        inPutTextField.tag = i + 10000;
        [self.view addSubview:inPutTextField];
        
        if (i == 0 || i == 1 ) {
            
            [inPutTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 160 , 20 *scale));
                make.left.mas_equalTo(30);
                make.top.mas_equalTo(distanceTop + i *50 *scale);
            }];
            
        }else{
            
            [inPutTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 60) , 20 *scale));
                make.left.mas_equalTo(30);
                make.top.mas_equalTo(distanceTop + 10 + i *50 *scale);
            }];
            
            if (i == 3 || i == 4 ) {
                
                UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32 * scale, 18 * scale)];
                UIImageView * rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18 * scale, 18 * scale)];
                [rightImageView setImage:[UIImage imageNamed:@"tianjia"]];
                [rightView addSubview:rightImageView];
                inPutTextField.rightView = rightView;
                inPutTextField.rightViewMode = UITextFieldViewModeAlways;
                
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentLabClicked:)];
                tap.numberOfTapsRequired = 1;
                [inPutTextField addGestureRecognizer:tap];
            }
        }
    }
    
    self.remarkTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.remarkTextView.text = @"备注，限制100字";
    self.remarkTextView.font = [UIFont systemFontOfSize:14];
    self.remarkTextView.textColor = UIColorFromRGB(0xe0dad2);
    self.remarkTextView.textAlignment = NSTextAlignmentLeft;
    self.remarkTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.remarkTextView.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    self.remarkTextView.layer.borderWidth = 1;
    self.remarkTextView.layer.cornerRadius =5;
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
    
    UIButton * saveButton = [Helper buttonWithTitleColor:[UIColor whiteColor] font:kPingFangRegular(18) backgroundColor:[UIColor orangeColor] title:@"保存"];
    saveButton.layer.borderColor = [UIColor clearColor].CGColor;
    saveButton.layer.borderWidth = 1;
    saveButton.layer.cornerRadius =10;
    [self.view addSubview:saveButton];
    [saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remarkTextView.mas_bottom).offset(50);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(kMainBoundsWidth - 100);
        make.height.mas_equalTo(40);
    }];
    
}

- (void)saveClick{
    
    [self  addNewReserveRequest];
    
}

- (void)contentLabClicked:(UIGestureRecognizer *)gesture{
    
    UIView *tapView = gesture.view;
    if (tapView.tag == 10003) {
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.blackView];
        
    }else if (tapView.tag == 10004){
        
        [self selectRoom];
        
    }
    
}

#pragma mark - 点击选择包间
- (void)selectRoom{
    
    ReserveSeRoomViewController *flVC = [[ReserveSeRoomViewController alloc] init];
    float version = [UIDevice currentDevice].systemVersion.floatValue;
    if (version < 8.0) {
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
    } else {;
        flVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    flVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    flVC.dataSource = self.roomSource;
    [self presentViewController:flVC animated:YES completion:nil];
    flVC.backDatas = ^(ReserveModel *tmpModel) {
        UILabel *tmpLabel = (UILabel *)[self.view viewWithTag:10004];
        if (!isEmptyString(tmpModel.name)) {
            tmpLabel.text = tmpModel.name;
            self.roomSourceModel = tmpModel;
        }else{
            tmpLabel.text = @"请选择预定包间";
        }
    };
    
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
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    [textField addSubview:lineView];
    lineView.backgroundColor =UIColorFromRGB(0xd7d7d7);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftView.frame.size.width);
        make.right.mas_equalTo(0.f);
        make.height.mas_equalTo(.5f);
        make.bottom.mas_equalTo(3.f);
    }];
    
    return textField;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.currentTextView = textView;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"备注，限制100字"]) {
        self.remarkTextView.textColor = [UIColor grayColor];
        textView.text = @"";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location < 100)
    {
        return  YES;
    } else  if ([textView.text isEqualToString:@"\n"]) {
        //这里写按了ReturnKey 按钮后的代码
        return NO;
    }
    if (textView.text.length == 100) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [textView resignFirstResponder];
    NSLog(@"%lu",textView.text.length);
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    [textView resignFirstResponder];
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"%@",textField.text);
    
    if (textField.tag == 10000) {
    }else if (textField.tag == 10001){
    }else if (textField.tag == 10002){
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 10000) {
        
        self.dataModel.order_name = textField.text;
        
    }else if (textField.tag == 10001){
        
        self.dataModel.order_mobile = textField.text;
        
    }else if (textField.tag == 10002){
        
        self.dataModel.person_nums = textField.text;
        
    }else if (textField.tag == 10003){
        
        self.dataModel.time_str = textField.text;
        
    }else if (textField.tag == 10004){
        
        self.dataModel.room_name = textField.text;
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
    
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
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *selectDateStr = [formatter stringFromDate:date];
    [self.blackView removeFromSuperview];
    
    UILabel *tmpLabel = (UILabel *)[self.view viewWithTag:10003];
    if (!isEmptyString(selectDateStr)) {
        tmpLabel.text = selectDateStr;
    }else{
        tmpLabel.text = @"请选择预定包间";
    }
}

- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kMainBoundsHeight / 3 * 2, kMainBoundsWidth, kMainBoundsHeight / 3)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.minimumDate = [NSDate date];
        _datePicker.backgroundColor = UIColorFromRGB(0xffffff);
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
