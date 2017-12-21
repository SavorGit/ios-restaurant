//
//  CustomDateView.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "CustomDateView.h"
#import "Helper.h"

@interface CustomDateView ()

@property (nonatomic, strong) NSMutableArray *dayArr;
@property (nonatomic, strong) NSMutableArray *dateArr;
@property (nonatomic, strong) NSArray *dateSource;

@end

@implementation CustomDateView

- (instancetype)initWithData:(NSArray *)data handler:(void (^)())handler
{
    if (self = [super init]) {
        
        
        self.frame = CGRectMake(0, 0, kMainBoundsWidth, 60);
        self.dayArr = [NSMutableArray new];
        self.dateArr = [NSMutableArray new];
        
        self.block = handler;
        self.dateSource = data;
        [self creatSubView];
    }
    return self;
}

- (void)creatSubView{
    
    float distance = (self.frame.size.width - 80 *4)/5;
    float labelH = 30;
    for (int i = 0; i < self.dateSource.count; i ++) {
        
        ReserveModel *tmpModel = self.dateSource[i];
        
        UILabel *dayLabel = [Helper labelWithFrame:CGRectMake(distance + i *80 + i *distance, 0, 80, labelH) TextColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] alignment:NSTextAlignmentCenter];
        dayLabel.text = [NSString stringWithFormat:@"%@(%@)",tmpModel.personDay,tmpModel.dishNum];
        [self addSubview:dayLabel];
        
        UILabel *dateLabel = [Helper labelWithFrame:CGRectMake(distance + i *80 + i *distance, 20, 80, labelH) TextColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] alignment:NSTextAlignmentCenter];
        dateLabel.text = tmpModel.displayDay;
        [self addSubview:dateLabel];
        
        UIButton *clickBtn = [Helper buttonWithTitleColor:[UIColor clearColor] font:nil backgroundColor:[UIColor clearColor] title:@""];
        clickBtn.tag = i;
        clickBtn.frame = CGRectMake(distance + i *80 + i *distance, 0, 80, labelH * 2);
        [clickBtn addTarget:self action:@selector(clickPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clickBtn];
        
        if (i != 0) {
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = [UIColor lightGrayColor];
            lineView.frame = CGRectMake(kMainBoundsWidth/4 *i,5 ,1 ,50 );
            [self addSubview:lineView];
        }
        
        [self.dayArr addObject:dayLabel];
        [self.dateArr addObject:dateLabel];
    }
    
}

- (void)clickPress:(UIButton *)btn
{
    for (int i = 0; i < self.dayArr.count;  i ++) {
        
        UILabel *dayLab = self.dayArr[i];
        UILabel *dateLab = self.dateArr[i];
        if (i == btn.tag) {
            dayLab.textColor = [UIColor orangeColor];
            dateLab.textColor = [UIColor orangeColor];
        }else{
            dayLab.textColor = [UIColor blackColor];
            dateLab.textColor = [UIColor blackColor];
        }
    }
    
    self.block(self.dateSource[btn.tag]);
    
}

- (void)configSelectWithTag:(NSInteger )tag{
    
    UILabel *dayLab = self.dayArr[tag];
    UILabel *dateLab = self.dateArr[tag];
    dayLab.textColor = [UIColor orangeColor];
    dateLab.textColor = [UIColor orangeColor];
    
}

@end
