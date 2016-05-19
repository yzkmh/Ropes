//
//  KMVoucherCell.h
//  Ropes
//
//  Created by yzk on 16/4/6.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMVoucherCell : UITableViewCell
@property (nonatomic ,weak) IBOutlet UILabel *title;
@property (nonatomic ,weak) IBOutlet UILabel *banlance;
@property (nonatomic ,weak) IBOutlet UILabel *price;
@property (nonatomic ,weak) IBOutlet UILabel *state;
@property (nonatomic ,weak) IBOutlet UILabel *premise;
@property (nonatomic ,weak) IBOutlet UILabel *validDate;
@end
