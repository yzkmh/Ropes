//
//  KMShopViewController.m
//  Ropes
//
//  Created by yzk on 16/4/6.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMShopViewController.h"
#import "KMShopCell.h"
#import "KMViewsMannager.h"
#import "KMUserManager.h"
#import "KMShop.h"
#import "LCProgressHUD.h"

@interface KMShopViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    NSArray *_shopList;
    BOOL _isFinish;
}

@end

@implementation KMShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.941 green:0.945 blue:0.949 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+22, self.view.frame.size.width, self.view.frame.size.height-66-48)];
    [_table setDelegate:self];
    [_table setDataSource:self];
    _table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_table];
    // Do any additional setup after loading the view.
}

- (void)setTcode:(NSString *)tcode
{
    _tcode = tcode;
    _shopList = [NSArray new];
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
    [[KMViewsMannager getInstance]getShopInfoWithPhoneNum:[KMUserManager getInstance].currentUser.phone tcode:_tcode conponType:self.type comlation:^(BOOL result, NSArray *list) {
        [LCProgressHUD hide];
        if (result) {
            _isFinish = YES;
            _shopList = list;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_table reloadData];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _shopList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMShopCell *cell = nil;
    static NSString *cellIdentifier = @"KMShopCell";
    KMShop *shop = [_shopList objectAtIndex:indexPath.row];
    //KMCouponItem *item = [items objectAtIndex:indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"KMShopCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.title.text = shop.detailName;
    cell.phoneNum.text = shop.telNum;
    cell.address.text = shop.address;
    [cell.imageView setImage:[UIImage imageNamed:@"shop"]];
    
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
