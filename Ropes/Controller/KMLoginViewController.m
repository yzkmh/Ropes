//
//  KMLoginViewController.m
//  Ropes
//
//  Created by Madoka on 16/3/2.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMLoginViewController.h"
#import "KMUserManager.h"
#import "KMAlertView.h"
#import "KMUser.h"
#import "LCProgressHUD.h"
@interface KMLoginViewController ()<KMAlertViewDelegate,UITextFieldDelegate>
{
    int times;
}

@property (nonatomic, strong) KMUser *user;


@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;


@property (weak, nonatomic) KMAlertView *alertView;
@end

@implementation KMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetNavigationBar];
    [self resetSelectBtn];
    [self resetTextField];
}
- (void)resetTextField
{
    self.phoneNumTextField.delegate = self;
    //     读取本地账号信息
    KMUser *localUser = [NSKeyedUnarchiver unarchiveObjectWithFile:kPATH];
    
    if (localUser) {
        self.phoneNumTextField.text = localUser.phone;
        if (localUser.isRememberPwd) {
            self.passwordTextField.text = localUser.pwd;
        }else{
            self.passwordTextField.text = @"";
        }
    }else{
        self.phoneNumTextField.text = @"";
        self.passwordTextField.text = @"";
    }
    
    if (localUser.isAutoLogin) {
        if ([self checkLoginDateValidityWithDate:localUser.loginDate]) {
            localUser.isRememberPwd = NO;
            localUser.isAutoLogin = NO;
            self.passwordTextField.text = @"";
            [NSKeyedArchiver archiveRootObject:self.user toFile:kPATH];
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"由于你长时间未登录，请重新输入密码" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil] show];
        }else{
            [self loginBtnClick:nil];
        }
    }
}

/**
 *  验证登录有效性 30天
 *
 *  @param date 上次登录时间
 *
 *  @return
 */
- (BOOL)checkLoginDateValidityWithDate:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:date toDate:[NSDate date] options:0];
    BOOL result = NO;
    if (d.hour >30*24) {
        result = YES;
    }
    return result;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    KMUser *localUser = [NSKeyedUnarchiver unarchiveObjectWithFile:kPATH];
    if (localUser) {
        self.phoneNumTextField.text = localUser.phone;
        if (localUser.isRememberPwd) {
            self.passwordTextField.text = localUser.pwd;
        }else{
            self.passwordTextField.text = @"";
        }
        
    }else{
        self.phoneNumTextField.text = @"";
        self.passwordTextField.text = @"";
    }
    [self resetSelectBtn];
}

/**
 *  重设导航栏
 */
