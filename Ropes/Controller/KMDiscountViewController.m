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

@interface KMDiscountViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate>
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
    UISearchDisplayController *_searchDisplayController;
    NSMutableArray *_searchList;//搜索到的列表
    
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
    self.view.backgroundColor = [UIColor grayColor];
    [self initNavigation];
    self.automaticallyAdjustsScrollViewInsets = false;
    [self initRefresh];
    [self initSearch];
    
    // Do any additional setup after loading the view.
}

- (void)initSearch
{
    _mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, [UIScreen mainScreen].bounds.size.width, 44)];
    
    //设置选项
    
    _mySearchBar.barTintColor = [UIColor whiteColor];
    
    _mySearchBar.searchBarStyle = UISearchBarStyleDefault;
    
    _mySearchBar.translucent = NO; //是否半透明
    
    [_mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    [_mySearchBar sizeToFit];
    
    // 用 searchbar 初始化 SearchDisplayController
    // 并把 searchDisplayController 和当前 controller 关联起来
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_mySearchBar contentsController:self];
    _searchDisplayController.delegate = self;
    // searchResultsDataSource 就是 UITableViewDataSource
    _searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    _searchDisplayController.searchResultsDelegate = self;

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
    UIBarButtonItem *searchBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBar:)];
    self.navigationItem.rightBarButtonItem = searchBar;
    
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
    }else{
        // 谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",_searchDisplayController.searchBar.text];
        //这个地方有问题
        _searchList =  [[NSMutableArray alloc] initWithArray:[_rightList filteredArrayUsingPredicate:predicate]];
        return _searchList.count;
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
            if ([[salaStr substringFromIndex:salaStr.length-2]isEqualToString:@".0"]) {
                salaStr = [salaStr substringToIndex:salaStr.length-2];
            }
            cell.price.text = salaStr;
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
            if ([[salaStr substringFromIndex:salaStr.length-2]isEqualToString:@".0"]) {
                salaStr = [salaStr substringToIndex:salaStr.length-2];
            }
            cell.price.text = salaStr;
            if ([voucher.useCount isEqual:@1]) {
                cell.state.text = @"单";
            }else {
                cell.state.text = @"多";
            }
            cell.premise.text = voucher.policyDescription;
            cell.validDate.text = voucher.invalidDate;
        }
    }else{
        static NSString *KMDiscountNotCell = @"KMDiscountSearchCell";
        cell = [tableView dequeueReusableCellWithIdentifier:KMDiscountNotCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"KMDiscountCell" owner:self options:nil]objectAtIndex:0];
            KMVoucher *voucher = [_searchList objectAtIndex:indexPath.row];
            cell.title.text = voucher.senceName;
            NSString *salaStr = [NSString stringWithFormat:@"%.1f折优惠",[voucher.discountRate floatValue]/10.0f];
            if ([[salaStr substringFromIndex:salaStr.length-2]isEqualToString:@".0"]) {
                salaStr = [salaStr substringToIndex:salaStr.length-2];
            }
            cell.price.text = salaStr;
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

#pragma UISearchDisplayDelegate
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    CGRect frame = tableView.frame;
    frame.origin.y = 44;
    [tableView setFrame:frame];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    CGRect frame = tableView.frame;
    frame.origin.y = 0;
    [tableView setFrame:frame];
}

- (IBAction)searchBar:(id)sender
{
    [self.navigationController.view addSubview:_mySearchBar];
    
    [_mySearchBar becomeFirstResponder];
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
