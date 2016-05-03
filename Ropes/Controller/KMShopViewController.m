//
//  KMShopViewController.m
//  Ropes
//
//  Created by yzk on 16/4/6.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMShopViewController.h"
#import "KMShopCell.h"

@interface KMShopViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
}

@end

@implementation KMShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.941 green:0.945 blue:0.949 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+20+10, self.view.frame.size.width, 300)];
    [_table setDelegate:self];
    [_table setDataSource:self];
    
    [self.view addSubview:_table];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMShopCell *cell = nil;
    static NSString *cellIdentifier = @"KMShopCell";
    //KMCouponItem *item = [items objectAtIndex:indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"KMShopCell" owner:self options:nil]objectAtIndex:0];
    }
    return cell;
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
