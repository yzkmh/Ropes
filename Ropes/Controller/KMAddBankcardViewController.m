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
//判断系统版本是否为参数版本
#define LKSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)

@interface KMAddBankcardViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
{
    BOOL pickerOpen;
    BOOL _isRequest;
    UIPickerView *_pickerView;
}
@property (weak, nonatomic) IBOutlet UILabel *bankname;
@property (weak, nonatomic) IBOutlet UITextField *cardnumTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phonenumTextField;
@property (weak, nonatomic) IBOutlet UIView *cardnumView;
@property (nonatomic,assign)           CGRect currentTFFrameBeforeKBShow;        //处理第三方键盘（搜狗）高度问题
@property (strong, nonatomic) NSArray *banks;
@property (strong, nonatomic) NSArray *bankCodeArray;
@property (copy, nonatomic) NSString *bankCode;
@end

@implementation KMAddBankcardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTextField];
    [self setNotification];
    [self setData];
    self.bankname.text = [KMUserManager getInstance].currentUser.bankname;
    self.banks = [NSArray arrayWithObjects:@"中国银行",@"中国工商银行",@"中国建设银行", nil];
    self.bankCode = @"3";
    
    //初始化银行名选择列表
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.cardnumView.frame.origin.y+self.cardnumView.frame.size.height, KMMainScreenBounds.size.width, 100)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.alpha = 0;
    [self.view addSubview:_pickerView];
    
}
- (void)setData
{
    if ([KMUserManager getInstance].isChangeBankInfo) {
        self.bankname.text = [KMUserManager getInstance].currentUser.bankname;
        self.cardnumTextField.text = [KMUserManager getInstance].currentUser.bankcard;
        self.nameTextField.text = [KMUserManager getInstance].currentUser.name;
        self.phonenumTextField.text = [KMUserManager getInstance].currentUser.phone;
        [KMUserManager getInstance].isChangeBankInfo = NO;
    }
}

- (void)setTextField
{
    self.cardnumTextField.delegate = self;
    self.nameTextField.delegate = self;
    self.phonenumTextField.delegate = self;
    
}
/**
 *  注册键盘监听
 */
- (void)setNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
            [_pickerView reloadAllComponents];
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
    KMUser *user = [KMUserManager getInstance].currentUser;
    if (![self.phonenumTextField.text isEqualToString:user.phone]) {
        [LCProgressHUD showFailure:@"填写手机号与当前用户绑定手机号不符"];
        return;
    }
    if (![self.nameTextField.text isEqualToString:user.name]) {
        [LCProgressHUD showFailure:@"填写姓名与当前用户姓名不符"];
        return;
    }
    if (![self verifyName])
    {
        [LCProgressHUD showFailure:@"请输入姓名"];
        return;
    }
    
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

    if (![[self backbankenameWithBanknumber:self.cardnumTextField.text]isEqualToString:self.bankname.text]) {
        [LCProgressHUD showFailure:@"银行卡号与银行名称不符"];
        return;
    }
    
    NSString *sessionId = [KMUserManager getInstance].currentUser.sessionid;
    NSString *sessionIdPwd = [sessionId md5WithTimes:6];
    
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
    if (_pickerView.alpha == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            _pickerView.alpha = 1;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            _pickerView.alpha = 0;
        }];
    }
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

