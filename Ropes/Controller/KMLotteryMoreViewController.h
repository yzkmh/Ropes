//
//  KMLotteryMoreViewController.h
//  Ropes
//
//  Created by yzk on 16/4/2.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMLottery.h"

@interface KMLotteryMoreViewController : UIViewController

@property (nonatomic ,weak) IBOutlet UIView *showView;
@property (nonatomic ,weak) IBOutlet UILabel *titleLb;
@property (nonatomic ,weak) IBOutlet UILabel *lotteryNumLb;
@property (nonatomic ,weak) IBOutlet UILabel *winningLvLb;
@property (nonatomic ,weak) IBOutlet UILabel *lotteryTermLb;
@property (nonatomic ,weak) IBOutlet UILabel *openDateLb;
@property (nonatomic ,weak) IBOutlet UILabel *usableDateLb;
@property (nonatomic ,weak) IBOutlet UILabel *receiveDateLb;

@property (nonatomic ,strong) KMLottery *lottery;

@end
