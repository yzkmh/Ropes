//
//  KMTransactionTableViewController.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/4/4.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMTransactionTableViewController.h"
#import "KMTransactionTableViewCell.h"
#import "KMRequestCenter.h"
#import "KMUserManager.h"
#import "NSString+MD5.h"
#import "KMTransaction.h"
#import "LCProgressHUD.h"
@interface KMTransactionTableViewController ()
@property (strong, nonatomic) NSMutableArray *transactionArray;
@end

@implementation KMTransactionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.transactionArray = [[NSMutableArray alloc] init];
    [self cashReHis];
}

- (NSMutableArray *)transactionArray
{
    if (!_transactionArray) {
//        _transactionArray = 
    }
    return _transactionArray;
}
/**
 *  获取收支记录
 */
- (void)cashReHis
{
    
    [LCProgressHUD showLoading:nil];
    NSString *phone = [KMUserManager getInstance].currentUser.phone;
    NSString *sessionId = [KMUserManager getInstance].currentUser.sessionid;
    NSString *sessionIdPwd = [sessionId md5WithTimes:6];
    NSString *bankcard = [KMUserManager getInstance].currentUser.bankcard;
    [KMRequestCenter requestForCashReHisWith:phone
                                   sessionId:sessionId
                                sessionIdPwd:sessionIdPwd
                                requestPhone:phone
                                    bankcard:(NSString *)bankcard
                                     success:^(NSDictionary *resultDic) {
                                         NSMutableArray *dicArray = [NSMutableArray arrayWithArray:[resultDic objectForKey:@"objectReturn"]];
                                         for (NSDictionary *dic in dicArray) {
                                             KMTransaction *transaction = [KMTransaction transactionWithDict:dic];
                                             [self.transactionArray addObject:transaction];
                                         }
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [self.tableView reloadData];
                                         });
                                         [LCProgressHUD hide];
                                     }
                                     failure:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.transactionArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * ID =@"transactionCell";
    KMTransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    KMTransaction *transaction = [self.transactionArray objectAtIndex:indexPath.row];
    if ([transaction.status intValue] == 3) {
            cell.opertionType.text = @"提现";
            cell.dateLabel.text = transaction.requestdate;
            cell.opertionResult.text = @"提现成功";
            cell.moneyNum.text = [NSString stringWithFormat:@"%@ 元",transaction.cashnum];
    }

    
    return cell;
}


@end
