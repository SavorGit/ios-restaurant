//
//  CustomDateView.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "CustomDateView.h"

@interface CustomDateView ()

@property (nonatomic, strong) NSMutableArray *dayArr;
@property (nonatomic, strong) NSMutableArray *dateArr;
@property (nonatomic, strong) NSMutableArray *bottomLineArr;
@property (nonatomic, strong) NSArray *dateSource;

@end

@implementation CustomDateView

- (instancetype)initWithData:(NSArray *)data handler:(void (^)())handler
{
    if (self = [super init]) {
        
        
        self.frame = CGRectMake(0, 0, kMainBoundsWidth, 87.5);
        self.dayArr = [NSMutableArray new];
        self.dateArr = [NSMutableArray new];
        self.bottomLineArr = [NSMutableArray new];
        
        self.block = handler;
        self.dateSource = data;
        [self creatSubView];
    }
    return self;
}

- (void)creatSubView{
    
    float distance = (self.frame.size.width - 80 *4)/8;
    float labelH = 43.75;
    for (int i = 0; i < self.dateSource.count; i ++) {
        
        ReserveModel *tmpModel = self.dateSource[i];
        
        UILabel *dayLabel = [Helper labelWithFrame:CGRectMake(distance + i *80 + i *distance *2, 23, 80, labelH - 23) TextColor:UIColorFromRGB(0x434343) font:kPingFangMedium(16) alignment:NSTextAlignmentCenter];
        dayLabel.text = [NSString stringWithFormat:@"%@(%@)",tmpModel.personDay,tmpModel.dishNum];
        dayLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:dayLabel];
        
        UILabel *dateLabel = [Helper labelWithFrame:CGRectMake(distance + i *80 + i *distance *2, labelH, 80, labelH - 23) TextColor:UIColorFromRGB(0x666666) font:kPingFangRegular(14) alignment:NSTextAlignmentCenter];
        dateLabel.text = tmpModel.displayDay;
        dateLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:dateLabel];
        
        UIButton *clickBtn = [Helper buttonWithTitleColor:[UIColor clearColor] font:nil backgroundColor:[UIColor clearColor] title:@""];
        clickBtn.tag = i;
        clickBtn.frame = CGRectMake(distance + i *80 + i *distance*2, 0, 80, labelH * 2);
        [clickBtn addTarget:self action:@selector(clickPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clickBtn];
        
        if (i != 0) {
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = UIColorFromRGB(0xe1dbd4);
            lineView.frame = CGRectMake(kMainBoundsWidth/4 *i,5 ,1 ,77.5 );
            [self addSubview:lineView];
        }
        
        UIView *redBottomLine = [[UIView alloc] init];
        redBottomLine.backgroundColor = UIColorFromRGB(0x922c3e);
        redBottomLine.frame = CGRectMake(kMainBoundsWidth/4 *i, labelH *2 -2 ,kMainBoundsWidth/4 ,2 );
        [self addSubview:redBottomLine];
        redBottomLine.hidden = YES;
        
        [self.dayArr addObject:dayLabel];
        [self.dateArr addObject:dateLabel];
        [self.bottomLineArr addObject:redBottomLine];
    }
    
}

- (void)clickPress:(UIButton *)btn
{
    for (int i = 0; i < self.dayArr.count;  i ++) {
        
        UILabel *dayLab = self.dayArr[i];
        UILabel *dateLab = self.dateArr[i];
        UIView  *lineView = self.bottomLineArr[i];
        if (i == btn.tag) {
            dayLab.textColor = UIColorFromRGB(0x922c3e);
            dateLab.textColor = UIColorFromRGB(0x922c3e);
            lineView.hidden = NO;
        }else{
            dayLab.textColor = UIColorFromRGB(0x434343);
            dateLab.textColor = UIColorFromRGB(0x666666);
            lineView.hidden = YES;
        }
    }
    
    self.block(self.dateSource[btn.tag]);
    
}

- (void)configSelectWithTag:(NSInteger )tag{
    
    UILabel *dayLab = self.dayArr[tag];
    UILabel *dateLab = self.dateArr[tag];
    UIView  *lineView = self.bottomLineArr[tag];
    dayLab.textColor = UIColorFromRGB(0x922c3e);
    dateLab.textColor = UIColorFromRGB(0x922c3e);
    lineView.hidden = NO;
    
}

- (void)refreshDayNum:(NSArray *)numArray{
    
    for (int i = 0; i < self.dayArr.count;  i ++) {
        ReserveModel *tmpModel = numArray[i];
        UILabel *dayLab = self.dayArr[i];
        dayLab.text = [NSString stringWithFormat:@"%@(%@)",tmpModel.personDay,tmpModel.dishNum];
    }
}

@end
