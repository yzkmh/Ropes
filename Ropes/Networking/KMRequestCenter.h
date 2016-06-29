//
//  KMRequestCenter.h
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/3/27.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <Foundation/Foundation.h>


// 短信调用接口
#define SendMessage @"http://122.49.7.211/cappController/doSendMessage"
// 登录接口
#define Login       @"http://122.49.7.211/cappController/doLogin"
// 注册或修改,忘记密码接口
#define Register    @"http://122.49.7.211/cappController/doRegister"
// 完善客户信息
#define UpdateDetail @"http://122.49.7.211/cappController/doUpdateDetail"
// 登录时获取主页数据接口
#define CIndex @"http://122.49.7.211/cappController/cIndex"
// 登录获取主页彩票数据
#define CLotteryIndex @"http://122.49.7.211/cappControllerLot/cLotteryIndex"
// 获取信息
#define ViewInformation @"http://122.49.7.211/cappController/viewInformation"
// 查询身份认证信息
#define LotteryInquery @"http://122.49.7.211/cappControllerLot/lotteryInquery"
//可使用门店查询
#define GetUsedScen @"http://122.49.7.211/cappControllerLot/getUsedScen"
//查询彩票代金券信息
#define LotteryInqueryVoucher @"http://122.49.7.211/cappControllerLot/lotteryInqueryVoucher"
//发送短信（彩票）
#define GetMars @"http://122.49.7.211/cappControllerLot/getMars"
//立即使用
#define Immediately @"http://122.49.7.211/cappController/immediately"
//获取彩票使用记录
#define GetUsedHis @"http://122.49.7.211/cappControllerLot/getUsedHis"
//彩票外使用记录
#define UsedHis @"http://122.49.7.211/cappController/usedHis"
//可使用门店非彩票
#define UseAble @"http://122.49.7.211/cappController/useAble"
// 查询余额
#define BalanceInquery @"http://122.49.7.211/cappController/doBalanceInquery"
// 查询收支记录
#define CashReHis @"http://122.49.7.211/cappController/doCashReHis"
// 提现
#define DoCashRe @"http://122.49.7.211/cappController/doCashRe"
// 添加银行卡
#define DoInsertBankInfo @"http://122.49.7.211/cappController/doInsertBankInfo"
//银行卡列表
#define DoRequestBankName @"http://122.49.7.211/cappController/doRequestBankName"


typedef NS_ENUM(NSInteger,KMConponType){
    KMDiscountType = 1,
    KMVoucherType,
    KMAuthenticationType,
    KMLatteryType = 10
};

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
                               andType:(NSString *)type
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
/**
 *  获取主页数据
 *
 *  @param success 成功
 *  @param failure 失败
 */
+ (void)requestMainViewInfoWithphoneNum:(NSString *)phone
                              sessionId:(NSString *)sessionid
                           sessionIdPwd:(NSString *)sessionidpwd
                              success:(void (^)(NSDictionary *))success
                              failure:(void (^)(int, NSString *))failure;

/**
 *  获取主页彩票数据
 *
 *  @param success 成功
 *  @param failure 失败
 */
+ (void)requestMainViewLotteryInfoWithphoneNum:(NSString *)phone
                              sessionId:(NSString *)sessionid
                           sessionIdPwd:(NSString *)sessionidpwd
                                success:(void (^)(NSDictionary *))success
                                failure:(void (^)(int, NSString *))failure;
/**
 *  获取主页信息
 *
 *  @param phone        手机号
 *  @param sessionid    id
 *  @param sessionidpwd id*6md5
 *  @param type         类型 1.折扣券 2.代金券 3.身份认证
 *  @param success      成功
 *  @param failure      失败
 */
+ (void)requestViewInformationWithphoneNum:(NSString *)phone
                                 sessionId:(NSString *)sessionid
                              sessionIdPwd:(NSString *)sessionidpwd
                                conponType:(KMConponType)type
                                   success:(void (^)(NSDictionary *))success
                                   failure:(void (^)(int, NSString *))failure;

