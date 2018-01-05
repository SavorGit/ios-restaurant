//
//  CustomerLevelList.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/26.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "CustomerLevelList.h"

@interface CustomerLevelList()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation CustomerLevelList

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createCustomerLevelListView];
        
    }
    return self;
}

- (void)createCustomerLevelListView
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6f];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CustomerLevelListCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(self.frame.size.width / 3.f * 2.f);
        make.height.mas_equalTo(self.frame.size.height / 3.f * 2.f);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"请选择消费能力";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [GlobalData shared].customerLevelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerLevelListCell" forIndexPath:indexPath];
    
    NSDictionary * dict = [[GlobalData shared].customerLevelList objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"name"];
    cell.textLabel.font = kPingFangRegular(15);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(customerLevelDidSelect:)]) {
        NSDictionary * dict = [[GlobalData shared].customerLevelList objectAtIndex:indexPath.row];
        [_delegate customerLevelDidSelect:dict];
        [self removeFromSuperview];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self removeFromSuperview];
}

@end
