//
//  KMAlertView.h
//  Ropes
//
//  Created by Madoka on 16/3/2.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KMAlertView;

@protocol KMAlertViewDelegate <NSObject>
- (void)KMAlertView:(KMAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end


@interface KMAlertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

@property (weak, nonatomic) id<KMAlertViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect )frame andDelegate:(id<KMAlertViewDelegate>)delegate;
@end
