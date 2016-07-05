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
    if ([KMUserManager getInstance].currentUser.bankname && [KMUserManager getInstance].currentUser.bankcard) {
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
        [self.drawBtn setBackgroundColor:[UIColor redColor]];
        [self.drawBtn setUserInteractionEnabled:YES];
    }
}
- (IBAction)withdrawBtnClick:(id)sender {

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
