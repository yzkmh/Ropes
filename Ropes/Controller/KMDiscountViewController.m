//
//  KMDiscountViewController.m
//  Ropes
//
//  Created by sunsea on 16/5/9.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMDiscountViewController.h"
#import "KMNavigationView.h"
#import "LCProgressHUD.h"
#import "KMViewsMannager.h"
#import "KMUserManager.h"
#import "KMVoucher.h"

#import "KMDiscountCell.h"
#import "KMDiscountMoreViewController.h"

@interface KMDiscountViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_leftTableView;
    UITableView *_rightTableView;
    BOOL _isRequest;
    
    NSArray *_leftList;
    NSArray *_rightList;
    
}
@end

@implementation KMDiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self initNavigation];
    self.automaticallyAdjustsScrollViewInsets = false;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initNavigation
{
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
    [[KMViewsMannager getInstance]getViewsInfomationWithConponType:KMDiscountType comlation:^(BOOL result, NSArray *list) {
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
    KMDiscountCell *cell = nil;
    if ([tableView isEqual:_leftTableView]) {
        static NSString *KMDiscountCanCell = @"KMDiscountCanCell";
        cell = [tableView dequeueReusableCellWithIdentifier:KMDiscountCanCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"KMDiscountCell" owner:self options:nil]objectAtIndex:0];
            KMVoucher *voucher = [_leftList objectAtIndex:indexPath.row];
            cell.title.text = voucher.senceName;
            cell.price.text = voucher.balance;
            //cell.state.text = @""
            cell.premise.text = voucher.policyDescription;
            cell.validDate.text = voucher.invalidDate;
        }
    }else if ([tableView isEqual:_rightTableView])
    {
        static NSString *KMDiscountNotCell = @"KMDiscountNotCell";
        cell = [tableView dequeueReusableCellWithIdentifier:KMDiscountNotCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"KMDiscountCell" owner:self options:nil]objectAtIndex:0];
            KMVoucher *voucher = [_rightList objectAtIndex:indexPath.row];
            cell.title.text = voucher.senceName;
            cell.price.text = voucher.balance;
            cell.premise.text = voucher.policyDescription;
            cell.validDate.text = voucher.invalidDate;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMDiscountMoreViewController *discountMore = [[[NSBundle mainBundle]loadNibNamed:@"KMDiscountMoreViewController" owner:nil options:nil]objectAtIndex:0];
    discountMore.title = @"折扣券详情";
    if ([tableView isEqual:_leftTableView]) {
        discountMore.voucher = [_leftList objectAtIndex:indexPath.row];
    }else if([tableView isEqual:_rightTableView]){
        discountMore.voucher = [_rightList objectAtIndex:indexPath.row];
    }
    [self.navigationController pushViewController:discountMore animated:YES];
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
