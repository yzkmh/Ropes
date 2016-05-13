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
#import "KMRequestCenter.h"
#import "KMViewsMannager.h"
#import "KMLottery.h"
#import "KMUserManager.h"
#import "LCProgressHUD.h"


@interface KMLotteryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    KMNavigationView *naviView;
    
    UITableView *_leftTableView;
    UITableView *_rightTableView;
    
    NSArray *lotteryCanList;
    NSArray *lotteryNotList;
    
    BOOL _isRequest;
}
@end

@implementation KMLotteryViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isRequest == NO) {
        [self initData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self initNavigation];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    // Do any additional setup after loading the view.
}

- (void)initNavigation
{
    naviView = [[[NSBundle mainBundle] loadNibNamed:@"KMNavigationView" owner:self options:nil]objectAtIndex:0];
    [naviView setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(naviView.bounds.origin.x, 0, naviView.bounds.size.width, naviView.bounds.size.height-45)];
    [_leftTableView setDelegate:self];
    [_leftTableView setDataSource:self];
    _leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [naviView addToShowView:_leftTableView];
    
    
    
    _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(naviView.bounds.size.width, 0, naviView.bounds.size.width, naviView.bounds.size.height-45)];
    [_rightTableView setDelegate:self];
    [_rightTableView setDataSource:self];
    _rightTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [naviView addToShowView:_rightTableView];
    
    [self.view addSubview:naviView];
}

- (void)initData
{
    [LCProgressHUD showLoading:nil];
    [[KMViewsMannager getInstance]getLotteryInfoWithPhoneNum:[KMUserManager getInstance].currentUser.phone comlation:^(BOOL result, NSArray *list) {
        [LCProgressHUD hide];
        lotteryCanList = [list objectAtIndex:0];
        lotteryNotList = [list objectAtIndex:1];
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
        return lotteryCanList.count;
    }else if([tableView isEqual:_rightTableView])
    {
        return lotteryNotList.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMLotteryCell *cell = nil;
    if ([tableView isEqual:_leftTableView]) {
        static NSString *KMLotteryCanCell = @"KMLotteryCanCell";
        cell = [tableView dequeueReusableCellWithIdentifier:KMLotteryCanCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"KMLotteryCell" owner:self options:nil]objectAtIndex:0];
            KMLottery *lottery = [lotteryCanList objectAtIndex:indexPath.row];
            cell.title.text = lottery.lotteryTypeName;
            cell.lotteryNum.text = lottery.lotteryNumber;
            if ([lottery.lotteryPrizeResult isEqualToString:@"未中奖"]||[lottery.lotteryPrizeResult isEqualToString:@"未开奖"]) {
                cell.state.text = @"未中奖";
            }else{
                cell.state.text = @"中奖";
            }
            cell.LotteryDate.text = lottery.lotteryPrizeDate;
            cell.validDate.text = lottery.invalidDate;
        }
    }else if ([tableView isEqual:_rightTableView])
    {
        static NSString *KMLotteryNotCell = @"KMLotteryNotCell";
        cell = [tableView dequeueReusableCellWithIdentifier:KMLotteryNotCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"KMLotteryCell" owner:self options:nil]objectAtIndex:0];
            KMLottery *lottery = [lotteryNotList objectAtIndex:indexPath.row];
            cell.title.text = lottery.lotteryTypeName;
            cell.lotteryNum.text = lottery.lotteryNumber;
            if ([lottery.lotteryPrizeResult isEqualToString:@"未中奖"]||[lottery.lotteryPrizeResult isEqualToString:@"未开奖"]) {
                cell.state.text = @"未中奖";
            }else{
                cell.state.text = @"中奖";
            }
            cell.LotteryDate.text = lottery.lotteryPrizeDate;
            cell.validDate.text = lottery.invalidDate;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMLotteryMoreViewController *lotteryMore = [[[NSBundle mainBundle]loadNibNamed:@"KMLotteryMoreViewController" owner:nil options:nil]objectAtIndex:0];
    lotteryMore.title = @"彩票详情";
    if ([tableView isEqual:_leftTableView]) {
        lotteryMore.lottery = [lotteryCanList objectAtIndex:indexPath.row];
    }else if([tableView isEqual:_rightTableView]){
        lotteryMore.lottery = [lotteryNotList objectAtIndex:indexPath.row];
    }
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
