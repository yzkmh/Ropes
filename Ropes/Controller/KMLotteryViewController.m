//
//  KMLotteryViewController.m
//  Ropes
//
//  Created by yzk on 16/3/27.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMLotteryViewController.h"
#import "KMLotteryMoreViewController.h"
#import "KMNavigationView.h"
#import "KMLotteryCell.h"

@interface KMLotteryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_leftTableView;
    UITableView *_rightTableView;
    
}


@end

@implementation KMLotteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self initNavigation];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    
    
    // Do any additional setup after loading the view.
}

- (void)initNavigation
{
    
    
    
    KMNavigationView *naviView = [[[NSBundle mainBundle] loadNibNamed:@"KMNavigationView" owner:self options:nil]objectAtIndex:0];
    [naviView setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(naviView.bounds.origin.x, 0, naviView.bounds.size.width, naviView.bounds.size.height-45)];
    [_leftTableView setDelegate:self];
    [_leftTableView setDataSource:self];
    _leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //_leftTableView.backgroundColor = [UIColor clearColor];
    [naviView addToShowView:_leftTableView];
    
    
    
    _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(naviView.bounds.size.width, 0, naviView.bounds.size.width, naviView.bounds.size.height-45)];
    [_rightTableView setDelegate:self];
    [_rightTableView setDataSource:self];
    _rightTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [naviView addToShowView:_rightTableView];
    
    [self.view addSubview:naviView];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMLotteryCell *cell = nil;
    static NSString *cellIdentifier = @"KMLotteryCell";
    //KMCouponItem *item = [items objectAtIndex:indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"KMLotteryCell" owner:self options:nil]objectAtIndex:0];
        //cell.title.text = @"大乐透";
        //cell.lotteryNum = @"123456789";
        //cell
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMLotteryMoreViewController *lotteryMore = [[[NSBundle mainBundle]loadNibNamed:@"KMLotteryMoreViewController" owner:nil options:nil]objectAtIndex:0];
    [self.navigationController pushViewController:lotteryMore animated:YES];
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
