//
//  KMBankCardCell.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/4/4.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMBankCardCell.h"

@implementation KMBankCardCell
+ (instancetype)bankCardCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CoupnCellIdentifier";
    KMBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KMBankCardCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
@end
