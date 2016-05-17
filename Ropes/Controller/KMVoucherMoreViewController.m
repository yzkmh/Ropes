//
//  KMVoucherMoreViewController.m
//  Ropes
//
//  Created by yzk on 16/4/6.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMVoucherMoreViewController.h"
#import "KMShopViewController.h"
#import "LCProgressHUD.h"
#import "KMViewsMannager.h"
#import "KMHistoryViewController.h"


@interface KMVoucherMoreViewController()<UITableViewDataSource ,UITableViewDelegate>
@end


@implementation KMVoucherMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView setFrame:CGRectMake(0, self.showView.frame.origin.y+self.showView.frame.size.height +20, self.view.frame.size.width, 80)];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    
    
    [self.view addSubview:_tableView];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setVoucher:(KMVoucher *)voucher
{
    _voucher = voucher;
    self.titleLb.text = self.voucher.senceName;
    self.price.text = self.voucher.policyName;
    self.condition.text = self.voucher.invalidDate;
    if (![self.voucher.policyDescription isKindOfClass:[NSNull class]]) {
        self.rule.text = self.voucher.policyDescription;
    }else{
        self.rule.text = @"";
    }
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
        cell.textLabel.text = @"可使用门店";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 1)
    {
        cell = [[UITableViewCell alloc]init];
        cell.textLabel.text = @"使用记录";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//
//{
//
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
//
//    v.backgroundColor = [UIColor clearColor];
//
//    return v;
//
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        KMShopViewController *shopView = [[KMShopViewController alloc]init];
        [shopView setTitle:@"商家详情"];
        shopView.tcode = _voucher.tcode;
        shopView.type = 2;
        [self.navigationController pushViewController:shopView animated:YES];
    }else if(indexPath.row == 1)
    {
        KMHistoryViewController *history = [[KMHistoryViewController alloc]init];
        [history setTitle:@"使用记录"];
        history.tcode = _voucher.tcode;
        history.type = 2;
        [self.navigationController pushViewController:history animated:YES];
    }
}

- (IBAction)btnMakeUse:(id)sender
{
    [LCProgressHUD showLoading:@"正在发送信息"];
    
    [[KMViewsMannager getInstance]sendConponMessageWithtcode:_voucher.tcode comlation:^(BOOL result, NSString *message) {
        if (result) {
            [LCProgressHUD showSuccess:@"发送成功"];
        }else{
            [LCProgressHUD showFailure:message];
        }
    }];
}
- (void)setBtnClose
{
    [self.useBtn setTitle:@"已过期" forState:UIControlStateNormal];
    [self.useBtn setBackgroundColor:[UIColor grayColor]];
    [self.useBtn setUserInteractionEnabled:NO];
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