#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (self.phonenumTextField == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 11) { //如果输入框内容大于11则弹出警告
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    if (self.cardnumTextField == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 19) { //如果输入框内容大于16则弹出警告
            textField.text = [toBeString substringToIndex:19];
            return NO;
        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (!self.view.superview) {
        return;
    }
    UIWindow *keyWindow             =   [[UIApplication sharedApplication] keyWindow];
    NSValue *rectValue              =   [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame                    =   [rectValue CGRectValue];
    
    CGFloat space                      = 0.0f;
    CGRect actionTFRect                = [self.phonenumTextField.superview convertRect:self.phonenumTextField.frame toView:keyWindow];
    
    if (CGRectEqualToRect(CGRectZero, self.currentTFFrameBeforeKBShow)) {
        self.currentTFFrameBeforeKBShow    = actionTFRect;
    }else{
        actionTFRect                       = self.currentTFFrameBeforeKBShow;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect windowFrame                 = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    CGFloat keyBoardHeight             = [self getKeyBoardHeight:frame];
    
    switch (orientation)
    {
        case UIInterfaceOrientationLandscapeLeft:
            
            space = CGRectGetMaxX(actionTFRect)-(CGRectGetWidth(windowFrame)-keyBoardHeight);
            if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0){
                //NSLog(@"%f",CGRectGetMaxY(actionTFRect));
                space = CGRectGetMaxY(actionTFRect) - (CGRectGetWidth(windowFrame)-keyBoardHeight);
            }
            break;
        case UIInterfaceOrientationLandscapeRight:
            space = keyBoardHeight-CGRectGetMinX(actionTFRect);
            if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0){
                space = CGRectGetMaxY(actionTFRect) - (CGRectGetWidth(windowFrame)-keyBoardHeight);
            }
            break;
        case UIInterfaceOrientationPortrait:
            space = CGRectGetMaxY(actionTFRect)-(CGRectGetHeight(windowFrame)-keyBoardHeight);
            
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            space = keyBoardHeight-CGRectGetMinY(actionTFRect);
            
            break;
        default:
            break;
    }
    
    
    if (space > 0.0f) {
        NSTimeInterval animationDuration=0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        //上移-Y
        CGRect rect=CGRectMake(0.0f,-space,width,height);
        self.view.frame=rect;
        [UIView commitAnimations];
    }
    
    
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    if (!self.view.superview) {
        return;
    }
    self.currentTFFrameBeforeKBShow    = CGRectZero;
    
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移-Y
    [self.view setCenter:CGPointMake(width/2, height/2)];
    [UIView commitAnimations];
    
}

