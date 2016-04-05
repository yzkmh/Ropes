//
//  KMBankCardTableViewController.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/4/4.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMBankCardTableViewController.h"
#import "KMBankCardCell.h"
@interface KMBankCardTableViewController()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *bankArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation KMBankCardTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   
    
}

- (IBAction)addCardBtnClick:(id)sender {
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    tableView.frame = CGRectMake(0, 20, KMMainScreenBounds.size.width, 5 * 105);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"bankCardCell";
    KMBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [KMBankCardCell bankCardCellWithTableView:tableView];
    }
    cell.bankNameLabel.text = @"民生银行";
    cell.nameLabel.text = @"鹿目圆香";
    cell.cardNumLabel.text = @"1234 4321 5678 8765 098";
    return cell;
}

@end
