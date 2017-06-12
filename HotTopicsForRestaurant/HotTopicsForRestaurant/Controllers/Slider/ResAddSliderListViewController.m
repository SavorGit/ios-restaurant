//
//  ResAddSliderListViewController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/6/12.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResAddSliderListViewController.h"
#import "ResPhotoCollectionViewCell.h"
#import "RestaurantPhotoTool.h"

@interface ResAddSliderListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray * selectArray;
@property (nonatomic, strong) PHFetchResult * dataSource;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) ResPhotoLibraryModel * model;
@property (nonatomic, strong) UIToolbar * bottomView; //底部控制栏
@property (nonatomic, strong) UIButton * chooseButton;
@property (nonatomic, strong) ResSliderLibraryModel * sliderModel;
@property (nonatomic, assign) NSInteger currentNum;
@property (nonatomic, assign) BOOL isAllChoose; //记录当前的全选状态
@property (nonatomic, copy) void(^block)(NSDictionary * item);

@end

@implementation ResAddSliderListViewController

- (instancetype)initWithModel:(ResPhotoLibraryModel *)model sliderModel:(ResSliderLibraryModel *)sliderModel block:(void (^)(NSDictionary *))block
{
    if (self = [super init]) {
        self.dataSource = model.result;
        self.model = model;
        self.sliderModel = sliderModel;
        if (self.sliderModel) {
            self.currentNum = self.sliderModel.assetIds.count;
        }else{
            self.currentNum = 0;
        }
        self.isAllChoose = NO;
        self.block = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createDataSource];
    [self createUI];
}

- (void)createDataSource
{
    self.selectArray = [NSMutableArray new];
}

- (void)createUI
{
    self.title = self.model.title;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStyleDone target:self action:@selector(allChoose)];
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CollectionViewCellSize;
    flowLayout.minimumInteritemSpacing = 3;
    flowLayout.minimumLineSpacing = 3;
    flowLayout.sectionInset = UIEdgeInsetsMake(3, 5, 50, 5);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[ResPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    self.bottomView = [[UIToolbar alloc] init];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 50));
    }];
    self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chooseButton setFrame:CGRectMake(0, 0, kMainBoundsWidth, 50)];
    [self.chooseButton setBackgroundColor:[UIColor clearColor]];
    [self.chooseButton setTitle:@"请先选择图片" forState:UIControlStateNormal];
    [self.chooseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.chooseButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.chooseButton addTarget:self action:@selector(addPhotoToLibrary) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.chooseButton];
    self.chooseButton.userInteractionEnabled = NO;
}

- (void)allChoose
{
    NSInteger maxNumber = self.dataSource.count > kMAXPhotoNum - self.currentNum ? kMAXPhotoNum - self.currentNum : self.dataSource.count;
    
    NSInteger i = 0;
    while (i < maxNumber) {
        i++;
        if (i > self.dataSource.count) {
            break;
        }
        PHAsset * asset = [self.dataSource objectAtIndex:self.dataSource.count - i];
        if ([self.selectArray containsObject:asset]) {
            continue;
        }else{
            [self.selectArray addObject:asset];
        }
        if (self.selectArray.count >= 50) {
            break;
        }
    }
    self.isAllChoose = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消全选" style:UIBarButtonItemStyleDone target:self action:@selector(cancleAllChoose)];
    [self.collectionView reloadData];
    [self updateChooseStatus];
}

//取消全选
- (void)cancleAllChoose
{
    [self.selectArray removeAllObjects];
    self.isAllChoose = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStyleDone target:self action:@selector(allChoose)];
    [self.collectionView reloadData];
    [self updateChooseStatus];
}

