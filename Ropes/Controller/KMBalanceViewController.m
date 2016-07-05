//
//  KMBalanceViewController.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/4/4.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMBalanceViewController.h"
#import "NSNumber+FlickerNumber.h"
#import "KMWithdrawViewController.h"
#import "LCProgressHUD.h"
@interface KMBalanceViewController()
@property (weak, nonatomic) IBOutlet UILabel *cashLabel;

@end

@implementation KMBalanceViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSNumber *num = [[NSNumber alloc] initWithFloat:[self.cashNum floatValue]];
    self.cashLabel.text = [num formatNumberDecimal];
}
- (IBAction)withdrawBtnClick:(id)sender {
    if ([self.cashNum floatValue] == 0.0f) {
        [LCProgressHUD showInfoMsg:@"余额不足，无法提现"];
        return;
    }
    [self performSegueWithIdentifier:@"balance2withdraw" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[KMWithdrawViewController class]]){
    KMWithdrawViewController *withdraw = segue.destinationViewController;
    withdraw.cashNum = self.cashNum;
    }
}
- (IBAction)bankcardBtnClick:(id)sender {
    //[self performSegueWithIdentifier:@"balance2addbankcard" sender:self];
}

@end
