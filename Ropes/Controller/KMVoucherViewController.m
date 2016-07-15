//
//  KMVoucherViewController.m
//  Ropes
//
//  Created by yzk on 16/4/6.
//  Copyright © 2016年 Madoka. All rights reserved.
//


#import "KMVoucherCell.h"
#import "KMVoucherViewController.h"
#import "KMVoucherMoreViewController.h"
#import "KMNavigationView.h"
#import "LCProgressHUD.h"
#import "KMViewsMannager.h"
#import "KMUserManager.h"
#import "KMVoucher.h"


@interface KMVoucherViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
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

@implementation KMVoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigation];
    [self initRefresh];
    [self initSearch];
    self.automaticallyAdjustsScrollViewInsets = false;
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_isRequest == NO) {
        [self initData];
    }
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
    
        [naviView setLabelWithConponNum1:[NSString stringWithFormat:@"%@",[[KMUserManager getInstance].currentUser.ConponNumList objectForKey:@"dc"]] andNum2:[NSString stringWithFormat:@"%@",[[KMUserManager getInstance].currentUser.ConponNumList objectForKey:@"dn"]]];
    
    [self.view addSubview:naviView];
}
- (void)initData
{
    [LCProgressHUD showLoading:nil];
    [[KMViewsMannager getInstance]getViewsInfomationWithConponType:KMVoucherType comlation:^(BOOL result, NSArray *list) {
        [LCProgressHUD hide];
        
        _leftList = [list objectAtIndex:0];
        _rightList = [list objectAtIndex:1];
        _isRequest = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_leftTableView reloadData];
            [_rightTableView reloadData];
            [naviView setLabelWithConponNum1:[NSString stringWithFormat:@"%lu",(unsigned long)_leftList.count] andNum2:[NSString stringWithFormat:@"%lu",(unsigned long)_rightList.count]];
            [[KMUserManager getInstance].currentUser.ConponNumList setObject:[NSString stringWithFormat:@"%lu",(unsigned long)_leftList.count] forKey:@"dc"];
            [[KMUserManager getInstance].currentUser.ConponNumList setObject:[NSString stringWithFormat:@"%lu",(unsigned long)_rightList.count] forKey:@"dn"];
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
    KMVoucherCell *cell = nil;
    if ([tableView isEqual:_leftTableView]) {
        static NSString *KMVoucherCanCell = @"KMVoucherCanCell";
        cell = [tableView dequeueReusableCellWithIdentifier:KMVoucherCanCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"KMVoucherCell" owner:self options:nil]objectAtIndex:0];
            KMVoucher *voucher = [_leftList objectAtIndex:indexPath.row];
            cell.title.text = voucher.senceName;
            cell.price.text = voucher.consumeCount;
            cell.banlance.text = voucher.balance;
            if (![voucher.policyDescription isKindOfClass:[NSNull class]]) {
                cell.premise.text = voucher.policyDescription;
            }else{
                cell.premise.text = @"";
            }
            if ([voucher.useCounttype isEqual:@1]) {
                cell.state.text = @"单";
            }else if([voucher.useCounttype isEqual:@2]) {
                cell.state.text = @"多";
            }
            cell.validDate.text = voucher.invalidDate;
        }
    }else if ([tableView isEqual:_rightTableView])
    {
        static NSString *KMVoucherNotCell = @"KMVoucherNotCell";
        cell = [tableView dequeueReusableCellWithIdentifier:KMVoucherNotCell];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"KMVoucherCell" owner:self options:nil]objectAtIndex:0];
            KMVoucher *voucher = [_rightList objectAtIndex:indexPath.row];
            cell.title.text = voucher.senceName;
            cell.price.text = voucher.consumeCount;
            cell.banlance.text = voucher.balance;
            if (![voucher.policyDescription isKindOfClass:[NSNull class]]) {
                cell.premise.text = voucher.policyDescription;
            }else{
                cell.premise.text = @"";
            }
            if ([voucher.useCounttype isEqual:@1]) {
                cell.state.text = @"单";
            }else if([voucher.useCounttype isEqual:@2]) {
                cell.state.text = @"多";
            }
            cell.validDate.text = voucher.invalidDate;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMVoucherMoreViewController *voucherMore = [[[NSBundle mainBundle]loadNibNamed:@"KMVoucherMoreViewController" owner:nil options:nil]objectAtIndex:0];
    voucherMore.title = @"代金券详情";
    if ([tableView isEqual:_leftTableView]) {
        voucherMore.voucher = [_leftList objectAtIndex:indexPath.row];
    }else if([tableView isEqual:_rightTableView]){
        voucherMore.voucher = [_rightList objectAtIndex:indexPath.row];
        [voucherMore setBtnClose];
    }
    [self.navigationController pushViewController:voucherMore animated:YES];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
