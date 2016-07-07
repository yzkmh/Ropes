//
//  KMRequestCenter.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/3/27.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMRequestCenter.h"
#import "KMNetWorkingManager.h"
#import "KMUserManager.h"


@implementation KMRequestCenter


+ (void)requestForSendMessageWithPhone:(NSString *)phone
                               andType:(NSString *)type
              identifyingcode:(NSString *)identifyingcode
           identifyingCodePwd:(NSString *)identifyingcodepwd
                      success:(void (^)(NSDictionary *))success
                      failure:(void (^)(int, NSString *))failure
{
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:
                               phone,@"phone",
                               type,@"type",
                               identifyingcode,@"identifyingcode",
                               identifyingcodepwd,@"identifyingcodepwd",
                               nil];
    
    [[KMNetWorkingManager sharedManager] postWithParameters:paramters
                                                     subUrl:SendMessage
                                                      block:^(NSDictionary *resultDic, NSError *error) {
                                                          
                                                          BOOL handle_state = [resultDic objectForKey:@"handler_state"];
                                                          int error_code = [[resultDic objectForKey:@"error_code"] intValue];
                                                          NSString *errorString =[resultDic objectForKey:@"error"];
                                                          
                                                          if (handle_state && error_code == 200) {
                                                              NSLog(@"code : %d",error_code);
                                                              success(resultDic);
                                                          } else {
                                                              NSLog(@"error_code: %d  ---- error: %@",error_code,errorString);
                                                              failure(error_code,errorString);
                                                          }
                                                      }];
}


+ (void)requestForLoginWithPhone:(NSString *)phone
               password:(NSString *)pwd
                success:(void (^)(NSDictionary *))success
                failure:(void (^)(int, NSString *))failure
{
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:
                               phone,@"phone",
                               pwd,@"pwd",
                               nil];
    
    [[KMNetWorkingManager sharedManager] postWithParameters:paramters
                                                     subUrl:Login
                                                      block:^(NSDictionary *resultDic, NSError *error) {
                                                          
                                                          BOOL handle_state = [resultDic objectForKey:@"handler_state"];
                                                          int error_code = [[resultDic objectForKey:@"error_code"] intValue];
                                                          NSString *errorString =[resultDic objectForKey:@"error"];
                                                          
                                                          if (handle_state && error_code == 200) {
                                                              NSLog(@"code : %d",error_code);
                                                              success(resultDic);
                                                              
                                                              
                                                          } else {
                                                              NSLog(@"error_code: %d  ---- error: %@",error_code,errorString);
                                                              failure(error_code,errorString);
                                                          }
                                                      }];
}


+ (void)requestForRegisterWithPhone:(NSString *)phone
        identifyingcodepwd:(NSString *)identifyingcode
                  password:(NSString *)pwd
                      type:(NSString *)type
                   success:(void (^)(NSDictionary *))success
                   failure:(void (^)(int, NSString *))failure
{
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:
                               phone,@"phone",
                               identifyingcode,@"identifyingcodepwd",
                               pwd,@"pwd",
                               type,@"type",
                               nil];
    
    [[KMNetWorkingManager sharedManager] postWithParameters:paramters
                                                     subUrl:Register
                                                      block:^(NSDictionary *resultDic, NSError *error) {
                                                          
                                                          BOOL handle_state = [resultDic objectForKey:@"handler_state"];
                                                          int error_code = [[resultDic objectForKey:@"error_code"] intValue];
                                                          NSString *errorString =[resultDic objectForKey:@"error"];
                                                          
                                                          if (handle_state && error_code == 200) {
                                                              NSLog(@"code : %d",error_code);
                                                              success(resultDic);
                                                          } else {
                                                              NSLog(@"error_code: %d  ---- error: %@",error_code,errorString);
                                                              failure(error_code,errorString);
                                                          }
                                                      }];
}

