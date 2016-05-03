//
//  KMAuthenticationMoreViewController.m
//  Ropes
//
//  Created by yzk on 16/4/8.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMAuthenticationMoreViewController.h"
#import "KMShopViewController.h"

@interface KMAuthenticationMoreViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation KMAuthenticationMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView setFrame:CGRectMake(0, self.showView.frame.origin.y+self.showView.frame.size.height +20, self.view.frame.size.width, 40)];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        cell = [[UITableViewCell alloc]init];
        cell.textLabel.text = @"可使用门店";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section

{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
    
    v.backgroundColor = [UIColor clearColor];
    
    return v;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        KMShopViewController *shopView = [[KMShopViewController alloc]init];
        [shopView setTitle:@"商家详情"];
        [self.navigationController pushViewController:shopView animated:YES];
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