- (void)addPhotoToLibrary
{
    //开始添加
    
    NSMutableArray * assetIds = [NSMutableArray new];
    for (NSInteger i = 0; i < self.selectArray.count; i++) {
        PHAsset * asset = [self.selectArray objectAtIndex:i];
        [assetIds addObject:asset.localIdentifier];
    }
    
    if (assetIds.count > 0) {
        if (self.sliderModel) {
            
            NSMutableArray * array = [NSMutableArray arrayWithArray:self.sliderModel.assetIds];
            [array addObjectsFromArray:assetIds];
            [RestaurantPhotoTool updateSliderItemWithIDArray:array andTitle:self.sliderModel.title success:^(NSDictionary *item) {
                [Helper showTextHUDwithTitle:@"添加成功" delay:1.5f];
                self.block(item);
                
                UIViewController * vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
                [self.navigationController popToViewController:vc animated:YES];
                
            } failed:^(NSError *error) {
                [Helper showTextHUDwithTitle:[error.userInfo objectForKey:@"msg"] delay:1.5f];
            }];
            
        }else{
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"新建幻灯片" message:@"为此幻灯片输入名称" preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"请输入名称";
                //添加监听，用户监听输入框字数
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
            }];
            UIAlertAction * leftAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
            }];
            UIAlertAction * rightAction = [UIAlertAction actionWithTitle:@"创建" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
                
                UITextField * textFiled = [alert.textFields firstObject];
                NSString * title = textFiled.text;
                
                [RestaurantPhotoTool addSliderItemWithIDArray:assetIds andTitle:title success:^(NSDictionary *item) {
                    [Helper showTextHUDwithTitle:@"创建成功" delay:1.5f];
                    self.block(item);
                    UIViewController * vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
                    [self.navigationController popToViewController:vc animated:YES];
                } failed:^(NSError *error) {
                    [Helper showTextHUDwithTitle:[error.userInfo objectForKey:@"msg"] delay:1.5f];
                }];
            }];
            rightAction.enabled = NO;
            [alert addAction:leftAction];
            [alert addAction:rightAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }else{
        [Helper showTextHUDwithTitle:@"没有可以添加的照片" delay:1.5f];
    }
    
    //添加完成
}

//只有字数大于0时才能进行幻灯片创建
- (void)alertTextFieldDidChange
{
    UIAlertController * alert = (UIAlertController *)self.presentedViewController;
    UITextField * textFiled = [alert.textFields firstObject];
    UIAlertAction * action = [alert.actions lastObject];
    if (textFiled.text.length > 0) {
        action.enabled = YES;
        if (textFiled.text.length > 20) {
            textFiled.text = [textFiled.text substringToIndex:20];
            [Helper showTextHUDwithTitle:@"最多输入20个字符" delay:1.5f];
        }
    }else{
        action.enabled = NO;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ResPhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    PHAsset * currentAsset = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithPHAsset:currentAsset completionHandle:^(PHAsset *asset, BOOL isSelect) {
        
        if (isSelect) {
            if (![self.selectArray containsObject:asset]) {
                if (self.selectArray.count + self.currentNum >= kMAXPhotoNum) {
                    [cell configSelectStatus:NO];
                    [Helper showTextHUDwithTitle:@"最多只能选择50张" delay:1.5f];
                    return;
                }
                [self.selectArray addObject:asset];
            }
        }else{
            if ([self.selectArray containsObject:asset]) {
                [self.selectArray removeObject:asset];
                self.isAllChoose = NO;
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStyleDone target:self action:@selector(allChoose)];
            }
        }
        [self updateChooseStatus];
    }];
    
    
    if ([self.selectArray containsObject:currentAsset]) {
        [cell configSelectStatus:YES];
    }else{
        [cell configSelectStatus:NO];
    }
    
    return cell;
}

- (void)updateChooseStatus
{
    if (self.selectArray.count == 0) {
        self.title = self.model.title;
        [self.chooseButton setTitle:@"请先选择图片" forState:UIControlStateNormal];
        [self.chooseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.chooseButton.userInteractionEnabled = NO;
    }else{
        self.title = [NSString stringWithFormat:@"%@(%ld/%d)", self.model.title, self.selectArray.count + self.currentNum, kMAXPhotoNum];
        if (self.sliderModel) {
            [self.chooseButton setTitle:[NSString stringWithFormat:@"添加至幻灯片 '%@'", self.sliderModel.title] forState:UIControlStateNormal];
        }else{
            [self.chooseButton setTitle:@"创建幻灯片" forState:UIControlStateNormal];
        }
        [self.chooseButton setTitleColor:UIColorFromRGB(0xc49053) forState:UIControlStateNormal];
        self.chooseButton.userInteractionEnabled = YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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
