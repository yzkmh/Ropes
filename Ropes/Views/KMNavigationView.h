//
//  KMNavigationView.h
//  Ropes
//
//  Created by yzk on 16/3/29.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KMNavigationViewDelegate <NSObject>

- (void)didSelectAtIndex:(NSInteger)index;


@end


@interface KMNavigationView : UIView
@property (nonatomic ,weak) IBOutlet UILabel *leftLable;
@property (nonatomic ,weak) IBOutlet UILabel *rightLable;
@property (nonatomic ,weak) IBOutlet UIView *progressView;

@property (nonatomic ,weak) IBOutlet UIScrollView *showView;
@property (nonatomic ,assign) BOOL isLeft;

- (void)addToShowView:(UIView *)obj;
- (void)setLabelWithConponNum1:(NSString *)num1 andNum2:(NSString *)num2;


@end
