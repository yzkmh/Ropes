//
//  KMAuthenticationCell.h
//  Ropes
//
//  Created by yzk on 16/4/8.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMAuthenticationCell : UITableViewCell
@property (nonatomic ,weak) IBOutlet UILabel *title;
@property (nonatomic ,weak) IBOutlet UILabel *state;
@property (nonatomic ,weak) IBOutlet UILabel *infomation;
@property (nonatomic ,weak) IBOutlet UILabel *validDate;
@end
