//
//  KMWalletViewController.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/4/4.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMWalletViewController.h"
#import "NSNumber+FlickerNumber.h"
#import "KMRequestCenter.h"
#import "LCProgressHUD.h"
#import "KMUserManager.h"
#import "NSString+MD5.h"
#import "KMBalanceViewController.h"
#import "KMBankCardTableViewController.h"
#import "KMTransactionTableViewController.h"

@interface KMWalletViewController()
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;
@property (copy, nonatomic) NSString *cashNum;
@end

@implementation KMWalletViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self queryBalance];
    NSNumber *num = [[NSNumber alloc] initWithInt:0];
    self.balanceLabel.text = [num formatNumberDecimal];
    if (![[KMUserManager getInstance].currentUser.bankname isEqualToString:@""] && ![[KMUserManager getInstance].currentUser.bankcard isEqualToString:@""]) {
        self.cardNumLabel.text = [NSString stringWithFormat:@"%@ **** **** **** **** %@",[KMUserManager getInstance].currentUser.bankname,[[KMUserManager getInstance].currentUser.bankcard substringFromIndex:[KMUserManager getInstance].currentUser.bankcard.length -4]];
    }else{
        self.cardNumLabel.text = @"";
    }
    [LCProgressHUD showLoading:nil];
    
}

- (IBAction)balanceBtnClick:(id)sender {
    
    [self performSegueWithIdentifier:@"walletToBalance" sender:self];
}

- (IBAction)bankCardBtnClick:(id)sender {
    
    [self performSegueWithIdentifier:@"walletToBankCard" sender:self];
}

- (IBAction)transactionsBtnClick:(id)sender {
    [self performSegueWithIdentifier:@"walletToTransactions" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[KMBalanceViewController class]]) {
        KMBalanceViewController *bv = segue.destinationViewController;
        bv.cashNum = self.cashNum;
    }
}
- (void)queryBalance
{
    NSString *phone = [KMUserManager getInstance].currentUser.phone;
    NSString *sessionId = [KMUserManager getInstance].currentUser.sessionid;
    NSString *sessionIdPwd = [[sessionId substringToIndex:9] md5WithTimes:6];
    [KMRequestCenter requestForDoBalanceInqueryWithNum:phone
                                             sessionId:sessionId
                                          sessionIdPwd:sessionIdPwd
                                          requestPhone:phone
                                               success:^(NSDictionary *resultDic) {
                                                   
                                                   NSString *cashnum = @"0";
                                                   if ([resultDic objectForKey:@"cashnum"] != [NSNull null]) {
                                                       cashnum = [resultDic objectForKey:@"cashnum"];
                                                   }
                                                   
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       NSNumber *num = [[NSNumber alloc] initWithFloat:[cashnum floatValue]];
                                                       self.balanceLabel.text = [num formatNumberDecimal];
                                                   });
                                                   
                                                   self.cashNum =cashnum;
                                                   [LCProgressHUD hide];
                                               }
                                               failure:nil];
}
@end
