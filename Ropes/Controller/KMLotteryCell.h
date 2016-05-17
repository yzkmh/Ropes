//
//  KMLotteryCell.h
//  Ropes
//
//  Created by yzk on 16/3/27.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMLotteryCell : UITableViewCell
@property (nonatomic ,weak) IBOutlet UILabel *title;
@property (nonatomic ,weak) IBOutlet UILabel *lotteryNum;
@property (nonatomic ,weak) IBOutlet UILabel *state;
@property (nonatomic ,weak) IBOutlet UILabel *LotteryDate;
@property (nonatomic ,weak) IBOutlet UILabel *validDate;

@end