/**
 *  获取彩票信息
 *
 *  @param phone   手机号
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)requestLotteryInfoWithPhoneNum:(NSString *)phone
                               success:(void (^)(NSDictionary *))success
                               failure:(void (^)(int, NSString *))failure;
/**
 *  查询可使用门店
 *
 *  @param phone   手机号
 *  @param tcode   券编号
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)requestShopInfoWithPhoneNum:(NSString *)phone
                              tcode:(NSString *)tcode
                         conponType:(KMConponType)type
                            success:(void (^)(NSDictionary *))success
                            failure:(void (^)(int, NSString *))failure;
/**
 *  查询代金券信息
 *
 *  @param phone   电话
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)requestVoucherInfoWithPhoneNum:(NSString *)phone
                               success:(void (^)(NSDictionary *))success
                               failure:(void (^)(int, NSString *))failure;
/**
 *  查询身份认证信息
 *
 *  @param phone   电话
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)requestAuthenticationInfoWithPhoneNum:(NSString *)phone
                                    sessionId:(NSString *)sessionid
                                 sessionIdPwd:(NSString *)sessionidpwd
                                      success:(void (^)(NSDictionary *))success
                                      failure:(void (^)(int, NSString *))failure;
/**
 *  优惠信息发送至手机
 *
 *  @param phone      手机号
 *  @param sessionId  sessionId
 *  @param sessionpwd pwd
 *  @param tcode      辅助码
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)requestSendConponMessageWithPhoneNum:(NSString *)phone
                                   sessionId:(NSString *)sessionId
                                sessionIdPwd:(NSString *)sessionpwd
                                       tcode:(NSString *)tcode
                                     success:(void (^)(NSDictionary *))success
                                     failure:(void (^)(int, NSString *))failure;
/**
 *  彩票信息发送至手机
 *
 *  @param phone      手机号
 *  @param sessionId  sessionId
 *  @param sessionpwd pwd
 *  @param tcode      辅助码
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)requestSendLotteryMessageWithPhoneNum:(NSString *)phone
                                    sessionId:(NSString *)sessionId
                                 sessionIdPwd:(NSString *)sessionpwd
                                        tcode:(NSString *)tcode
                                      success:(void (^)(NSDictionary *))success
                                      failure:(void (^)(int, NSString *))failure;
/**
 *  获取使用记录
 *
 *  @param phone      手机号
 *  @param sessionId  sid
 *  @param sessionpwd sidpwd
 *  @param tcode      辅助码
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)requestForHistoryWithPhoneNum:(NSString *)phone
                            sessionId:(NSString *)sessionId
                         sessionIdPwd:(NSString *)sessionpwd
                                tcode:(NSString *)tcode
                           conponType:(KMConponType)type
                              success:(void (^)(NSDictionary *))success
                              failure:(void (^)(int, NSString *))failure;

/**
 *  查询余额
 *
 *  @param phone        电话号码
 *  @param sessionId    id
 *  @param sessionIdPwd id*6md5
 *  @param cashrequest  电话号码?
 */
+ (void)requestForDoBalanceInqueryWithNum:(NSString *)phone
                                sessionId:(NSString *)sessionId
                             sessionIdPwd:(NSString *)sessionIdPwd
                             requestPhone:(NSString *)requestPhone
                                  success:(void (^)(NSDictionary *))success
                                  failure:(void (^)(int, NSString *))failure;
/**
 *  收支记录
 *
 *  @param phone        电话号码
 *  @param sessionId    id
 *  @param sessionIdPwd id*6md5
 *  @param requestPhone 电话号码
 *  @param success      成功回调
 *  @param failure      失败回调
 */
+ (void)requestForCashReHisWith:(NSString *)phone
                      sessionId:(NSString *)sessionId
                   sessionIdPwd:(NSString *)sessionIdPwd
                   requestPhone:(NSString *)requestPhone
                       bankcard:(NSString *)bankcard
                        success:(void (^)(NSDictionary *))success
                        failure:(void (^)(int, NSString *))failure;

/**
 *  提现
 *
 *  @param phone        电话号码
 *  @param sessionId    id
 *  @param sessionIdPwd id*6md5
 *  @param requestPhone 电话号码
 *  @param cashnum      提现金额
 *  @param bankname     银行
 *  @param bankcard     卡号
 *  @param requestname  银行
 */
+ (void)requestForDoCashRe:(NSString *)phone
                 sessionId:(NSString *)sessionId
              sessionIdPwd:(NSString *)sessionIdPwd
              requestPhone:(NSString *)requestPhone
                  cacshnum:(NSString *)cashnum
                  bankname:(NSString *)bankname
                  bankcard:(NSString *)bankcard
               requestname:(NSString *)requestname
                   success:(void (^)(NSDictionary *))success
                   failure:(void (^)(int, NSString *))failure;


+ (void)requestForDoInsertBankInfo:(NSString *)phone
                         sessionId:(NSString *)sessionid
                      sessionidpwd:(NSString *)sessionidpwd
                              bank:(NSString *)bank
                          bankcard:(NSString *)bankcard
                           success:(void (^)(NSDictionary *))success
                           failure:(void (^)(int, NSString *))failure;
+ (void)requestForBankListWithphone:(NSString *)phone
                          sessionId:(NSString *)sessionid
                       sessionidpwd:(NSString *)sessionidpwd
                            success:(void (^)(NSDictionary *))success
                            failure:(void (^)(int, NSString *))failure;

@end
