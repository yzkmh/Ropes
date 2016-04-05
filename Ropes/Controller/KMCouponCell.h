//
//  KMCouponCell.h
//  Ropes
//
//  Created by yzk on 16/3/26.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMCouponCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *e_typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *usableNum;
@property (weak, nonatomic) IBOutlet UILabel *outdateNum;

+ (instancetype)couponCellWithTableView:(UITableView *)tableView;
@end