+ (void)requestForUpdateDetailWithName:(NSString *)name
                         phone:(NSString *)phone
                        gender:(int)gender
                       address:(NSString *)address
                     sessionId:(NSString *)sessionid
                  sessionIdPwd:(NSString *)sessionidpwd
                       success:(void (^)(NSDictionary *))success
                       failure:(void (^)(int, NSString *))failure
{
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:
                               name,@"name",
                               phone,@"phone",
                              [NSNumber numberWithInt:gender],@"gender",
                               address,@"address",
                               sessionid,@"sessionid",
                               sessionidpwd,@"sessionidpwd",
                               nil];

    [[KMNetWorkingManager sharedManager] postWithParameters:paramters
                                                     subUrl:UpdateDetail
                                                      block:^(NSDictionary *resultDic, NSError *error) {
                                                          
                                                          BOOL handle_state = [resultDic objectForKey:@"handler_state"];
                                                          int error_code = [[resultDic objectForKey:@"error_code"] intValue];
                                                          NSString *errorString =[resultDic objectForKey:@"error"];
                                                          
                                                          if (handle_state && error_code == 200) {
                                                              NSLog(@"code : %d",error_code);
                                                              success(resultDic);
                                                          } else {
                                                              NSLog(@"error_code: %d  ---- error: %@",error_code,errorString);
                                                              failure(error_code,errorString);
                                                          }
                                                      }];
}
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
{
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:
                               phone,@"phone",
                               sessionid,@"sessionid",
                               sessionidpwd,@"sessionidpwd",
                               nil];
    
    
    [[KMNetWorkingManager sharedManager] postWithParameters:paramters
                                                     subUrl:CIndex
                                                      block:^(NSDictionary *resultDic, NSError *error) {
                                                          
//                                                          BOOL handle_state = [resultDic objectForKey:@"handler_state"];
                                                          int error_code = [[resultDic objectForKey:@"error_code"] intValue];
                                                          NSString *errorString =[resultDic objectForKey:@"error"];
                                                          
                                                          if ( error_code == 0) {
                                                              NSLog(@"code : %d",error_code);
                                                              success(resultDic);
                                                          } else {
                                                              NSLog(@"error_code: %d  ---- error: %@",error_code,errorString);
                                                              failure(error_code,errorString);
                                                          }
                                                      }];
}
+ (void)requestMainViewLotteryInfoWithphoneNum:(NSString *)phone
                                     sessionId:(NSString *)sessionid
                                  sessionIdPwd:(NSString *)sessionidpwd
                                       success:(void (^)(NSDictionary *))success
                                       failure:(void (^)(int, NSString *))failure
{
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:
                               phone,@"phone",
                               sessionid,@"sessionid",
                               sessionidpwd,@"sessionidpwd",
                               nil];
    
    
    [[KMNetWorkingManager sharedManager] postWithParameters:paramters
                                                     subUrl:CLotteryIndex
                                                      block:^(NSDictionary *resultDic, NSError *error) {
                                                          
                                                          //                                                          BOOL handle_state = [resultDic objectForKey:@"handler_state"];
//                                                          NSDictionary *dic = @{@"lc":@"2",@"ln":@"1"};
//                                                          success(dic);
                                                          success(resultDic);
                                                          
//                                                          int error_code = [[resultDic objectForKey:@"error_code"] intValue];
//                                                          NSString *errorString =[resultDic objectForKey:@"error"];
//                                                          
//                                                          if ( error_code == 0) {
//
//                                                          } else {
//                                                              NSLog(@"error_code: %d  ---- error: %@",error_code,errorString);
//                                                              failure(error_code,errorString);
//                                                          }
                                                      }];
}
+ (void)requestViewInformationWithphoneNum:(NSString *)phone
                                 sessionId:(NSString *)sessionid
                              sessionIdPwd:(NSString *)sessionidpwd
                                conponType:(KMConponType)type
                                   success:(void (^)(NSDictionary *))success
                                   failure:(void (^)(int, NSString *))failure
{
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:
                               phone,@"phone",
                               sessionid,@"sessionid",
                               sessionidpwd,@"sessionidpwd",
                               [NSNumber numberWithInt:type],@"type",
                               nil];
    [[KMNetWorkingManager sharedManager] postWithParameters:paramters
                                                     subUrl:ViewInformation
                                                      block:^(NSDictionary *resultDic, NSError *error) {
                                                          success(resultDic);
                                                      }];
}

