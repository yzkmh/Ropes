//
//  KMWithdrawViewController.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/5/12.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMWithdrawViewController.h"
#import "LCProgressHUD.h"
#import "KMRequestCenter.h"
#import "KMUserManager.h"
#import "NSString+MD5.h"
#import "KMUser.h"
@interface KMWithdrawViewController ()
@property (weak, nonatomic) IBOutlet UITextField *withdrawNum;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;

@end

@implementation KMWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![[KMUserManager getInstance].currentUser.bankname isEqualToString:@""] && ![[KMUserManager getInstance].currentUser.bankcard isEqualToString:@""]) {
        self.cardNumLabel.text = [NSString stringWithFormat:@"%@ **** **** **** %@",[KMUserManager getInstance].currentUser.bankname,[[KMUserManager getInstance].currentUser.bankcard substringFromIndex:[KMUserManager getInstance].currentUser.bankcard.length -4]];
    }else{
        self.cardNumLabel.text = @"";
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)verification
{
//    NSLog(@"%f",[self.withdrawNum.text floatValue]);
    if (self.withdrawNum.text.length == 0 || [self.withdrawNum.text floatValue] <= 0.0f) {
        [LCProgressHUD showFailure:@"请输入提现金额"];
        return NO;
    }
    if ([self.withdrawNum.text floatValue] > [self.cashNum floatValue]) {
        [LCProgressHUD showFailure:@"余额不足, 无法提现"];
        return NO;
    }
    if ([self.withdrawNum.text floatValue]  > 8000.0f) {
        [LCProgressHUD showFailure:@"提现金额超过8000, 无法提现"];
        return NO;
    }
    if (![KMUserManager getInstance].currentUser.bankcard || ![KMUserManager getInstance].currentUser.bankname ) {
        [LCProgressHUD showFailure:@"银行卡数据有误"];
        return NO;
    }
    return YES;
}
- (IBAction)addBankCardBtnClick:(id)sender {
    [KMUserManager getInstance].isChangeBankInfo = YES;
    [self performSegueWithIdentifier:@"withdraw2bankcard" sender:self];
}

- (IBAction)withdrawBtnClock:(id)sender {
    if (![self verification]) {
        return;
    }
    [self requestForWithdraw];
}
//提现接口
- (void)requestForWithdraw
{
    KMUser *user = [KMUserManager getInstance].currentUser;
    NSString *phone = user.phone;
    NSString *sessionId = user.sessionid;
    NSString *sessionIdPwd = [[sessionId substringToIndex:9] md5WithTimes:6];
    NSString *bankname = user.bankname;
    NSString *bankcard = user.bankcard;
    [KMRequestCenter requestForDoCashRe:phone
                              sessionId:sessionId
                           sessionIdPwd:sessionIdPwd
                           requestPhone:phone
                               cacshnum:self.withdrawNum.text
                               bankname:bankname
                               bankcard:bankcard
                            requestname:user.name
                                success:^(NSDictionary *resultDic) {
                                    BOOL status = [[resultDic objectForKey:@"status"] boolValue];
                                    if (status)
                                    {
                                        [LCProgressHUD showSuccess:@"提现成功"];
                                        
                                    } else
                                    {
                                        [LCProgressHUD showFailure:[resultDic objectForKey:@"msg"]];
                                    }
                                    
                                } failure:nil];
}


@end
