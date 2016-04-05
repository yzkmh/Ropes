//
//  KMEditInfoViewController.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/4/3.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMEditInfoViewController.h"
#import "KMUserManager.h"
#import "KMUser.h"
#import "LCProgressHUD.h"

@interface KMEditInfoViewController()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@end

@implementation KMEditInfoViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resetTextField];
    [self resetNavigationBar];
}

- (void)resetTextField
{
    
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.genderTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    KMUser *currentUser = [KMUserManager getInstance].currentUser;
    self.nameTextField.text = currentUser.name;
    self.phoneNumTextField.text = currentUser.phone;
    if (currentUser.gender == 1) {
        self.genderTextField.text = @"男";
    } else if (currentUser.gender == 2) {
        self.genderTextField.text = @"女";
    }
    self.addressTextField.text = currentUser.address;
}

- (void)resetNavigationBar
{
    // 设置左元素
//    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(editMyInfo)];
//    self.navigationItem.leftBarButtonItem = leftBtn;
    
    CGRect backframe = CGRectMake(0,0,10,19);
    UIButton *backButton = [[UIButton alloc] initWithFrame:backframe];
    [backButton addTarget:self action:@selector(editMyInfo) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)editMyInfo
{
    int gender = 0;
    if ([self.genderTextField.text isEqualToString:@"男"]) {
        gender = 1;
    } else if ([self.genderTextField.text isEqualToString:@"女"]) {
        gender = 2;
    }
    
    KMUser *user = [KMUserManager getInstance].currentUser;
    
    if (!user.name) {
        user.name = @"";
    }
    if (!user.address) {
        user.address = @"";
    }
    if (!user.phone) {
        user.phone = @"";
    }
    
    if ([self.nameTextField.text isEqualToString:user.name] &&
        [self.phoneNumTextField.text isEqualToString:user.phone] &&
        gender == user.gender &&
        [self.addressTextField.text isEqualToString:user.address]) {
            [self.navigationController popViewControllerAnimated:YES];
    } else {
        [[KMUserManager getInstance] UpdateDetailWithName:self.nameTextField.text
                                                    phone:self.phoneNumTextField.text
                                                   gender:gender
                                                  address:self.addressTextField.text
                                                comlation:^(BOOL result, NSString *message, id user) {
                                                    
                                                    if (result) {
                                                        [LCProgressHUD showSuccess:message];
                                                        [KMUserManager getInstance].currentUser = user;
                                                    } else {
                                                        [LCProgressHUD showFailure:message];
                                                    }
                                                    [self.navigationController popViewControllerAnimated:YES];
                                                }];

    }
}
@end
