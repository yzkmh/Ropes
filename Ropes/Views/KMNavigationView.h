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

- (void)addToShowView:(UIView *)obj;


@end
