//
//  ResVideoViewController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/11/17.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResVideoViewController.h"
#import "RestaurantPhotoTool.h"
#import "ResSliderVideoModel.h"
#import "ResAddVideoListViewController.h"
#import "ResVideoListViewController.h"

static NSInteger videoMaxNum = 50;

@interface ResVideoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, assign) BOOL isNeedPush;
@property (nonatomic, strong) UIView * firstView;

@end

@implementation ResVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createDataSource];
    // Do any additional setup after loading the view.
    
    self.title = @"视频列表";
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        BOOL needUpdate = NO;
        for (NSInteger i = self.dataSource.count - 1; i >= 0; i--) {
            ResSliderVideoModel * model = [self.dataSource objectAtIndex:i];
            PHFetchResult * result = [PHAsset fetchAssetsWithLocalIdentifiers:model.assetIds options:nil];
            if (result.count == 0) {
                [self.dataSource removeObjectAtIndex:i];
                [RestaurantPhotoTool removeSliderVideoItemWithTitle:model.title success:^(NSDictionary *item) {
                    
                } failed:^(NSError *error) {
                    
                }];
                needUpdate = YES;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createUI];
            [self checkIsNeedFirstView];
            //            [hud hideAnimated:NO];
        });
    });
}

- (void)checkIsNeedFirstView
{
    if (self.dataSource.count == 0) {
        [self.view addSubview:self.firstView];
        [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        [self.firstView removeFromSuperview];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createSlider)];
    }
}

- (void)createDataSource
{
    NSArray * array = [RestaurantPhotoTool getVideoList];
    
    if (array) {
        self.dataSource = [NSMutableArray arrayWithArray:array];
    }else{
        self.dataSource = [NSMutableArray new];
    }
}

- (void)createUI
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createSlider)];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 60)];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 0.5f)];
    view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.8f];
    [label addSubview:view];
    label.text = [NSString stringWithFormat:@"最多可以创建%ld组视频列表", videoMaxNum];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:FontSizeDefault];
    self.tableView.tableFooterView = label;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)setUpDataSourceWithComplete:(void (^)(BOOL needUpdate))finished
{
    BOOL needUpdate = NO;
    for (NSInteger i = self.dataSource.count - 1; i >= 0; i--) {
        ResSliderVideoModel * model = [self.dataSource objectAtIndex:i];
        PHFetchResult * result = [PHAsset fetchAssetsWithLocalIdentifiers:model.assetIds options:nil];
        if (result.count == 0) {
            [self.dataSource removeObjectAtIndex:i];
            [RestaurantPhotoTool removeSliderVideoItemWithTitle:model.title success:^(NSDictionary *item) {
                
            } failed:^(NSError *error) {
                
            }];
            needUpdate = YES;
        }
    }
    finished(needUpdate);
}

- (void)reloadData
{
    __weak typeof(self) weakSelf = self;
    [self setUpDataSourceWithComplete:^(BOOL needUpdate) {
        if (needUpdate) {
            [weakSelf.tableView reloadData];
            [weakSelf checkIsNeedFirstView];
        }
    }];
}

- (void)createSlider
{
    if (self.dataSource.count >= videoMaxNum) {
        [Helper showTextHUDwithTitle:@"最多可以创建50个幻灯片" delay:1.5f];
        return;
    }

    ResAddVideoListViewController * add = [[ResAddVideoListViewController alloc] initWithModel:nil block:^(NSDictionary *item) {
        ResSliderVideoModel * model = [[ResSliderVideoModel alloc] init];
        model.title = [item objectForKey:@"resSliderVideoTitle"];
        model.createTime = [item objectForKey:@"resSliderVideoUpdateTime"];
        model.assetIds = [item objectForKey:@"resSliderVideoIds"];
        [self.dataSource insertObject:model atIndex:0];
        [self.tableView reloadData];
        [self checkIsNeedFirstView];
        self.isNeedPush = YES;
    }];
    [self.navigationController pushViewController:add animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.imageView setContentMode:UIViewContentModeScaleToFill];
    }
    
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    ResSliderVideoModel * model = [self.dataSource objectAtIndex:indexPath.row];
    
    PHFetchResult * result = [PHAsset fetchAssetsWithLocalIdentifiers:model.assetIds options:nil];
    
    if (result.count > 0) {
        PHAsset * asset = [result objectAtIndex:0];
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.synchronous = YES;
        option.resizeMode = PHImageRequestOptionsResizeModeExact;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [cell.imageView setImage:[RestaurantPhotoTool makeThumbnailOfSize:CGSizeMake(70, 70) image:result]];
        }];
    }else{
        [cell.imageView setImage:[RestaurantPhotoTool makeThumbnailOfSize:CGSizeMake(70, 70) image:[UIImage imageNamed:@"tpysc"]]];
    }
    
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    NSString * title = [NSString stringWithFormat:@"%@ (%ld)", model.title, (unsigned long)model.assetIds.count];
    title = [title stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    cell.textLabel.text = title;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"更新日期: %@", model
                                 .createTime];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResSliderVideoModel * model = [self.dataSource objectAtIndex:indexPath.row];
    ResVideoListViewController * vc = [[ResVideoListViewController alloc] initWithModel:model block:^(NSDictionary *item) {
        if (nil == item) {
            [self.dataSource removeObject:model];
        }else{
            [model.assetIds removeAllObjects];
            NSArray * idArray = [item objectForKey:@"resSliderVideoIds"];
            if (idArray.count > 0) {
                [model.assetIds addObjectsFromArray:idArray];
            }
        }
        [self.tableView reloadData];
        [self checkIsNeedFirstView];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.frame.size.height / 5;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//返回cell的编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView setEditing:NO animated:YES];
        
        ResSliderVideoModel * model = [self.dataSource objectAtIndex:indexPath.row];
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确认删除视频列表\"%@\"", model.title] message:@"视频将不会从本地删除" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * removeAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [RestaurantPhotoTool removeSliderVideoItemWithTitle:model.title success:^(NSDictionary *item) {
                [self.dataSource removeObject:model];
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [self.tableView endUpdates];
                if (self.dataSource.count == 0) {
                    [self checkIsNeedFirstView];
                }
            } failed:^(NSError *error) {
                [Helper showTextHUDwithTitle:[error.userInfo objectForKey:@"msg"] delay:1.5f];
            }];
        }];
        [alert addAction:cancleAction];
        [alert addAction:removeAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (UIView *)firstView
{
    if (!_firstView) {
        _firstView = [[UIView alloc] initWithFrame:self.view.bounds];
        
        UIImageView * imageView = [[UIImageView alloc] init];
        [imageView setImage:[UIImage imageNamed:@"hdp_kong"]];
        [_firstView addSubview:imageView];
        _firstView.backgroundColor = VCBackgroundColor;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(-(kScreen_Width - 70) / 3);
            make.size.mas_equalTo(CGSizeMake(125, 97));
        }];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = UIColorFromRGB(0x444444);
        label.text = @"去创建您的第一个视频列表吧~";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:17];
        [_firstView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.equalTo(imageView.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 40));
        }];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:UIColorFromRGB(0xff743e) forState:UIControlStateNormal];
        button.layer.borderColor = UIColorFromRGB(0xff743e).CGColor;
        button.layer.borderWidth = 1.f;
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        [button setTitle:@"去创建" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button addTarget:self action:@selector(createSlider) forControlEvents:UIControlEventTouchUpInside];
        [_firstView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.equalTo(label.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(65, 28));
        }];
    }
    return _firstView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
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
