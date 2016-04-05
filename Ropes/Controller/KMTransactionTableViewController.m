//
//  KMTransactionTableViewController.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/4/4.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMTransactionTableViewController.h"
#import "KMTransactionTableViewCell.h"
@interface KMTransactionTableViewController ()

@end

@implementation KMTransactionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * ID =@"transactionCell";
    KMTransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    cell.opertionType.text = @"提现";
    cell.dateLabel.text = @"04-04 18:00";
    cell.opertionResult.text = @"提现成功";
    cell.moneyNum.text = @"8000 元";
    
    return cell;
}


@end
