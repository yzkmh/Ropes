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

@interface KMDiscountViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    KMNavigationView *naviView;
    
    UITableView *_leftTableView;
    UITableView *_rightTableView;
    
    BOOL _isRequest;
    
    NSArray *_leftList;
    NSArray *_rightList;
    
    UIRefreshControl *_controlleft;
    UIRefreshControl *_controlright;
    
    UISearchBar *_mySearchBar;
    NSArray *_tempLList;
    NSArray *_tempRList;
    
}
@end

@implementation KMDiscountViewController

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
    
    
    [naviView setLabelWithConponNum1:[NSString stringWithFormat:@"%@",[[KMUserManager getInstance].currentUser.ConponNumList objectForKey:@"zc"]] andNum2:[NSString stringWithFormat:@"%@",[[KMUserManager getInstance].currentUser.ConponNumList objectForKey:@"zn"]]];
    
    [self.view addSubview:naviView];
}

- (void)initData
{
    if (!_isRequest) {
        [LCProgressHUD showLoading:nil];
    }
    
    [[KMViewsMannager getInstance]getViewsInfomationWithConponType:KMDiscountType comlation:^(BOOL result, NSArray *list)  {
        [LCProgressHUD hide];
        [_controlleft endRefreshing];
        [_controlright endRefreshing];
        _leftList = [list objectAtIndex:0];
        _rightList = [list objectAtIndex:1];
        _isRequest = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_leftTableView reloadData];
            [_rightTableView reloadData];
            [naviView setLabelWithConponNum1:[NSString stringWithFormat:@"%lu",(unsigned long)_leftList.count] andNum2:[NSString stringWithFormat:@"%lu",(unsigned long)_rightList.count]];
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
            NSString *salaStr = [NSString stringWithFormat:@"%.1f折优惠",[voucher.discountRate floatValue]/10.0f];
            cell.price.text = [salaStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
            if ([voucher.useCount isEqual:@1]) {
                cell.state.text = @"单";
            }else {
                cell.state.text = @"多";
            }
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
            NSString *salaStr = [NSString stringWithFormat:@"%.1f折优惠",[voucher.discountRate floatValue]/10.0f];
            cell.price.text = [salaStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
            if ([voucher.useCount isEqual:@1]) {
                cell.state.text = @"单";
            }else {
                cell.state.text = @"多";
            }
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
        [discountMore setBtnClose];
    }
    [self.navigationController pushViewController:discountMore animated:YES];
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
        for (KMVoucher *voucher in _tempLList) {
            if([voucher.senceName rangeOfString:searchBar.text].location !=NSNotFound)//_roaldSearchText
            {
                [tempList addObject:voucher];
            }
        }
        _leftList = [NSArray arrayWithArray:tempList];
        [tempList removeAllObjects];
        for (KMVoucher *voucher in _tempRList) {
            if([voucher.senceName rangeOfString:searchBar.text].location !=NSNotFound)//_roaldSearchText
            {
                [tempList addObject:voucher];
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
