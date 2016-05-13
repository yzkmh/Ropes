//
//  KMAuthenticationMoreViewController.h
//  Ropes
//
//  Created by yzk on 16/4/8.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMVoucher.h"

@interface KMAuthenticationMoreViewController : UIViewController

@property (nonatomic ,weak) IBOutlet UIView *showView;
@property (nonatomic ,weak) IBOutlet UILabel *titleLb;
@property (nonatomic ,weak) IBOutlet UILabel *price;
@property (nonatomic ,weak) IBOutlet UILabel *balance;
@property (nonatomic ,weak) IBOutlet UILabel *usableDate;
@property (nonatomic ,weak) IBOutlet UILabel *message;
@property (nonatomic ,weak) IBOutlet UIButton *useBtn;

@property (nonatomic ,weak) IBOutlet UITableView *tableView;

@property (nonatomic ,weak) IBOutlet UITextView *voncherDescription;

@property (nonatomic ,strong) KMVoucher *voucher;;


@end
