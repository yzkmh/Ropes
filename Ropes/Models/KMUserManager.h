//
//  KMUserManager.h
//  Ropes
//
//  Created by yzk on 16/3/25.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMUser.h"
@interface KMUserManager : NSObject
@property (nonatomic, strong) KMUser *currentUser;

//单例
+ (KMUserManager *)getInstance;

#pragma mark 调用方法
// 获取验证码
- (void)getPhoneCodeWithPhoneNum:(NSString *)phoneNum
                         andType:(NSString *)type
                      complation:(void(^)(BOOL result,NSString *message, id user))block;
// 注册
- (void)registWithPhoneNum:(NSString *)phoneNum
           verifyPhoneCode:(NSString *)phoneCode
                  password:(NSString *)pwd
                 comlation:(void(^)(BOOL result,NSString *message, id user))block;
// 登录
- (void)loginWithPhoneNum:(NSString *)phoneNum password:(NSString *)pwd comlation:(void(^)(BOOL result,NSString *message, id user))block;
// 找回密码
- (void)resetPasswordWithPhoneNum:(NSString *)phoneNum
                  verifyPhoneCode:(NSString *)phoneCode
                         password:(NSString *)pwd
                        comlation:(void(^)(BOOL result,NSString *message, id user))block;
// 完善客户信息
- (void)UpdateDetailWithName:(NSString *)name
                       phone:(NSString *)phone
                      gender:(int)gender
                     address:(NSString *)address
                   comlation:(void(^)(BOOL result,NSString *message, id user))block;


@end
