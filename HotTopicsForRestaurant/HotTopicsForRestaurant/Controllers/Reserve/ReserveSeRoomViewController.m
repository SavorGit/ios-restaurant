//
//  ReserveSeRoomViewController.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ReserveSeRoomViewController.h"

#import "RDBoxModel.h"
#import "AddNewRoomRequest.h"

#import "ReserveSelRoomCollectionViewCell.h"
#import "GetRoomListRequest.h"

@interface ReserveSeRoomViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextField *inPutTextField;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIButton * noDataButton;

@end

@implementation ReserveSeRoomViewController

- (instancetype)initWithArray:(NSMutableArray *)dataArray{
    
    if (self = [super init]) {
        self.dataSource = dataArray;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initInfo];
    [self creatSubViews];
}

- (void)initInfo{
    
    self.title = @"选择包间";
    self.view.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
    if (self.dataSource.count == 0) {
        [self getRoomListRequest];
    }
    
}

#pragma mark - 获取包间列表
- (void)getRoomListRequest{
    
    GetRoomListRequest * request = [[GetRoomListRequest alloc] initWithInviteId:[GlobalData shared].userModel.invite_id andMobile:[GlobalData shared].userModel.telNumber];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSArray *resultArr = [response objectForKey:@"result"];
        NSMutableArray *tmpArray = [NSMutableArray new];
        if (resultArr.count > 0) {
            for (int i = 0 ; i < resultArr.count ; i ++) {
                NSDictionary *tmpDic = resultArr[i];
                ReserveModel * tmpModel = [[ReserveModel alloc] initWithDictionary:tmpDic];
                [tmpArray addObject:tmpModel];
            }
            self.dataSource = tmpArray;
        }else{
            self.noDataButton.hidden = NO;
            self.noDataButton.userInteractionEnabled = NO;
            [self.noDataButton setTitle:@"当前没有包间列表，请手动添加" forState:UIControlStateNormal];
        }
       
        [self.collectionView reloadData];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
            self.noDataButton.hidden = NO;
            self.noDataButton.userInteractionEnabled = YES;
            [self.noDataButton setTitle:@"包间列表获取失败，点击重新加载" forState:UIControlStateNormal];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        [MBProgressHUD showTextHUDwithTitle:@"网络连接失败，请重试"];
        self.noDataButton.userInteractionEnabled = YES;
        [self.noDataButton setTitle:@"包间列表获取失败，点击重新加载" forState:UIControlStateNormal];
    }];
}

- (void)creatSubViews{
    
    CGFloat scale = kMainBoundsWidth/375.f;
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bgView.backgroundColor = UIColorFromRGB(0xece6de);
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,kMainBoundsHeight));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(0);
    }];
    
    UIView *inPutBgView = [[UIView alloc] init];
    inPutBgView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    [self.bgView addSubview:inPutBgView];
    [inPutBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth , 70));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 25)];
    leftView.backgroundColor = [UIColor clearColor];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    rightView.backgroundColor = [UIColor clearColor];
    
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, 60, 40);
    addBtn.backgroundColor = UIColorFromRGB(0x922c3e);
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    addBtn.titleLabel.font = kPingFangRegular(15);
    [addBtn setTitleColor:UIColorFromRGB(0xf6f2ed) forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:addBtn];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:addBtn.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(5,5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = addBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    addBtn.layer.mask = maskLayer;
    
    
    self.inPutTextField = [[UITextField alloc] init];
    self.inPutTextField.layer.cornerRadius = 5.f;
    self.inPutTextField.layer.borderWidth = .5f;
    self.inPutTextField.layer.borderColor = UIColorFromRGB(0xcecdcb).CGColor;
    self.inPutTextField.backgroundColor = UIColorFromRGB(0xece6de);
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"请手动添加列表中没有的包间" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x999999),
            NSFontAttributeName:kPingFangRegular(15)}];
    self.inPutTextField.attributedPlaceholder = attrString;
    self.inPutTextField.delegate = self;
    self.inPutTextField.returnKeyType = UIReturnKeyDone;
    self.inPutTextField.enablesReturnKeyAutomatically = YES;
    self.inPutTextField.leftView = leftView;
    self.inPutTextField.rightView = rightView;
    self.inPutTextField.leftViewMode = UITextFieldViewModeAlways;
    self.inPutTextField.rightViewMode = UITextFieldViewModeAlways;
    [inPutBgView addSubview:self.inPutTextField];
    [self.inPutTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 30 , 40));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    [self.inPutTextField addTarget:self action:@selector(infoTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 15.f;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(15.f *scale, 15 *scale, 15.f *scale, 15 *scale);
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.scrollEnabled =  YES;
    [self.bgView addSubview:_collectionView];
    [_collectionView registerClass:[ReserveSelRoomCollectionViewCell class] forCellWithReuseIdentifier:@"selectRoomCell"];
    CGFloat contentHeight = 0.f;
    if (kDevice_Is_iPhoneX) {
        contentHeight = kMainBoundsHeight - 64 - 75 - 25;
    }else{
        contentHeight = kMainBoundsHeight - 64 - 75;
    }
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,contentHeight));
        make.top.mas_equalTo(inPutBgView.mas_bottom).offset(5);
        make.left.mas_equalTo(0);
    }];
    
    self.noDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.noDataButton.backgroundColor = [UIColor clearColor];
    [self.noDataButton setTitle:@"当前没有包间列表，请手动添加" forState:UIControlStateNormal];
    self.noDataButton.titleLabel.font = kPingFangRegular(15);
    [self.noDataButton setTitleColor:UIColorFromRGB(0x434343) forState:UIControlStateNormal];
    [self.noDataButton addTarget:self action:@selector(noDataClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.noDataButton];
    [self.noDataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth , 20));
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view);
    }];
    self.noDataButton.hidden = YES;
    self.noDataButton.userInteractionEnabled = NO;
}

