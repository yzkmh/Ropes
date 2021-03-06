//
//  KMMyInfoViewController.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/4/2.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMMyInfoViewController.h"
#import "KMUserManager.h"
#import "KMLForgetPwdController.h"

@interface KMMyInfoViewController()
@property (weak, nonatomic) IBOutlet UIImageView *portraitImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;

@property (weak, nonatomic) IBOutlet UIButton *editMyInfoBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetPasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end

@implementation KMMyInfoViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
forBarMetrics:UIBarMetricsDefault];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.portraitImage.image = [UIImage imageNamed:@"touxiang"];
    self.portraitImage.layer.cornerRadius = self.portraitImage.bounds.size.width * 0.5;
    self.portraitImage.layer.masksToBounds = YES;
    
    self.nameLabel.text = [KMUserManager getInstance].currentUser.name;
    self.phoneNumLabel.text = [KMUserManager getInstance].currentUser.phone;
}

- (IBAction)editMyInfoBtnClick:(id)sender {
    
    [self performSegueWithIdentifier:@"myInfoToEditInfo" sender:self];
}
- (IBAction)resetPwdBtnClick:(id)sender {
    // 跳转到重置密码界面
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"KMLogin" bundle:nil];
    KMLForgetPwdController *forgetPwd = [storyboard instantiateViewControllerWithIdentifier:@"KMLForgetPwd"];
    [self.navigationController pushViewController:forgetPwd animated:YES];
}
- (IBAction)logoutBtnClick:(id)sender {
    // 跳转回登录界面
    [NSKeyedArchiver archiveRootObject:nil toFile:kPATH];
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

@end