+ (void)requestLotteryInfoWithPhoneNum:(NSString *)phone
                               success:(void (^)(NSDictionary *))success
                               failure:(void (^)(int, NSString *))failure
{
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:
                               phone,@"phone",
                               @"5",@"type",
                               nil];
    [[KMNetWorkingManager sharedManager] postWithParameters:paramters
                                                     subUrl:LotteryInquery
                                                      block:^(NSDictionary *resultDic, NSError *error) {
                                                          success(resultDic);
                                                      }];
}

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
                            failure:(void (^)(int, NSString *))failure
{
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:
                               phone,@"phone",
                               tcode,@"tcode",
                               @"6",@"type",
                               nil];
    NSString *url ;
    if (type  == 10) {
        url = GetUsedScen;
    }else{
        url = UseAble;
    }
    
    [[KMNetWorkingManager sharedManager] postWithParameters:paramters subUrl:url block:^(NSDictionary *resultDic, NSError *error) {
        BOOL isFinished = NO;
        for (NSDictionary *dic  in resultDic) {
            if ([[dic objectForKey:@"error_code"] isEqual:@200]) {
                isFinished = YES;
            }
        }
        if (isFinished) {
            success(resultDic);
        }else{
            failure(NO,@"获取失败");
        }
        
        
    }];
    
}

