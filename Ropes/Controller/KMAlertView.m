//
//  KMAlertView.m
//  Ropes
//
//  Created by Madoka on 16/3/2.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMAlertView.h"

@implementation KMAlertView

- (instancetype)initWithFrame:(CGRect )frame andDelegate:(id<KMAlertViewDelegate>)delegate
{
    UIView *contentView = [self createContentView];
    
    if (self = [super init]) {
        self = (KMAlertView *)[[[NSBundle mainBundle] loadNibNamed:@"KMAlertView" owner:nil options:nil]objectAtIndex:0];
        self.frame = frame;
        self.center = SCREEN_CENTER;
        self.delegate = delegate;
    }
    [contentView addSubview:self];
    return (KMAlertView *)contentView;
}

- (UIView *)createContentView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = KMMainScreenBounds;
    [contentView setBackgroundColor:[UIColor clearColor]];
    UIView *backGroundView = [[UIView alloc] initWithFrame:KMMainScreenBounds];
    [backGroundView setBackgroundColor:[UIColor grayColor]];
    [backGroundView setAlpha:0.7];
    [contentView addSubview:backGroundView];
    return contentView;
}

- (IBAction)cancelBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(KMAlertView: clickedButtonAtIndex:)]) {
        [self.delegate KMAlertView:self clickedButtonAtIndex:0];
    }
}

- (IBAction)ensureBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(KMAlertView: clickedButtonAtIndex:)]) {
        [self.delegate KMAlertView:self clickedButtonAtIndex:1];
    }
}

@end
