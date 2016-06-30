//
//  KMAddBankcardViewController.m
//  Ropes
//
//  Created by Madoka on 16/5/13.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMAddBankcardViewController.h"
#import "KMUserManager.h"
#import "LCProgressHUD.h"
#import "NSString+MD5.h"
#import "KMRequestCenter.h"
@interface KMAddBankcardViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    BOOL pickerOpen;
    BOOL _isRequest;
}
@property (weak, nonatomic) IBOutlet UILabel *bankname;
@property (weak, nonatomic) IBOutlet UITextField *cardnumTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phonenumTextField;

@property (weak, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *banks;
@property (strong, nonatomic) NSArray *bankCodeArray;
@property (copy, nonatomic) NSString *bankCode;
@end

@implementation KMAddBankcardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bankname.text = [KMUserManager getInstance].currentUser.bankname;
    self.banks = [NSArray arrayWithObjects:@"中国银行",@"中国工商银行",@"中国建设银行", nil];
    self.bankCode = @"3";
}

-(void)viewDidAppear:(BOOL)animated
{
    if (!_isRequest) {
        NSString *phone = [KMUserManager getInstance].currentUser.phone;
        NSString *session =[KMUserManager getInstance].currentUser.sessionid;
        NSString *sessionpwd =  [session md5WithTimes:6];
        
        
        [KMRequestCenter requestForBankListWithphone:phone sessionId:session sessionidpwd:sessionpwd success:^(NSDictionary *dic) {
            NSMutableArray *array = [NSMutableArray new];
            NSMutableArray *codeArray = [NSMutableArray new];
            for (NSDictionary *bankinfo in dic) {
                [array addObject:[bankinfo objectForKey:@"dictdataName"]];
                [codeArray addObject:[bankinfo objectForKey:@"dictdataValue"]];
            }
            self.banks = [array copy];
            self.bankCodeArray = [codeArray copy];
            _isRequest =YES;
        } failure:^(int code, NSString *result) {
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addBtnClick:(id)sender {
    if (![self verifyCardNum])
    {
        [LCProgressHUD showFailure:@"输入银行卡号有误"];
        return;
    }
    if (![self verifyPhoneNum])
    {
        [LCProgressHUD showFailure:@"输入手机号有误"];
        return;
    }
    if (![self verifyName])
    {
        [LCProgressHUD showFailure:@"请输入姓名"];
        return;
    }
    NSString *sessionId = [KMUserManager getInstance].currentUser.sessionid;
    NSString *sessionIdPwd = [sessionId md5WithTimes:6];

//    NSString *bank = nil;
//    if ([self.bankname.text isEqualToString:@"中国银行"]) {
//        bank = @"1";
//    }
//    else if ([self.bankname.text isEqualToString:@"中国工商银行"]) {
//        bank = @"2";
//    }
//    else if ([self.bankname.text isEqualToString:@"中国建设银行"]) {
//        bank = @"3";
//    }
    
    [KMRequestCenter requestForDoInsertBankInfo:self.phonenumTextField.text
                                      sessionId:sessionId
                                   sessionidpwd:sessionIdPwd
                                           bank:self.bankCode
                                       bankcard:self.cardnumTextField.text
                                        success:^(NSDictionary *resultDic) {
                                            
                                            BOOL status = [[resultDic objectForKey:@"status"] boolValue];
                                            if (status)
                                            {
                                                [LCProgressHUD showSuccess:@"添加成功"];
                                                
                                                
                                            } else
                                            {
                                                [LCProgressHUD showFailure:[resultDic objectForKey:@"msg"]];
                                            }
        
    } failure:nil];
    
}

- (IBAction)choseBankBtnClick:(id)sender {
    if (!pickerOpen) {
        if (self.pickerView) {
            return;
        }
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 154, KMMainScreenBounds.size.width, 150)];
        pickerView.backgroundColor = [UIColor whiteColor];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        
        [self.view addSubview:pickerView];
        self.pickerView = pickerView;
        pickerOpen = YES;
        return;
    }
    [self.pickerView removeFromSuperview];
    pickerOpen = NO;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1; // 返回1表明该控件只包含1列
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.banks.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    self.bankCode = [self.bankCodeArray objectAtIndex:row];
    return [_banks objectAtIndex:row];
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.bankname.text = [_banks objectAtIndex:row];
}
- (void)SingleTap
{
    [self.pickerView removeFromSuperview];
}

- (BOOL)verifyPhoneNum
{
    
    NSString *pattern = @"^[1][3-8]+\\d{9}";
    //正则表达式对象
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:nil];
    
    NSArray *results = [regex matchesInString:self.phonenumTextField.text options:NSMatchingReportCompletion range:NSMakeRange(0, self.phonenumTextField.text.length)];
    
    if (results.count == 0) {
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)verifyCardNum
{
    
    NSString *pattern = @"\\d{16}|\\d{19}";
    //正则表达式对象
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:nil];
    
    NSArray *results = [regex matchesInString:self.cardnumTextField.text options:NSMatchingReportCompletion range:NSMakeRange(0, self.cardnumTextField.text.length)];
    
    if (results.count == 0) {
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)verifyName
{
    if (self.nameTextField.text.length == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)requestForAddBankCard
{
    
}
@end