/**
 *  查询代金券信息
 *
 *  @param phone   电话
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)requestVoucherInfoWithPhoneNum:(NSString *)phone
                               success:(void (^)(NSDictionary *))success
                               failure:(void (^)(int, NSString *))failure
{
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:
                               phone,@"phone",
                               @"6",@"type",
                               nil];
    [[KMNetWorkingManager sharedManager] postWithParameters:paramters subUrl:LotteryInqueryVoucher block:^(NSDictionary *resultDic, NSError *error) {
        BOOL isFinished = NO;
        for (NSDictionary *dic  in resultDic) {
            if ([[dic objectForKey:@"error_code"] isEqual:@200]) {
                isFinished = YES;
            }
        }
        if (isFinished) {
            success(resultDic);
        }else{
            failure(NO,@"获取失败");
        }
    }];
}
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
                                      failure:(void (^)(int, NSString *))failure
{
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:
                               phone,@"phone",
                               sessionid,@"sessionid",
                               sessionidpwd,@"sessionidpwd",
                               @"4",@"type",
                               nil];
    [[KMNetWorkingManager sharedManager] postWithParameters:paramters subUrl:LotteryInquery block:^(NSDictionary *resultDic, NSError *error) {
        BOOL isFinished = NO;
        for (NSDictionary *dic  in resultDic) {
            if ([[dic objectForKey:@"error_code"] isEqual:@200]) {
                isFinished = YES;
            }
        }
        if (isFinished) {
            success(resultDic);
        }else{
            failure(NO,@"获取失败");
        }
    }];
}
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
                                     failure:(void (^)(int, NSString *))failure
{
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:
                               phone,@"phone",
                               sessionId,@"sessionid",
                               sessionpwd,@"sessionidpwd",
                               tcode,@"tcode",
                               nil];
    [[KMNetWorkingManager sharedManager] postWithParameters:paramters subUrl:Immediately block:^(NSDictionary *resultDic, NSError *error) {
        BOOL isFinished = NO;
        if ([[resultDic objectForKey:@"result"] isEqualToString:@"true"]) {
            isFinished = YES;
        }
        if (isFinished) {
            success(resultDic);
        }else{
            failure(NO,@"发送失败");
        }
    }];
}
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
                                      failure:(void (^)(int, NSString *))failure
{
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:
                               phone,@"phone",
                               sessionId,@"sessionid",
                               sessionpwd,@"sessionidpwd",
                               tcode,@"tcode",
                               nil];
    [[KMNetWorkingManager sharedManager] postWithParameters:paramters subUrl:GetMars block:^(NSDictionary *resultDic, NSError *error) {
        BOOL isFinished = NO;
        if ([[resultDic objectForKey:@"result"] isEqualToString:@"true"]) {
            isFinished = YES;
        }
        if (isFinished) {
            success(resultDic);
        }else{
            failure(NO,@"发送失败");
        }
    }];
}
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
                              failure:(void (^)(int, NSString *))failure
{
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:
                               phone,@"phone",
                               sessionId,@"sessionid",
                               sessionpwd,@"sessionidpwd",
                               tcode,@"tcode",
                               @"6",@"type",
                               nil];
    NSString *url ;
    if (type  == 10) {
        url = GetUsedHis;
    }else{
        url = UsedHis;
    }
    
    [[KMNetWorkingManager sharedManager] postWithParameters:paramters subUrl:url block:^(NSDictionary *resultDic, NSError *error) {
        BOOL isFinished = NO;
        for (NSDictionary *dic  in resultDic) {
            if ([[dic objectForKey:@"error_code"] isEqual:@200]) {
                isFinished = YES;
            }
        }
        if (isFinished) {
            success(resultDic);
        }else{
            failure(NO,@"获取失败");
        }
    }];
}

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
                                  failure:(void (^)(int, NSString *))failure
{
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:
                               phone,@"phone",
                               sessionId,@"sessionid",
                               sessionIdPwd,@"sessionidpwd",
                               requestPhone,@"requsetphone",
                               nil];
    
    [[KMNetWorkingManager sharedManager] postWithParameters:paramters subUrl:BalanceInquery block:^(NSDictionary *resultDic, NSError *error) {
        success(resultDic);
    }];
}

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
                        failure:(void (^)(int, NSString *))failure
{
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:
                               phone,@"phone",
                               sessionId,@"sessionid",
                               sessionIdPwd,@"sessionidpwd",
                               requestPhone,@"requsetphone",
                               bankcard,@"bankcard",
                               nil];
    [[KMNetWorkingManager sharedManager] postWithParameters:paramters subUrl:CashReHis block:^(NSDictionary *resultDic, NSError *error) {
        success(resultDic);
    }];
}

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
                   failure:(void (^)(int, NSString *))failure
{
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:
                               phone,@"phone",
                               sessionId,@"sessionid",
                               sessionIdPwd,@"sessionidpwd",
                               requestPhone,@"requsetphone",
                               cashnum,@"cashnum",
                               bankname,@"bankname",
                               bankcard,@"bankcard",
                               requestname,@"requestname",
                               nil];
    [[KMNetWorkingManager sharedManager] postWithParameters:paramters subUrl:DoCashRe block:^(NSDictionary *resultDic, NSError *error) {
        success(resultDic);
    }];
}

+ (void)requestForDoInsertBankInfo:(NSString *)phone
                         sessionId:(NSString *)sessionid
                      sessionidpwd:(NSString *)sessionidpwd
                              bank:(NSString *)bank
                          bankcard:(NSString *)bankcard
                           success:(void (^)(NSDictionary *))success
                           failure:(void (^)(int, NSString *))failure
{
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:
                               phone,@"phone",
                               sessionid,@"sessionid",
                               sessionidpwd,@"sessionidpwd",
                               bank,@"bank",
                               bankcard,@"bankcard",
                               nil];
    [[KMNetWorkingManager sharedManager] postWithParameters:paramters subUrl:DoInsertBankInfo block:^(NSDictionary *resultDic, NSError *error) {
        success(resultDic);
    }];

}

+ (void)requestForBankListWithphone:(NSString *)phone
                          sessionId:(NSString *)sessionid
                       sessionidpwd:(NSString *)sessionidpwd
                            success:(void (^)(NSDictionary *))success
                            failure:(void (^)(int, NSString *))failure
{
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:
                               phone,@"phone",
                               sessionid,@"sessionid",
                               sessionidpwd,@"sessionidpwd",
                               nil];
    [[KMNetWorkingManager sharedManager] postWithParameters:paramters subUrl:DoRequestBankName block:^(NSDictionary *resultDic, NSError *error) {
        success(resultDic);
    }];
}
@end
