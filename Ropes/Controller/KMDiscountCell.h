//
//  KMDiscountCell.h
//  Ropes
//
//  Created by sunsea on 16/5/9.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMDiscountCell : UITableViewCell
@property (nonatomic ,weak) IBOutlet UILabel *title;
@property (nonatomic ,weak) IBOutlet UILabel *price;
@property (nonatomic ,weak) IBOutlet UILabel *state;
@property (nonatomic ,weak) IBOutlet UILabel *premise;
@property (nonatomic ,weak) IBOutlet UILabel *validDate;
@end
