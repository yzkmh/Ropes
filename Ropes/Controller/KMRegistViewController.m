//
//  KMRegistViewController.m
//  Ropes
//
//  Created by Madoka on 16/3/1.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMRegistViewController.h"
#import "KMUserManager.h"
#import <QuartzCore/QuartzCore.h>
#import "LCProgressHUD.h"
@interface KMRegistViewController ()
{
    UILabel *LBtimeoff;
    NSTimer *timer;
    int timeleft;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeWithRullerBtn;

@end

@implementation KMRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.agreeWithRullerBtn.selected = YES;
    [self resetTextField];
    [self resetNavigationBar];
}

- (void)resetTextField {
    self.phoneNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.verificationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)resetNavigationBar
{
    // 设置右元素
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(popToLogin:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}
- (void)popToLogin:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.phoneNumTextField resignFirstResponder];
    [self.verificationTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}
//获取验证码
- (IBAction)getPhoneCode:(id)sender
{
    //验证密码有效性
    if ([self verifyPhoneNum]) {
        //添加60等待提示框
        [self addTimeOff:_getVerificationCodeBtn];
        [[KMUserManager getInstance] getPhoneCodeWithPhoneNum:self.phoneNumTextField.text complation:^(BOOL result, NSString *message, id user) {
            if (result) {
                [LCProgressHUD showSuccess:message];
            }
        }];
    } else {
        [LCProgressHUD showFailure:@"手机号码输入有误"];
        NSLog(@"手机号码输入有误");
    
    }
    
}
//注册
- (IBAction)registAction:(id)sender
{
    //验证注册信息有效性
    if ([self verifyRegist]) {
        
        [[KMUserManager getInstance] registWithPhoneNum:self.phoneNumTextField.text
                                        verifyPhoneCode:self.verificationTextField.text
                                               password:self.passwordTextField.text
                                              comlation:^(BOOL result, NSString *message, id user) {
                                        
                                                  if (result) {
                                                      [LCProgressHUD showSuccess:message];
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
- (IBAction)agreeWithRullerBtnClick:(id)sender {
    
    self.agreeWithRullerBtn.selected = !self.agreeWithRullerBtn.selected;
    
    if (self.agreeWithRullerBtn.selected) {
        self.registBtn.enabled = YES;
    } else {
        self.registBtn.enabled = NO;
    }
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
        [LBtimeoff setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        [LBtimeoff setTextColor:[UIColor whiteColor]];
        [LBtimeoff setTextAlignment:NSTextAlignmentCenter];
        
//        LBtimeoff.layer.masksToBounds = YES;
//        LBtimeoff.layer.cornerRadius = 3.0;
        LBtimeoff.layer.borderWidth = 1.0;
        LBtimeoff.layer.borderColor = [[UIColor whiteColor] CGColor];
    }
    [view setEnabled:NO];
    [LBtimeoff setText:@"60s"];
    [view addSubview:LBtimeoff];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    timeleft = 60;
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

- (BOOL)verifyRegist
{
    if (![self verifyPhoneNum]) {
        
        [LCProgressHUD showFailure:@"手机号码输入有误"];
        return NO;
    }
    else if (self.verificationTextField.text.length != 6) {
        
        [LCProgressHUD showFailure:@"输入短信验证码有误"];
        return NO;
    }
    else if (self.passwordTextField.text.length < 6) {
        
        [LCProgressHUD showFailure:@"请输入密码"];
        return NO;
    }
    else {
        return YES;
    }
}

@end
