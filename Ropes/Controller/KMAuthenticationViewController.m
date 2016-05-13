//
//  KMAuthenticationViewController.m
//  Ropes
//
//  Created by yzk on 16/4/7.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMAuthenticationViewController.h"
#import "KMAuthenticationMoreViewController.h"
#import "KMNavigationView.h"
#import "KMAuthenticationCell.h"
#import "KMViewsMannager.h"
#import "LCProgressHUD.h"
#import "KMVoucher.h"


@interface KMAuthenticationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_leftTableView;
    UITableView *_rightTableView;
    
    BOOL _isRequest;
    
    NSArray *_leftList;
    NSArray *_rightList;
}

@end

@implementation KMAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KMNavigationView *naviView = [[[NSBundle mainBundle] loadNibNamed:@"KMNavigationView" owner:self options:nil]objectAtIndex:0];
    [naviView setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(naviView.bounds.origin.x, 10, naviView.bounds.size.width, naviView.bounds.size.height-45)];
    [_leftTableView setDelegate:self];
    [_leftTableView setDataSource:self];
    _leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [naviView addToShowView:_leftTableView];
    
    
    
    _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(naviView.bounds.size.width, 10, naviView.bounds.size.width, naviView.bounds.size.height-45)];
    [_rightTableView setDelegate:self];
    [_rightTableView setDataSource:self];
    _rightTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [naviView addToShowView:_rightTableView];
    
    [self.view addSubview:naviView];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isRequest == NO) {
        [self initData];
    }
}
- (void)initData
{
    [LCProgressHUD showLoading:nil];
    [[KMViewsMannager getInstance]getViewsInfomationWithConponType:KMAuthenticationType comlation:^(BOOL result, NSArray *list) {
        [LCProgressHUD hide];
        _leftList = [list objectAtIndex:0];
        _rightList = [list objectAtIndex:1];
        _isRequest = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_leftTableView reloadData];
            [_rightTableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_leftTableView]) {
        return _leftList.count;
    }else if([tableView isEqual:_rightTableView])
    {
        return _rightList.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMAuthenticationCell *cell = nil;
    if ([tableView isEqual:_leftTableView]) {
        static NSString *KMAuthenticationCanCell = @"KMAuthenticationCanCell";
        cell = [tableView dequeueReusableCellWithIdentifier:KMAuthenticationCanCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"KMAuthenticationCell" owner:self options:nil]objectAtIndex:0];
            KMVoucher *voucher = [_leftList objectAtIndex:indexPath.row];
            cell.title.text = voucher.senceName;
            cell.state.text = voucher.policyName;
            cell.infomation.text = voucher.policyDescription;
            cell.validDate.text = voucher.invalidDate;
        }
    }else if ([tableView isEqual:_rightTableView])
    {
        static NSString *KMAuthenticationNotCell = @"KMAuthenticationNotCell";
        cell = [tableView dequeueReusableCellWithIdentifier:KMAuthenticationNotCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"KMAuthenticationCell" owner:self options:nil]objectAtIndex:0];
            KMVoucher *voucher = [_rightList objectAtIndex:indexPath.row];
            cell.title.text = voucher.senceName;
            cell.state.text = voucher.balance;
            cell.infomation.text = voucher.policyDescription;
            cell.validDate.text = voucher.invalidDate;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMAuthenticationMoreViewController *authenticationMore = [[[NSBundle mainBundle]loadNibNamed:@"KMAuthenticationMoreViewController" owner:nil options:nil]objectAtIndex:0];
    authenticationMore.title = @"身份认证详情";
    [self.navigationController pushViewController:authenticationMore  animated:YES];
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