- (void)noDataClick{
    [self getRoomListRequest];
}

#pragma mark - 添加新包间
- (void)addBtnClicked{
    
    if (!isEmptyString(self.inPutTextField.text)) {
        [self addNewRoomRequest];
    }else{
        [MBProgressHUD showTextHUDwithTitle:@"包间名称不能为空"];
    }
}

# pragma mark - 添加包间
- (void)addNewRoomRequest{
    
    NSDictionary *parmDic = @{
                              @"invite_id":[GlobalData shared].userModel.invite_id,
                              @"mobile":[GlobalData shared].userModel.telNumber,
                              @"room_name": self.inPutTextField.text,
                              };
    [MBProgressHUD showLoadingWithText:@"提交数据" inView:self.view];
    AddNewRoomRequest * request = [[AddNewRoomRequest alloc] initWithPubData:parmDic];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[response objectForKey:@"code"] integerValue] == 10000) {
            
            NSDictionary *result = [response objectForKey:@"result"];
            ReserveModel *tmpModel = [[ReserveModel alloc] init];
            tmpModel.room_id = [result objectForKey:@"room_id"];
            tmpModel.room_type = [result objectForKey:@"room_type"];
            tmpModel.room_name = self.inPutTextField.text;
            if (self.backDatas) {
                self.backDatas(tmpModel);
                [self back];
            }
            
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }else{
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"保存失败，请重试"]];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDwithTitle:[response objectForKey:@"msg"]];
        }else{
            [MBProgressHUD showTextHUDwithTitle:@"保存失败，请重试"];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showTextHUDwithTitle:@"添加包间失败，请检查网络"];
        
    }];
}

#pragma mark - UICollectionView 代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ReserveSelRoomCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"selectRoomCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    ReserveModel *tmpModel = [self.dataSource objectAtIndex:indexPath.row];
    [cell configModelData:tmpModel];
    
    return cell;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (kMainBoundsWidth - 50) / 2;
    return CGSizeMake(width , 40);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ReserveSelRoomCollectionViewCell *tmpCell = (ReserveSelRoomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    tmpCell.titleLabel.backgroundColor = UIColorFromRGB(0x922c3e);
    tmpCell.titleLabel.textColor = UIColorFromRGB(0xf6f2ed);
    ReserveModel *tmpModel = self.dataSource[indexPath.row];
    if (self.backDatas) {
        self.backDatas(tmpModel);
    }
    [self back];
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

//允许屏幕旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

//返回当前屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
    
}

- (void)infoTextDidChange:(UITextField *)textField
{
    NSInteger kMaxLength = 10;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
