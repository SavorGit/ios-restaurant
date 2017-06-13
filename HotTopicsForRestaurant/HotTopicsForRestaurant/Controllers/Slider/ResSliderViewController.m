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

@end

@implementation ResSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isNeedPush = NO;
    [self createDataSource];
    [self createUI];
    
    UIImageView *navigationImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    self.navBarHairlineImageView = navigationImageView;
    [self.navBarHairlineImageView setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
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
        [Helper showTextHUDwithTitle:@"最多只能创建50组幻灯片" delay:1.5f];
    }
    
    ResAddSliderViewController * add = [[ResAddSliderViewController alloc] initWithSliderModel:nil block:^(NSDictionary *item) {
        ResSliderLibraryModel * model = [[ResSliderLibraryModel alloc] init];
        model.title = [item objectForKey:@"resSliderTitle"];
        model.createTime = [item objectForKey:@"resSliderUpdateTime"];
        model.assetIds = [item objectForKey:@"resSliderIds"];
        [self.dataSource insertObject:model atIndex:0];
        [self.tableView reloadData];
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
        [self.tableView reloadData];
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
    [self.navBarHairlineImageView setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
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
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:add animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [self.navBarHairlineImageView setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
}

-(UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
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
