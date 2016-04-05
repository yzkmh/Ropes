//
//  KMLotteryMoreViewController.m
//  Ropes
//
//  Created by yzk on 16/4/2.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMLotteryMoreViewController.h"



@interface KMLotteryMoreViewController ()<UITableViewDataSource ,UITableViewDelegate>
{
    UITableView *_tableView;
    
}
@end

@implementation KMLotteryMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.showView.frame.origin.y+self.showView.frame.size.height, self.view.frame.size.width, 120)];
    [_tableView setDataSource:self];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
        cell.textLabel.text = @"发送彩票短信";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 1)
    {
        cell = [[UITableViewCell alloc]init];
        cell.textLabel.text = @"兑换商家";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
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