#pragma tool
- (CGFloat)getKeyBoardHeight:(CGRect)keyboardFrame
{
    CGFloat keyboardHeight = 0.0f;
    if(LKSystemVersionGreaterOrEqualThan(8.0)){
        keyboardHeight = keyboardFrame.size.height;
        if (fabs(keyboardFrame.size.height - [[UIScreen mainScreen] bounds].size.height)<=0) {
            keyboardHeight = keyboardFrame.size.width;
        }
        if (fabs(keyboardFrame.size.height-[[UIScreen mainScreen] bounds].size.width)<=0) {
            keyboardHeight = keyboardFrame.size.height;
        }
    }else{
        if((UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) ){
            keyboardHeight = keyboardFrame.size.width;
        }else{
            keyboardHeight = keyboardFrame.size.height;
        }
    }
    return keyboardHeight;
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
/**
 *  判断银行卡号与开卡行是否相符
 *
 *  @param banknumber 卡号
 *
 *  @return 开卡银行
 */
-(NSString *)backbankenameWithBanknumber:(NSString *)banknumber{
    NSString *bankNumber = [banknumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary *dic;
    NSString *bank = @"";
    NSString *bank1 = @"";
    NSString *bank2 = @"";
    NSString *bankname;
    bank1 = [bankNumber substringToIndex:5];
    bank = [bankNumber substringToIndex:6];
    bank2 = [bankNumber substringToIndex:8];
    if (!dic) {
        dic = @{@"402791":@"工商银行",@"427028":@"工商银行",@"427038":@"工商银行",@"548259":@"工商银行",@"620200":@"工商银行",@"620302":@"工商银行",@"620402":@"工商银行",@"620403":@"工商银行",@"620404":@"工商银行",@"620405":@"工商银行",@"620406":@"工商银行",@"620407":@"工商银行",@"620408":@"工商银行",@"620409":@"工商银行",@"620410":@"工商银行",@"620411":@"工商银行",@"620412":@"工商银行",@"620502":@"工商银行",@"620503":@"工商银行",@"620512":@"工商银行",@"620602":@"工商银行",@"620604":@"工商银行",@"620607":@"工商银行",@"620609":@"工商银行",@"620611":@"工商银行",@"620612":@"工商银行",@"620704":@"工商银行",@"620706":@"工商银行",@"620707":@"工商银行",@"620708":@"工商银行",@"620709":@"工商银行",@"620710":@"工商银行",@"620711":@"工商银行",@"620712":@"工商银行",@"620713":@"工商银行",@"620714":@"工商银行",@"620802":@"工商银行",@"620904":@"工商银行",@"620905":@"工商银行",@"621101":@"工商银行",@"621102":@"工商银行",@"621103":@"工商银行",@"621105":@"工商银行",@"621106":@"工商银行",@"621107":@"工商银行",@"621202":@"工商银行",@"621203":@"工商银行",@"621204":@"工商银行",@"621205":@"工商银行",@"621206":@"工商银行",@"621207":@"工商银行",@"621208":@"工商银行",@"621209":@"工商银行",@"621210":@"工商银行",@"621211":@"工商银行",@"621302":@"工商银行",@"621303":@"工商银行",@"621304":@"工商银行",@"621305":@"工商银行",@"621306":@"工商银行",@"621307":@"工商银行",@"621308":@"工商银行",@"621309":@"工商银行",@"621311":@"工商银行",@"621313":@"工商银行",@"621315":@"工商银行",@"621317":@"工商银行",@"621402":@"工商银行",@"621404":@"工商银行",@"621405":@"工商银行",@"621406":@"工商银行",@"621407":@"工商银行",@"621408":@"工商银行",@"621409":@"工商银行",@"621410":@"工商银行",@"621502":@"工商银行",@"621511":@"工商银行",@"621602":@"工商银行",@"621603":@"工商银行",@"621604":@"工商银行",@"621605":@"工商银行",@"621606":@"工商银行",@"621607":@"工商银行",@"621608":@"工商银行",@"621609":@"工商银行",@"621610":@"工商银行",@"621611":@"工商银行",@"621612":@"工商银行",@"621613":@"工商银行",@"621614":@"工商银行",@"621615":@"工商银行",@"621616":@"工商银行",@"621617":@"工商银行",@"621804":@"工商银行",@"621807":@"工商银行",@"621813":@"工商银行",@"621814":@"工商银行",@"621817":@"工商银行",@"621901":@"工商银行",@"621903":@"工商银行",@"621904":@"工商银行",@"621905":@"工商银行",@"621906":@"工商银行",@"621907":@"工商银行",@"621908":@"工商银行",@"621909":@"工商银行",@"621910":@"工商银行",@"621911":@"工商银行",@"621912":@"工商银行",@"621913":@"工商银行",@"621914":@"工商银行",@"621915":@"工商银行",@"622002":@"工商银行",@"622003":@"工商银行",@"622004":@"工商银行",@"622005":@"工商银行",@"622006":@"工商银行",@"622007":@"工商银行",@"622008":@"工商银行",@"622009":@"工商银行",@"622010":@"工商银行",@"622011":@"工商银行",@"622012":@"工商银行",@"622013":@"工商银行",@"622014":@"工商银行",@"622015":@"工商银行",@"622016":@"工商银行",@"622017":@"工商银行",@"622018":@"工商银行",@"622019":@"工商银行",@"622020":@"工商银行",@"622102":@"工商银行",@"622103":@"工商银行",@"622104":@"工商银行",@"622105":@"工商银行",@"622110":@"工商银行",@"622111":@"工商银行",@"622114":@"工商银行",@"622302":@"工商银行",@"622303":@"工商银行",@"622304":@"工商银行",@"622305":@"工商银行",@"622306":@"工商银行",@"622307":@"工商银行",@"622308":@"工商银行",@"622309":@"工商银行",@"622313":@"工商银行",@"622314":@"工商银行",@"622315":@"工商银行",@"622317":@"工商银行",@"622402":@"工商银行",@"622403":@"工商银行",@"622404":@"工商银行",@"622502":@"工商银行",@"622504":@"工商银行",@"622505":@"工商银行",@"622509":@"工商银行",@"622510":@"工商银行",@"622513":@"工商银行",@"622517":@"工商银行",@"622604":@"工商银行",@"622605":@"工商银行",@"622606":@"工商银行",@"622703":@"工商银行",@"622706":@"工商银行",@"622715":@"工商银行",@"622806":@"工商银行",@"622902":@"工商银行",@"622903":@"工商银行",@"622904":@"工商银行",@"623002":@"工商银行",@"623006":@"工商银行",@"623008":@"工商银行",@"623011":@"工商银行",@"623012":@"工商银行",@"623014":@"工商银行",@"623015":@"工商银行",@"623100":@"工商银行",@"623202":@"工商银行",@"623301":@"工商银行",@"623400":@"工商银行",@"623500":@"工商银行",@"623602":@"工商银行",@"623700":@"工商银行",@"623803":@"工商银行",@"623901":@"工商银行",@"624000":@"工商银行",@"624100":@"工商银行",@"624200":@"工商银行",@"624301":@"工商银行",@"624402":@"工商银行",@"620058":@"工商银行",@"620516":@"工商银行",@"621225":@"工商银行",@"621226":@"工商银行",@"621227":@"工商银行",@"621281":@"工商银行",@"621288":@"工商银行",@"621721":@"工商银行",@"621722":@"工商银行",@"621723":@"工商银行",@"622200":@"工商银行",@"622202":@"工商银行",@"622203":@"工商银行",@"622208":@"工商银行",@"900000":@"工商银行",@"900010":@"工商银行",@"620086":@"工商银行",@"621558":@"工商银行",@"621559":@"工商银行",@"621618":@"工商银行",@"621670":@"工商银行",@"623062":@"工商银行",@"421349":@"建设银行",@"434061":@"建设银行",@"434062":@"建设银行",@"524094":@"建设银行",@"526410":@"建设银行",@"552245":@"建设银行",@"621080":@"建设银行",@"621082":@"建设银行",@"621466":@"建设银行",@"621488":@"建设银行",@"621499":@"建设银行",@"622966":@"建设银行",@"622988":@"建设银行",@"436742":@"建设银行",@"589970":@"建设银行",@"620060":@"建设银行",@"621081":@"建设银行",@"621284":@"建设银行",@"621467":@"建设银行",@"621598":@"建设银行",@"621621":@"建设银行",@"621700":@"建设银行",@"622280":@"建设银行",@"622700":@"建设银行",@"436742":@"建设银行",@"622280":@"建设银行",@"623211":@"建设银行",@"620059":@"中国农业银行",@"621282":@"中国农业银行",@"621336":@"中国农业银行",@"621619":@"中国农业银行",@"621671":@"中国农业银行",@"622821":@"中国农业银行",@"622822":@"中国农业银行",@"622823":@"中国农业银行",@"622824":@"中国农业银行",@"622825":@"中国农业银行",@"622826":@"中国农业银行",@"622827":@"中国农业银行",@"622828":@"中国农业银行",@"622840":@"中国农业银行",@"622841":@"中国农业银行",@"622843":@"中国农业银行",@"622844":@"中国农业银行",@"622845":@"中国农业银行",@"622846":@"中国农业银行",@"622847":@"中国农业银行",@"622848":@"中国农业银行",@"622849":@"中国农业银行",@"623018":@"中国农业银行",@"623206":@"中国农业银行",@"621626":@"平安银行",@"623058":@"平安银行",@"602907":@"平安银行",@"622298":@"平安银行",@"622986":@"平安银行",@"622989":@"平安银行",@"627066":@"平安银行",@"627067":@"平安银行",@"627068":@"平安银行",@"627069":@"平安银行",@"412962":@"发展银行",@"412963":@"发展银行",@"415752":@"发展银行",@"415753":@"发展银行",@"622535":@"发展银行",@"622536":@"发展银行",@"622538":@"发展银行",@"622539":@"发展银行",@"622983":@"发展银行",@"998800":@"发展银行",@"690755":@"招商银行",@"402658":@"招商银行",@"410062":@"招商银行",@"468203":@"招商银行",@"512425":@"招商银行",@"524011":@"招商银行",@"621286":@"招商银行",@"622580":@"招商银行",@"622588":@"招商银行",@"622598":@"招商银行",@"622609":@"招商银行",@"690755":@"招商银行",@"433670":@"中信银行",@"433671":@"中信银行",@"433680":@"中信银行",@"442729":@"中信银行",@"442730":@"中信银行",@"620082":@"中信银行",@"621767":@"中信银行",@"621768":@"中信银行",@"621770":@"中信银行",@"621771":@"中信银行",@"621772":@"中信银行",@"621773":@"中信银行",@"622690":@"中信银行",@"622691":@"中信银行",@"622692":@"中信银行",@"622696":@"中信银行",@"622698":@"中信银行",@"622998":@"中信银行",@"622999":@"中信银行",@"968807":@"中信银行",@"968808":@"中信银行",@"968809":@"中信银行",@"620085":@"广大银行",@"620518":@"广大银行",@"621489":@"广大银行",@"621492":@"广大银行",@"622660":@"广大银行",@"622661":@"广大银行",@"622662":@"广大银行",@"622663":@"广大银行",@"622664":@"广大银行",@"622665":@"广大银行",@"622666":@"广大银行",@"622667":@"广大银行",@"622668":@"广大银行",@"622669":@"广大银行",@"622670":@"广大银行",@"622671":@"广大银行",@"622672":@"广大银行",@"622673":@"广大银行",@"622674":@"广大银行",@"620535":@"广大银行",@"622516":@"浦发银行",@"622517":@"浦发银行",@"622518":@"浦发银行",@"622521":@"浦发银行",@"622522":@"浦发银行",@"622523":@"浦发银行",@"984301":@"浦发银行",@"984303":@"浦发银行",@"621352":@"浦发银行",@"621793":@"浦发银行",@"621795":@"浦发银行",@"621796":@"浦发银行",@"621351":@"浦发银行",@"621390":@"浦发银行",@"621792":@"浦发银行",@"621791":@"浦发银行",@"84301":@"浦发银行",@"84336":@"浦发银行",@"84373":@"浦发银行",@"84385":@"浦发银行",@"84390":@"浦发银行",@"87000":@"浦发银行",@"87010":@"浦发银行",@"87030":@"浦发银行",@"87040":@"浦发银行",@"84380":@"浦发银行",@"84361":@"浦发银行",@"87050":@"浦发银行",@"84342":@"浦发银行",@"415599":@"民生银行",@"421393":@"民生银行",@"421865":@"民生银行",@"427570":@"民生银行",@"427571":@"民生银行",@"472067":@"民生银行",@"472068":@"民生银行",@"622615":@"民生银行",@"622616":@"民生银行",@"622617":@"民生银行",@"622618":@"民生银行",@"622619":@"民生银行",@"622620":@"民生银行",@"622622":@"民生银行",@"601428":@"交通银行",@"405512":@"交通银行",@"622258":@"交通银行",@"622259":@"交通银行",@"622260":@"交通银行",@"622261":@"交通银行",@"622262":@"交通银行",@"621056":@"交通银行",@"621335":@"交通银行",@"621096":@"邮政储蓄银行",@"621098":@"邮政储蓄银行",@"622150":@"邮政储蓄银行",@"622151":@"邮政储蓄银行",@"622181":@"邮政储蓄银行",@"622188":@"邮政储蓄银行",@"955100":@"邮政储蓄银行",@"621095":@"邮政储蓄银行",@"620062":@"邮政储蓄银行",@"621285":@"邮政储蓄银行",@"621798":@"邮政储蓄银行",@"621799":@"邮政储蓄银行",@"621797":@"邮政储蓄银行",@"620529":@"邮政储蓄银行",@"622199":@"邮政储蓄银行",@"62215049":@"邮政储蓄银行",@"62215050":@"邮政储蓄银行",@"62215051":@"邮政储蓄银行",@"62218850":@"邮政储蓄银行",@"62218851":@"邮政储蓄银行",@"62218849":@"邮政储蓄银行",@"621622":@"邮政储蓄银行",@"621599":@"邮政储蓄银行",@"623219":@"邮政储蓄银行",@"621674":@"邮政储蓄银行",@"623218":@"邮政储蓄银行",@"621660":@"中国银行",@"621661":@"中国银行",@"621662":@"中国银行",@"621663":@"中国银行",@"621665":@"中国银行",@"621667":@"中国银行",@"621668":@"中国银行",@"621669":@"中国银行",@"621666":@"中国银行",@"456351":@"中国银行",@"601382":@"中国银行",@"621256":@"中国银行",@"621212":@"中国银行",@"621283":@"中国银行",@"620061":@"中国银行",@"621725":@"中国银行",@"621330":@"中国银行",@"621331":@"中国银行",@"621332":@"中国银行",@"621333":@"中国银行",@"621297":@"中国银行",@"621568":@"中国银行",@"621569":@"中国银行",@"621672":@"中国银行",@"623208":@"中国银行",@"621620":@"中国银行",@"621756":@"中国银行",@"621757":@"中国银行",@"621758":@"中国银行",@"621759":@"中国银行",@"621785":@"中国银行",@"621786":@"中国银行",@"621787":@"中国银行",@"621788":@"中国银行",@"621789":@"中国银行",@"621790":@"中国银行"};
    }
    
    for (NSString *s in [dic allKeys]) {
        if ([bank1 isEqualToString:s]||[bank isEqualToString:s]||[bank2 isEqualToString:s]) {
            //            bankname = [dic objectForKey:s];
            bankname = dic[s];
            NSLog(@"bankname%@",bankname);
            break ;
        }
    }
    return bankname;
}
/**
 *  验证银行卡有效
 *
 *  @param cardNo 卡号
 *
 *  @return
 */
- (BOOL) checkCardNo:(NSString*) cardNo{
    
    //^([0-9]{16}|[0-9]{19})$
    
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    if (_pickerView.alpha == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            _pickerView.alpha = 0;
        }];
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:UIKeyboardWillHideNotification object:nil];
}
@end
