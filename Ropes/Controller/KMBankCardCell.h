//
//  KMBankCardCell.h
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/4/4.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMBankCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;

+ (instancetype)bankCardCellWithTableView:(UITableView *)tableView;
@end
