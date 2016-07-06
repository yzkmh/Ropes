//
//  KMNavigationView.m
//  Ropes
//
//  Created by yzk on 16/3/29.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMNavigationView.h"
#define HNavi 40

@interface KMNavigationView ()<UIScrollViewDelegate>
{

}
@end

@implementation KMNavigationView




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self initView];
    [self setUI];
    [self addTapGesture];
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

- (void)initView
{
    self.isLeft = YES;
}



- (void)setUI
{
    [self.showView setFrame:CGRectMake(0, HNavi, self.frame.size.width, self.frame.size.height-40)];
    
    [self.showView setContentSize:CGSizeMake(self.showView.frame.size.width*2, self.showView.frame.size.height)];
    
    self.showView.directionalLockEnabled = YES;
    self.showView.pagingEnabled = YES;
    
    self.showView.showsVerticalScrollIndicator = NO;
    self.showView.showsHorizontalScrollIndicator = NO;
    
    self.showView.bounces = NO;
    
    //self.showView.backgroundColor = [UIColor grayColor];
    
    [self.showView setDelegate:self];
    
}
- (void)addToShowView:(UIView *)obj
{
    [self.showView addSubview:obj];
}

- (void)setLabelWithConponNum1:(NSString *)num1 andNum2:(NSString *)num2
{
    self.leftLable.text = [NSString stringWithFormat:@"未过期的(%@)",num1];
    self.rightLable.text = [NSString stringWithFormat:@"已过期的(%@)",num2];
}

- (void)addTapGesture
{
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTapLabel:)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTapLabel1:)];
    [self.leftLable addGestureRecognizer:tap0];
    [self.rightLable setTag:1];
    [self.rightLable addGestureRecognizer:tap1];
    
}

- (void)actionTapLabel:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.showView setContentOffset:CGPointMake(0, 0)];
        [self.leftLable setTextColor:[UIColor redColor]];
        [self.rightLable setTextColor:[UIColor grayColor]];
        [self.progressView setFrame:CGRectMake(0, 32, self.frame.size.width/2, 1)];
    }];
    self.isLeft = YES;

}

- (void)actionTapLabel1:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.showView setContentOffset:CGPointMake(self.frame.size.width, 0)];
        [self.rightLable setTextColor:[UIColor redColor]];
        [self.leftLable setTextColor:[UIColor grayColor]];
        [self.progressView setFrame:CGRectMake(self.frame.size.width/2, 32, self.frame.size.width/2, 1)];
        
    }];
    self.isLeft = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView   {
    [self.progressView setFrame:CGRectMake(scrollView.contentOffset.x/2, 32, self.frame.size.width/2, 1)];
    if (scrollView.contentOffset.x < self.frame.size.width/2) {
        self.isLeft = YES;
        [self.leftLable setTextColor:[UIColor redColor]];
        [self.rightLable setTextColor:[UIColor grayColor]];
    }else{
        self.isLeft = NO;
        [self.leftLable setTextColor:[UIColor grayColor]];
        [self.rightLable setTextColor:[UIColor redColor]];
    }
}
@end
