//
//  KMLotteryMoreViewController.m
//  Ropes
//
//  Created by yzk on 16/4/2.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMLotteryMoreViewController.h"
#import "KMShopViewController.h"



@interface KMLotteryMoreViewController ()<UITableViewDataSource ,UITableViewDelegate>
{
    UITableView *_tableView;
    
}
@end

@implementation KMLotteryMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.showView.frame.origin.y+self.showView.frame.size.height +20, self.view.frame.size.width, 80)];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    
    
    [self.view addSubview:_tableView];
    
//    [self initData];
    
    // Do any additional setup after loading the view.
}

- (void)setLottery:(KMLottery *)lottery
{
    _lottery = lottery;
    self.titleLb.text = self.lottery.lotteryTypeName;
    self.lotteryNumLb.text = self.lottery.lotteryNumber;
    self.winningLvLb.text = self.lottery.lotteryPrizeResult;
    self.lotteryTermLb.text = self.lottery.lotterySchedule;
    self.openDateLb.text = self.lottery.lotteryPrizeDate;
    self.usableDateLb.text = self.lottery.invalidDate;
    self.receiveDateLb.text = self.lottery.lotteryGetDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        cell = [[UITableViewCell alloc]init];
        cell.textLabel.text = @"发送彩票短信";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 1)
    {
        cell = [[UITableViewCell alloc]init];
        cell.textLabel.text = @"兑换商家";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section

{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
    
    v.backgroundColor = [UIColor clearColor];
    
    return v;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        KMShopViewController *shopView = [[KMShopViewController alloc]init];
        [shopView setTitle:@"商家详情"];
        shopView.lottery = _lottery;
        [self.navigationController pushViewController:shopView animated:YES];
    }else if(indexPath.row == 0)
    {
        
    }
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
