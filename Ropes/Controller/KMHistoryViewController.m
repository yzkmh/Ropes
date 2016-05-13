//
//  KMHistoryViewController.m
//  Ropes
//
//  Created by yzk on 16/5/12.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMHistoryViewController.h"
#import "KMHistoryCell.h"
#import "LCProgressHUD.h"
#import "KMViewsMannager.h"
#import "KMUserManager.h"

@interface KMHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    NSArray *_historyList;
    BOOL _isFinish;
}

@end

@implementation KMHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.941 green:0.945 blue:0.949 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+22, self.view.frame.size.width, self.view.frame.size.height)];
    [_table setDelegate:self];
    [_table setDataSource:self];
    _table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_table];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setTcode:(NSString *)tcode
{
    _tcode = tcode;
    _historyList = [NSArray new];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isFinish == NO) {
        [self initData];
    }
}

- (void)initData
{
    [LCProgressHUD showLoading:nil];
    [[KMViewsMannager getInstance]getHistoryInfoWithtcode:_tcode comlation:^(BOOL result, NSArray *list) {
        [LCProgressHUD hide];
        if (result) {
            _isFinish = YES;
            _historyList = list;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_table reloadData];
            });
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _historyList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMHistoryCell *cell = nil;
//    static NSString *cellIdentifier = @"KMShopCell";
//    KMShop *shop = [_shopList objectAtIndex:indexPath.row];
//    //KMCouponItem *item = [items objectAtIndex:indexPath.row];
//    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"KMShopCell" owner:self options:nil]objectAtIndex:0];
//    }
//    cell.title.text = shop.detailName;
//    cell.phoneNum.text = shop.telNum;
//    cell.address.text = shop.address;
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
