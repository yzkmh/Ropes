//
//  KMMyInfoViewController.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/4/2.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMMyInfoViewController.h"
#import "KMUserManager.h"
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
    [self performSegueWithIdentifier:@"myInfoToForgetPwd" sender:self];
}
- (IBAction)logoutBtnClick:(id)sender {
    // 跳转回登录界面
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

@end
