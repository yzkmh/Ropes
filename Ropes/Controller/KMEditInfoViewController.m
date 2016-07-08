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

@interface KMEditInfoViewController()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *pickarray;
    UIPickerView *pickerView;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@property (weak, nonatomic) IBOutlet UIView *addressView;

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
    self.nameTextField.delegate = self;
    self.phoneNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneNumTextField.delegate = self;
    [self.phoneNumTextField setUserInteractionEnabled:NO];
    self.genderTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.addressTextField.delegate = self;
    [self.genderTextField setDelegate:self];
    
    pickarray = @[@"男",@"女"];
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.addressView.frame.origin.y + self.addressView.bounds.size.height, self.view.frame.size.width, 100)];
    pickerView.alpha = 0;
    [self.view addSubview:pickerView];
    // 显示选中框
    pickerView.showsSelectionIndicator=YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.genderTextField]) {
        [UIView animateWithDuration:0.3 animations:^{
            pickerView.alpha = 1;
        }];
        [textField resignFirstResponder];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        pickerView.alpha = 0;
    }];
    [self.view becomeFirstResponder];
}
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return pickarray.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickarray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.genderTextField.text = [pickarray objectAtIndex:row];
}



@end
