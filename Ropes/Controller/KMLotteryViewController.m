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


@interface KMLotteryViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    KMNavigationView *naviView;
    
    UITableView *_leftTableView;
    UITableView *_rightTableView;
    
    NSArray *_leftList;
    NSArray *_rightList;
    
    UIRefreshControl *_controlleft;
    UIRefreshControl *_controlright;
    BOOL _isRequest;
    
    UISearchBar *_mySearchBar;
    NSArray *_tempLList;
    NSArray *_tempRList;
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
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigation];
    self.automaticallyAdjustsScrollViewInsets = false;
    [self initRefresh];
    [self initSearch];    
    // Do any additional setup after loading the view.
}
- (void)initSearch
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBar:)];
    self.navigationItem.rightBarButtonItem = item;
    
    _mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, 44)];
    
    //设置选项
    
    _mySearchBar.barTintColor = [UIColor whiteColor];
    
    _mySearchBar.searchBarStyle = UISearchBarStyleDefault;
    
    _mySearchBar.translucent = NO; //是否半透明
    
    [_mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    [_mySearchBar sizeToFit];
    
    _mySearchBar.delegate = self;
}

/**
 *  集成下拉刷新
 */
-(void)initRefresh
{
    //1.添加刷新控件
    _controlleft=[[UIRefreshControl alloc]init];
    [_controlleft addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    [_leftTableView addSubview:_controlleft];
    
    _controlright=[[UIRefreshControl alloc]init];
    [_controlright addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    [_rightTableView addSubview:_controlright];
}

-(void)refreshStateChange:(UIRefreshControl *)control
{
    [self initData];
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
    
    
    [naviView setLabelWithConponNum1:[NSString stringWithFormat:@"%@",[[KMUserManager getInstance].currentUser.ConponNumList objectForKey:@"cl"]] andNum2:[NSString stringWithFormat:@"%@",[[KMUserManager getInstance].currentUser.ConponNumList objectForKey:@"nl"]]];
    
    [self.view addSubview:naviView];
    
    
}

- (void)initData
{
    if (!_isRequest) {
        [LCProgressHUD showLoading:nil];
    }
    [[KMViewsMannager getInstance]getLotteryInfoWithPhoneNum:[KMUserManager getInstance].currentUser.phone comlation:^(BOOL result, NSArray *list) {
        [LCProgressHUD hide];
        [_controlleft endRefreshing];
        [_controlright endRefreshing];
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
    KMLotteryCell *cell = nil;
    if ([tableView isEqual:_leftTableView]) {
        static NSString *KMLotteryCanCell = @"KMLotteryCanCell";
        cell = [tableView dequeueReusableCellWithIdentifier:KMLotteryCanCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"KMLotteryCell" owner:self options:nil]objectAtIndex:0];
            KMLottery *lottery = [_leftList objectAtIndex:indexPath.row];
            cell.title.text = lottery.lotteryTypeName;
            cell.lotteryNum.text = lottery.lotteryNumber;
            if ([lottery.lotteryPrizeResult isEqualToString:@"未中奖"]||[lottery.lotteryPrizeResult isEqualToString:@"未开奖"]) {
                cell.state.text = lottery.lotteryPrizeResult;
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
            KMLottery *lottery = [_rightList objectAtIndex:indexPath.row];
            cell.title.text = lottery.lotteryTypeName;
            cell.lotteryNum.text = lottery.lotteryNumber;
            if ([lottery.lotteryPrizeResult isEqualToString:@"未中奖"]||[lottery.lotteryPrizeResult isEqualToString:@"未开奖"]) {
                cell.state.text = lottery.lotteryPrizeResult;
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
        lotteryMore.lottery = [_leftList objectAtIndex:indexPath.row];
    }else if([tableView isEqual:_rightTableView]){
        lotteryMore.lottery = [_rightList objectAtIndex:indexPath.row];
    }
    [self.navigationController pushViewController:lotteryMore animated:YES];
}
#pragma srarchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _tempLList = _leftList;
    _tempRList = _rightList;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchBar.text isEqualToString:@""]) {
        _leftList = _tempLList;
        _rightList = _tempRList;
        [naviView setLabelWithConponNum1:[NSString stringWithFormat:@"%lu",(unsigned long)_leftList.count] andNum2:[NSString stringWithFormat:@"%lu",(unsigned long)_rightList.count]];
        [_leftTableView reloadData];
        [_rightTableView reloadData];
    }else{
        NSMutableArray *tempList = [NSMutableArray new];
        for (KMLottery *lottery in _tempLList) {
            if([lottery.lotteryTypeName rangeOfString:searchBar.text].location !=NSNotFound)//_roaldSearchText
            {
                [tempList addObject:lottery];
            }
        }
        _leftList = [NSArray arrayWithArray:tempList];
        [tempList removeAllObjects];
        for (KMLottery *lottery in _tempRList) {
            if([lottery.lotteryTypeName rangeOfString:searchBar.text].location !=NSNotFound)//_roaldSearchText
            {
                [tempList addObject:lottery];
            }
        }
        _rightList = [NSArray arrayWithArray:tempList];
        [naviView setLabelWithConponNum1:[NSString stringWithFormat:@"%lu",(unsigned long)_leftList.count] andNum2:[NSString stringWithFormat:@"%lu",(unsigned long)_rightList.count]];
        [_leftTableView reloadData];
        [_rightTableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (IBAction)searchBar:(id)sender
{
    if (!_mySearchBar.superview) {
        CGRect frame = naviView.frame;
        frame.origin.y += 44;
        [UIView animateWithDuration:0.3 animations:^{
            [self.view addSubview:_mySearchBar];
            naviView.frame = frame;
        }];
        [_mySearchBar becomeFirstResponder];
    }else{
        CGRect frame = naviView.frame;
        frame.origin.y -= 44;
        [UIView animateWithDuration:0.3 animations:^{
            [_mySearchBar removeFromSuperview];
            naviView.frame = frame;
        }];
        [_mySearchBar resignFirstResponder];
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
