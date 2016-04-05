//
//  KMRequestCenter.h
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/3/27.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <Foundation/Foundation.h>


// 短信调用接口
#define SendMessage @"doSendMessage"
// 登录接口
#define Login       @"doLogin"
// 注册或修改,忘记密码接口
#define Register    @"doRegister"
// 完善客户信息
#define UpdateDetail @"doUpdateDetail"


@interface KMRequestCenter : NSObject

/**
 *  短信调用
 *
 *  @param suburl             SendMessage
 *  @param phone              string : 注册手机号
 *  @param identifyingcode    string : 6位数字验证码
 *  @param identifyingcodepwd string : identifyingcode md5加密15次后的结果
 *  @param success            成功回调
 *  @param failure            失败回调
 */
+ (void)requestForSendMessageWithPhone:(NSString *)phone
              identifyingcode:(NSString *)identifyingcode
           identifyingCodePwd:(NSString *)identifyingcodepwd
                      success:(void (^)(NSDictionary *))success
                      failure:(void (^)(int, NSString *))failure;
/**
 *  登录
 *
 *  @param suburl  Login
 *  @param phone   string : 注册的手机号
 *  @param pwd     string : 设置的密码 MD5加密6次的结果
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)requestForLoginWithPhone:(NSString *)phone
               password:(NSString *)pwd
                success:(void (^)(NSDictionary *))success
                failure:(void (^)(int, NSString *))failure;
/**
 *  注册或修改, 忘记密码
 *
 *  @param suburl          Register
 *  @param phone           string : 注册手机号
 *  @param identifyingcode string : 短信验证码 md5 加密15次后的结果
 *  @param pwd             设置的密码 MD5 加密 6 次后的结果
 *  @param type            1 代表注册, 2 代表修改/忘记
 *  @param success         成功回调
 *  @param failure         失败回调
 */
+ (void)requestForRegisterWithPhone:(NSString *)phone
        identifyingcodepwd:(NSString *)identifyingcode
                  password:(NSString *)pwd
                      type:(NSString *)type
                   success:(void (^)(NSDictionary *))success
                   failure:(void (^)(int, NSString *))failure;
/**
 *  完善客户信息
 *
 *  @param suburl       UpdateDetail
 *  @param name         姓名
 *  @param phone        手机号
 *  @param gender       1男, 2女
 *  @param address      地址
 *  @param sessionid
 *  @param sessionidpwd sessionid 取前10位然后6次MD5
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)requestForUpdateDetailWithName:(NSString *)name
                         phone:(NSString *)phone
                        gender:(int)gender
                       address:(NSString *)address
                     sessionId:(NSString *)sessionid
                  sessionIdPwd:(NSString *)sessionidpwd
                       success:(void (^)(NSDictionary *))success
                       failure:(void (^)(int, NSString *))failure;

@end
