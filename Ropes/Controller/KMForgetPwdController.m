//
//  KMForgetPwdController.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/3/27.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMForgetPwdController.h"
#import "KMUserManager.h"
#import <QuartzCore/QuartzCore.h>
#import "LCProgressHUD.h"
@interface KMForgetPwdController()
{
    UILabel *LBtimeoff;
    NSTimer *timer;
    int timeleft;
}
@property (weak, nonatomic) IBOutlet UITextField *verificationTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;


@end

@implementation KMForgetPwdController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resetTextField];
    [self initPhoneNum];
}


- (void)initPhoneNum
{
    if ([KMUserManager getInstance].currentUser.phone)
    {
        self.phoneNumTextField.text = [KMUserManager getInstance].currentUser.phone;
        [self.phoneNumTextField setUserInteractionEnabled:NO];
//        self.phoneNumTextField.alpha = 0;
//        
//        CGRect frame = self.view.frame;
//        frame.origin.y -= 60;
//        [self.view setFrame:frame];
    }
}

- (void)resetTextField {
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.verificationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma makr 添加等待时间
- (void)addTimeOff:(UIButton *)view
{
    if (timer) {
        [timer invalidate];
        timer = nil;
        
    }
    if (!LBtimeoff) {
        LBtimeoff = [[UILabel alloc]initWithFrame:view.bounds];
        [LBtimeoff  setBackgroundColor:[UIColor colorWithRed:0.851 green:0.871 blue:0.902 alpha:1]];
        [LBtimeoff setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
        [LBtimeoff setTextAlignment:NSTextAlignmentCenter];
        
        LBtimeoff.layer.masksToBounds = YES;
        LBtimeoff.layer.cornerRadius = 3.0;
        LBtimeoff.layer.borderWidth = 1.0;
        LBtimeoff.layer.borderColor = [[UIColor whiteColor] CGColor];
    }
    [view setEnabled:NO];
    [LBtimeoff setText:@"90s"];
    [view addSubview:LBtimeoff];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    timeleft = 90;
    [timer fire];
}
- (void)onTimer
{
    timeleft --;
    [LBtimeoff setText:[NSString stringWithFormat:@"%ds",timeleft]];
    if (timeleft == 0) {
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        [_getVerificationCodeBtn setEnabled:YES];
        [LBtimeoff removeFromSuperview];
    }
}



- (BOOL)verifyRegist
{
    if (![self verifyPhoneNum]) {
        NSLog(@"手机号码格式有误");
        [LCProgressHUD showFailure:@"手机号码格式有误"];
        return NO;
    }

    if (self.verificationTextField.text.length != 6) {
        [LCProgressHUD showFailure:@"输入短信验证码有误"];
        return NO;
    }
    else if (self.passwordTextField.text.length < 6) {
        [LCProgressHUD showFailure:@"密码至少为六位"];
        return NO;
    }
    else {
        return YES;
    }
}
- (BOOL)verifyPhoneNum
{
    
    NSString *pattern = @"^[1][3-8]+\\d{9}";
    //正则表达式对象
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:nil];
    
    NSArray *results = [regex matchesInString:self.phoneNumTextField.text options:NSMatchingReportCompletion range:NSMakeRange(0, self.phoneNumTextField.text.length)];
    
    if (results.count == 0) {
        return NO;
    }
    else {
        return YES;
    }
}

- (IBAction)getPhoneCode:(id)sender {
        //添加90等待提示框
    [self addTimeOff:_getVerificationCodeBtn];
    self.getVerificationCodeBtn.titleLabel.text = @"重新获取";
    [[KMUserManager getInstance] getPhoneCodeWithPhoneNum:self.phoneNumTextField.text andType:@"2" complation:^(BOOL result, NSString *message, id user) {
            if (result) {
                [LCProgressHUD showSuccess:message];
            }
        }];
}


- (IBAction)cancelBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)ensureBtnClick:(id)sender {
    if ([self verifyRegist]) {
        
        [[KMUserManager getInstance] resetPasswordWithPhoneNum:self.phoneNum                                               verifyPhoneCode:self.verificationTextField.text
                                                      password:self.passwordTextField.text
                                                     comlation:^(BOOL result, NSString *message, id user) {
                                                         if (result) {
                                                             [LCProgressHUD showSuccess:message];
                                                             [self.navigationController popViewControllerAnimated:YES];
                                                         } else {
                                                             if (message) {
                                                                 [LCProgressHUD showFailure:message];
                                                                 return;
                                                             }
                                                             [LCProgressHUD showFailure:@"服务器异常, 请稍后重试"];

                                                         }
        }];
    }
    
}

@end
