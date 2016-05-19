//
//  KMHistoryCell.h
//  Ropes
//
//  Created by yzk on 16/5/12.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMHistoryCell : UITableViewCell
@property (nonatomic ,weak) IBOutlet UILabel *price;
@property (nonatomic ,weak) IBOutlet UILabel *address;
@property (nonatomic ,weak) IBOutlet UILabel *date;

@property (nonatomic ,weak) IBOutlet UILabel *useCount;
@property (nonatomic ,weak) IBOutlet UILabel *usedCount;

@property (nonatomic ,weak) NSString *tcode;

@end
