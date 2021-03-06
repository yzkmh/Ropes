//
//  KMLForgetPwdController.m
//  Ropes
//
//  Created by sunsea on 16/7/13.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMLForgetPwdController.h"
#import "KMUserManager.h"
#import <QuartzCore/QuartzCore.h>
#import "LCProgressHUD.h"

@interface KMLForgetPwdController ()
{
    UILabel *LBtimeoff;
    NSTimer *timer;
    int timeleft;
    BOOL isRequest;
}
@property (weak, nonatomic) IBOutlet UITextField *verificationTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@end

@implementation KMLForgetPwdController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
forBarMetrics:UIBarMetricsDefault];
    [self resetTextField];
    self.phoneNum = [KMUserManager getInstance].currentUser.phone;
}
- (void)resetTextField {
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.verificationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.getVerificationCodeBtn.backgroundColor = [UIColor colorWithRed:0.894 green:0.173 blue:0.227 alpha:1];
    self.getVerificationCodeBtn.layer.masksToBounds = YES;
    self.getVerificationCodeBtn.layer.cornerRadius = 3.0;
    self.getVerificationCodeBtn.layer.borderWidth = 1.0;
    self.getVerificationCodeBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma makr 添加等待时间
- (void)addTimeOff:(UIButton *)view
{
    [view setTitle:@"重新获取" forState:UIControlStateNormal];
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
    
    NSArray *results = [regex matchesInString:self.phoneNum options:NSMatchingReportCompletion range:NSMakeRange(0, self.phoneNum.length)];
    
    if (results.count == 0) {
        return NO;
    }
    else {
        return YES;
    }
}
- (IBAction)getPhoneCode:(id)sender {
    //添加90等待提示框
    if ([self verifyPhoneNum] && !isRequest) {
        isRequest = YES;
        [[KMUserManager getInstance] getPhoneCodeWithPhoneNum:self.phoneNum andType:@"2" complation:^(BOOL result, NSString *message, id user) {
            isRequest = NO;
            if (result) {
                //添加90等待提示框
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self addTimeOff:_getVerificationCodeBtn];
                });
                [LCProgressHUD showSuccess:message];
            }else{
                [LCProgressHUD showFailure:message];
            }
        }];
    }
}


- (IBAction)cancelBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)ensureBtnClick:(id)sender {
    if ([self verifyRegist]) {
        
        [[KMUserManager getInstance] resetPasswordWithPhoneNum:self.phoneNum                                              verifyPhoneCode:self.verificationTextField.text
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
