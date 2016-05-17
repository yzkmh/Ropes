//
//  KMShopCell.h
//  Ropes
//
//  Created by yzk on 16/4/6.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMShopCell : UITableViewCell

@property (nonatomic ,weak) IBOutlet UIImageView *logoImage;
@property (nonatomic ,weak) IBOutlet UILabel *title;
@property (nonatomic ,weak) IBOutlet UILabel *address;
@property (nonatomic ,weak) IBOutlet UILabel *phoneNum;

@end
