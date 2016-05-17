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
    [self performSegueWithIdentifier:@"balance2bankcard" sender:self];
}

@end
