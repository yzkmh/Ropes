//
//  KMWalletViewController.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/4/4.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMWalletViewController.h"
#import "NSNumber+FlickerNumber.h"
@interface KMWalletViewController()
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@end

@implementation KMWalletViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNumber *num = [[NSNumber alloc] initWithInt:40000];
    self.balanceLabel.text = [num formatNumberDecimal];
    
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

@end
