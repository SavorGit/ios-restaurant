//
//  ResSliderViewController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/6/12.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResSliderViewController.h"
#import "RestaurantPhotoTool.h"
#import "ResSliderLibraryModel.h"
#import "ResAddSliderViewController.h"
#import "ResSliderListViewController.h"

static NSInteger sliderMaxNum = 50;

@interface ResSliderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, assign) BOOL isNeedPush;
@property (nonatomic, strong) UIView * firstView;

@end

@implementation ResSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isNeedPush = NO;
    [self createDataSource];
    [self createUI];
}

- (void)reloadData
{
    [self.tableView reloadData];
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

- (void)createUI
{
    self.title = @"幻灯片";
    
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
    label.text = [NSString stringWithFormat:@"最多可以创建%ld组幻灯片", sliderMaxNum];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:FontSizeDefault];
    self.tableView.tableFooterView = label;
    
    [self reloadData];
}

- (void)createDataSource
{
    NSArray * array = [RestaurantPhotoTool getSliderList];
    
    if (array) {
        self.dataSource = [NSMutableArray arrayWithArray:array];
    }else{
        self.dataSource = [NSMutableArray new];
    }
}

- (void)createSlider
{
    if (self.dataSource.count > sliderMaxNum) {
        [Helper showTextHUDwithTitle:@"最多可以创建50个幻灯片" delay:1.5f];
    }
    
    ResAddSliderViewController * add = [[ResAddSliderViewController alloc] initWithSliderModel:nil block:^(NSDictionary *item) {
        ResSliderLibraryModel * model = [[ResSliderLibraryModel alloc] init];
        model.title = [item objectForKey:@"resSliderTitle"];
        model.createTime = [item objectForKey:@"resSliderUpdateTime"];
        model.assetIds = [item objectForKey:@"resSliderIds"];
        [self.dataSource insertObject:model atIndex:0];
        [self reloadData];
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
    
    ResSliderLibraryModel * model = [self.dataSource objectAtIndex:indexPath.row];
    PHAsset * asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[[model.assetIds firstObject]] options:nil].firstObject;
    
    if (asset) {
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)", model.title, (unsigned long)model.assetIds.count];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"更新日期: %@", model
                                 .createTime];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResSliderLibraryModel * model = [self.dataSource objectAtIndex:indexPath.row];
    ResSliderListViewController * add = [[ResSliderListViewController alloc] initWithSliderModel:model block:^(NSDictionary *item) {
        if (nil == item) {
            [self.dataSource removeObject:model];
        }else{
            [model.assetIds removeAllObjects];
            [model.assetIds addObjectsFromArray:[item objectForKey:@"resSliderIds"]];
        }
        [self reloadData];
    }];
    [self.navigationController pushViewController:add animated:YES];
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
        
        ResSliderLibraryModel * model = [self.dataSource objectAtIndex:indexPath.row];
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确认删除幻灯片\"%@\"", model.title] message:@"相片将不会从本地删除" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * removeAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [RestaurantPhotoTool removeSliderItemWithTitle:model.title success:^(NSDictionary *item) {
                [self.dataSource removeObject:model];
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [self.tableView endUpdates];
                if (self.dataSource.count == 0) {
                    [self reloadData];
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

- (void)viewWillAppear:(BOOL)animated
{
    if (self.isNeedPush) {
        self.isNeedPush = NO;
        ResSliderLibraryModel * model = [self.dataSource objectAtIndex:0];
        ResSliderListViewController * add = [[ResSliderListViewController alloc] initWithSliderModel:model block:^(NSDictionary *item) {
            if (nil == item) {
                [self.dataSource removeObject:model];
            }else{
                [model.assetIds removeAllObjects];
                [model.assetIds addObjectsFromArray:[item objectForKey:@"resSliderIds"]];
            }
            [self reloadData];
        }];
        [self.navigationController pushViewController:add animated:YES];
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
        label.text = @"去创建您的第一个幻灯片吧~";
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
