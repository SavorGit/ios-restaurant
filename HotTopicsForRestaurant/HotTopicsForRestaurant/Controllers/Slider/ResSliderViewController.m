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

@interface ResSliderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation ResSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createDataSource];
    [self createUI];
}

- (void)createUI
{
    self.title = @"幻灯片";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createSlider)];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}

- (void)createDataSource
{
    self.dataSource = [NSMutableArray arrayWithArray:[RestaurantPhotoTool getSliderList]];
    
}

- (void)createSlider
{
    ResAddSliderViewController * add = [[ResAddSliderViewController alloc] init];
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
    PHAsset * asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[[model.assetIds firstObject]]options:nil].firstObject;
    
    if (asset) {
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.synchronous = YES;
        option.resizeMode = PHImageRequestOptionsResizeModeExact;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [cell.imageView setImage:[RestaurantPhotoTool makeThumbnailOfSize:CGSizeMake(70, 70) image:result]];
        }];
    }else{
        [cell.imageView setImage:[UIImage imageNamed:@"SliderNULL"]];
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
    ResSliderListViewController * add = [[ResSliderListViewController alloc] initWithSliderModel:model];
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
