//
//  KMTransactionTableViewCell.h
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/4/4.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMTransactionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *opertionType;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *opertionResult;
@property (weak, nonatomic) IBOutlet UILabel *moneyNum;

@end
