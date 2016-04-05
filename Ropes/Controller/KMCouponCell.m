//
//  KMCouponCell.m
//  Ropes
//
//  Created by yzk on 16/3/26.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMCouponCell.h"

@implementation KMCouponCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)couponCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CoupnCellIdentifier";
    KMCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KMCouponCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
@end
