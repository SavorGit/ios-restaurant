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

#import "SelectRoomCollectionCell.h"

@interface ReserveSeRoomViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextField *inPutTextField;

@end

@implementation ReserveSeRoomViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initInfo];
    [self creatSubViews];
}

- (void)initInfo{
    
    self.title = @"选择包间";
    self.view.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
//        self.dataSource = [NSMutableArray new];
//        for (int i = 0 ; i < 18; i ++) {
//            RDBoxModel * tmpModel = [[RDBoxModel alloc] init];
//            tmpModel.sid = @"房间号";
//            [self.dataSource addObject:tmpModel];
//        }
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
    [_collectionView registerClass:[SelectRoomCollectionCell class] forCellWithReuseIdentifier:@"selectRoomCell"];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,kMainBoundsHeight - 64 - 50 *scale));
        make.top.mas_equalTo(inPutBgView.mas_bottom).offset(5);
        make.left.mas_equalTo(0);
    }];
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

#pragma mark - UICollectionView 代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SelectRoomCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"selectRoomCell" forIndexPath:indexPath];
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
    
    SelectRoomCollectionCell *tmpCell = (SelectRoomCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
