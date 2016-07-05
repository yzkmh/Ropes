//
//  KMBankCardTableViewController.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/4/4.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMBankCardTableViewController.h"
#import "KMUserManager.h"
#import "KMUser.h"
@interface KMBankCardTableViewController()
{
    NSArray *bankArray;
}
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *cardNum;

@end

@implementation KMBankCardTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    KMUser *user = [[KMUserManager getInstance] currentUser];
    self.bankName.text = user.bankname;
    self.name.text = user.name;
    self.cardNum.text = [NSString stringWithFormat:@"**** **** **** %@",[user.bankcard substringFromIndex:user.bankcard.length-4]];
}

- (IBAction)addCardBtnClick:(id)sender {
    [self performSegueWithIdentifier:@"addbankcard" sender:self];
}

@end
