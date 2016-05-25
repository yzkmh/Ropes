//
//  KMDiscountMoreViewController.h
//  Ropes
//
//  Created by sunsea on 16/5/9.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMVoucher.h"

@interface KMDiscountMoreViewController : UIViewController
@property (nonatomic ,weak) IBOutlet UIView *showView;
@property (nonatomic ,weak) IBOutlet UILabel *titleLb;
@property (nonatomic ,weak) IBOutlet UILabel *price;
@property (nonatomic ,weak) IBOutlet UILabel *expirationDate;
@property (nonatomic ,weak) IBOutlet UILabel *rule;
@property (nonatomic ,weak) IBOutlet UILabel *condition;
@property (nonatomic ,weak) IBOutlet UIButton *useBtn;

@property (nonatomic ,weak) IBOutlet UITableView *tableView;

@property (nonatomic ,weak) IBOutlet UITextView *voncherDescription;

@property (nonatomic ,strong) KMVoucher *voucher;

- (void)setBtnClose;
@end