- (void)resetNavigationBar
{
    // 设置右元素
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(loginToRegist:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    // 设置左元素
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] init];
    leftBtn.title = @"";
    self.navigationItem.backBarButtonItem = leftBtn;
}
- (void)resetSelectBtn
{
    KMUser *localUser = [NSKeyedUnarchiver unarchiveObjectWithFile:kPATH];
    if (localUser.isRememberPwd)
    {
        self.remeberPwdBtn.selected = YES;
    }else{
        self.remeberPwdBtn.selected = NO;
    }
    if (localUser.isAutoLogin)
    {
        self.autoLoginBtn.selected = YES;
    }else{
        self.autoLoginBtn.selected = NO;
    }
}
// 返回注册页面
- (void)loginToRegist:(id)sender
{
    [self performSegueWithIdentifier:@"loginToRegist" sender:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

// 忘记密码
- (IBAction)forgetPwdBtnClick:(id)sender {
    
    KMAlertView *alertView = [[KMAlertView alloc] initWithFrame:CGRectMake(0, 0, 250, 150) andDelegate:self];
    alertView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
    alertView.alpha = 0.0f;
    [self.view addSubview:alertView];
    [UIView animateWithDuration:0.2f animations:^{
        alertView.alpha = 1.0f;
    }];
    
    self.alertView = alertView;
}
// 登录
- (IBAction)loginBtnClick:(id)sender {
    
    if ([self verifyLogin]) {
        [LCProgressHUD showLoading:nil];
        [[KMUserManager getInstance] loginWithPhoneNum:self.phoneNumTextField.text
                                              password:self.passwordTextField.text
                                             comlation:^(BOOL result, NSString *message, id user) {
            
                                                 if (result) {
                                                     times = 0;
                                                     self.user = user;
                                                     [LCProgressHUD showSuccess:@"登陆成功"];
                                                     
                                                     if ([self.remeberPwdBtn isSelected]) {
                                                         self.user.isRememberPwd = YES;
                                                     }
                                                     if ([self.autoLoginBtn isSelected]) {
                                                         self.user.isAutoLogin = YES;
                                                     }
                                                     self.user.pwd = self.passwordTextField.text;
                                                     self.user.loginDate = [NSDate date];
                                                     // 保存账号到本地
                                                     [NSKeyedArchiver archiveRootObject:self.user toFile:kPATH];
                                                     
                                                     [KMUserManager getInstance].currentUser = user;
                                                     
                                                     [LCProgressHUD hide];
                                                     [self performSegueWithIdentifier:@"loginToTabBar" sender:self];
                                                     
                                                 } else {
                                                     times ++;
                                                     if (times == 3) {
                                                         times =0;
                                                         [LCProgressHUD hide];
                                                         KMAlertView *alertView = [[KMAlertView alloc] initWithFrame:CGRectMake(0, 0, 250, 150) andDelegate:self];
                                                         alertView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
                                                         alertView.alpha = 0.0f;
                                                         [self.view addSubview:alertView];
                                                         [UIView animateWithDuration:0.2f animations:^{
                                                             alertView.alpha = 1.0f;
                                                         }];
                                                         self.alertView = alertView;
                                                         
                                                         return ;
                                                     }else{
                                                         if (message) {
                                                             [LCProgressHUD showFailure:message];
                                                             return;
                                                         }
                                                     }
                                                     [LCProgressHUD showFailure:@"服务器异常, 请稍后重试"];
                                                 }
                                             }];
    }
    
}


- (IBAction)remeberBtnClick:(id)sender {
    
    self.remeberPwdBtn.selected = !self.remeberPwdBtn.selected;
    if (![self.remeberPwdBtn isSelected]) {
        self.autoLoginBtn.selected = NO;
    }
}

- (IBAction)autoLoginBtnClick:(id)sender {
    
    self.autoLoginBtn.selected = !self.autoLoginBtn.selected;
    
    if ([self.autoLoginBtn isSelected]) {
        self.remeberPwdBtn.selected = YES;
    }
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

#pragma mark - 验证输入格式
// 手机格式
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
- (BOOL)verifyLogin
{
    if (![self verifyPhoneNum]) {
        NSLog(@"手机号码格式有误");
        [LCProgressHUD showFailure:@"手机号码格式有误"];
        return NO;
    }
    else if (self.passwordTextField.text.length < 6) {
        NSLog(@"密码小于6位");
        [LCProgressHUD showFailure:@"密码小于6位"];
        return NO;
    }
    else {
        return YES;
    }
}


#pragma mark - KMAlertView Delegate
- (void)KMAlertView:(KMAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [UIView animateWithDuration:0.2f animations:^{
            self.alertView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.alertView removeFromSuperview];
        }];
        
    } else {
        [self.alertView removeFromSuperview];
        [self performSegueWithIdentifier:@"loginToForgetPwd" sender:self];
    }
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    
//    if([segue.identifier isEqualToString:@"loginToForgetPwd"])
//    {
//        
//        id theSegue = segue.destinationViewController;
//        
//        [theSegue setValue:self.phoneNumTextField.text forKey:@"phoneNum"];
//        
//    }           
//    
//}


@end
