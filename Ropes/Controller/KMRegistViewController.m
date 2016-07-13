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
#import "KMRulersController.h"
@interface KMRegistViewController ()<UITextFieldDelegate>
{
    UILabel *LBtimeoff;
    NSTimer *timer;
    int timeleft;
    BOOL isRequest;
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
    self.phoneNumTextField.delegate = self;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.verificationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.getVerificationCodeBtn.layer.masksToBounds = YES;
    self.getVerificationCodeBtn.layer.cornerRadius = 3.0;
    self.getVerificationCodeBtn.layer.borderWidth = 1.0;
    self.getVerificationCodeBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
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
    [self.view endEditing:YES];
}
//获取验证码
- (IBAction)getPhoneCode:(id)sender
{
    //验证密码有效性
    if ([self verifyPhoneNum] && !isRequest) {
        
        isRequest = YES;
        [[KMUserManager getInstance] getPhoneCodeWithPhoneNum:self.phoneNumTextField.text andType:@"1" complation:^(BOOL result, NSString *message, id user) {
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
                                                      [KMUserManager getInstance].currentUser = user;
                                                      [LCProgressHUD showSuccess:message];
                                                      [UIView animateWithDuration:0.0 delay:0.3 options:UIViewAnimationOptionLayoutSubviews animations:^{
                                                          [self.navigationController popViewControllerAnimated:YES];
                                                      } completion:nil];
                                                      
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
    [view setTitle:@"重新获取" forState:UIControlStateNormal];
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
- (IBAction)rulersBtnClick:(id)sender {
    KMRulersController *ruler = [[KMRulersController alloc] initWithNibName:@"KMRulers" bundle:[NSBundle mainBundle]];
    [self presentViewController:ruler animated:YES completion:nil];
}

#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (self.phoneNumTextField == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 11) { //如果输入框内容大于11则弹出警告
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    return YES;
}

@end
