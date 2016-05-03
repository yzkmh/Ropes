//
//  KMCouponViewController.m
//  Ropes
//
//  Created by yzk on 16/3/26.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMCouponViewController.h"
#import "KMVoucherViewController.h"
#import "KMAuthenticationViewController.h"
#import "KMCouponCell.h"
#import "UIImage+reSize.h"
//彩票 代金券 折扣券  身份认证

#import "KMLotteryViewController.h"



@interface KMCouponViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *items;
    NSArray *e_items;
    NSArray *imageArray;
    KMLotteryViewController *_lotteryView;
    KMVoucherViewController *_voucherView;
    KMAuthenticationViewController *_authenticationView;
}

@end

@implementation KMCouponViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:nil];
    self.navigationItem.rightBarButtonItem = searchBtn;
    [self initArray];
    if(KMMainScreenBounds.size.height >= 667){
        self.tableView.scrollEnabled = NO;
    }
    self.tableView.showsVerticalScrollIndicator = NO;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 110;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *myHeaderView = [[UIView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 110)];
    imageView.image = [UIImage imageNamed:@"ma"];
    [myHeaderView addSubview:imageView];
    return myHeaderView;
}


- (void)initArray
{
    items = @[@"彩票",@"代金券",@"折扣券",@"身份认证"];
    e_items = @[@"lottery",@"cash coupon",@"discount coupon",@"identify authentication"];
    imageArray = [NSArray arrayWithObjects:[UIImage reSizeImage:[UIImage imageNamed:@"lottery"] toSize:CGSizeMake(80, 80)],
                  [UIImage reSizeImage:[UIImage imageNamed:@"cardIcon"] toSize:CGSizeMake(80, 80)],
                  [UIImage reSizeImage:[UIImage imageNamed:@"cut"] toSize:CGSizeMake(80, 80)],
                  [UIImage reSizeImage:[UIImage imageNamed:@"infoIcon"] toSize:CGSizeMake(80, 80)] ,nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMCouponCell *cell = nil;
    static NSString *serviceCellIdentifier = @"CoupnCellIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:serviceCellIdentifier];
    if (cell == nil) {
        cell = [KMCouponCell couponCellWithTableView:tableView];
        cell.typeLabel.text = [items objectAtIndex:indexPath.row];
        cell.e_typeLabel.text = [e_items objectAtIndex:indexPath.row];
        cell.logoImageView.image = [imageArray objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.usableNum.text = @"(0)";
        cell.usableNum.text = @"(0)";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        _lotteryView = [[KMLotteryViewController alloc]initWithNibName:nil bundle:nil];
        [_lotteryView setTitle:@"彩票"];
        
        [self.navigationController pushViewController:_lotteryView animated:YES];
    }else if(indexPath.row == 1)
    {
        _voucherView = [[KMVoucherViewController alloc]initWithNibName:nil bundle:nil];
        [_voucherView setTitle:@"代金券"];
        
        [self.navigationController pushViewController:_voucherView animated:YES];
    }else if(indexPath.row == 2)
    {
        
    }else if (indexPath.row == 3)
    {
        _authenticationView = [[KMAuthenticationViewController alloc]initWithNibName:nil bundle:nil];
        [_authenticationView setTitle:@"身份认证"];
        
        [self.navigationController pushViewController:_authenticationView animated:YES];
    }
    

}







@end