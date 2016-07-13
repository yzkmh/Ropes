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
#import "KMUserManager.h"
@interface KMBalanceViewController()
@property (weak, nonatomic) IBOutlet UILabel *cashLabel;
@property (weak, nonatomic) IBOutlet UIButton *drawBtn;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;

@end

@implementation KMBalanceViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSNumber *num = [[NSNumber alloc] initWithFloat:[self.cashNum floatValue]];
    if (![[KMUserManager getInstance].currentUser.bankname isEqualToString:@""] && ![[KMUserManager getInstance].currentUser.bankcard isEqualToString:@""]) {
        self.cardNumLabel.text = [NSString stringWithFormat:@"%@ **** **** **** **** %@",[KMUserManager getInstance].currentUser.bankname,[[KMUserManager getInstance].currentUser.bankcard substringFromIndex:[KMUserManager getInstance].currentUser.bankcard.length -4]];
    }else{
        self.cardNumLabel.text = @"";
    }
    
    self.cashLabel.text = [num formatNumberDecimal];
    if ([self.cashNum floatValue] == 0.0f) {
        [self.drawBtn setTitle:@"提现" forState:UIControlStateNormal];
        [self.drawBtn setBackgroundColor:[UIColor grayColor]];
        [self.drawBtn setUserInteractionEnabled:NO];
        return;
    }else{
        [self.drawBtn setTitle:@"提现" forState:UIControlStateNormal];
        [self.drawBtn setBackgroundColor:[UIColor colorWithRed:0.894 green:0.173 blue:0.227 alpha:1]];
        [self.drawBtn setUserInteractionEnabled:YES];
    }
}
- (IBAction)withdrawBtnClick:(id)sender {
    
    if ([[KMUserManager getInstance].currentUser.name isEqualToString:@""]) {
        [self performSegueWithIdentifier:@"myInfoToEditInfo" sender:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [LCProgressHUD showInfoMsg:@"请完善个人信息"];
        });
        return;
    }
    if ([[KMUserManager getInstance].currentUser.bankcard isEqualToString:@""] || [[KMUserManager getInstance].currentUser.bankname isEqualToString:@""]) {
        [self performSegueWithIdentifier:@"balance2addbankcard" sender:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [LCProgressHUD showInfoMsg:@"请完善银行卡信息"];
        });
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
    [KMUserManager getInstance].isChangeBankInfo = YES;
    [self performSegueWithIdentifier:@"balance2addbankcard" sender:self];
}

@end
