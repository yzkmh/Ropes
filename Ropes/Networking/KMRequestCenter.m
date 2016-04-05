//
//  KMRequestCenter.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/3/27.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMRequestCenter.h"
#import "KMNetWorkingManager.h"


@implementation KMRequestCenter


+ (void)requestForSendMessageWithPhone:(NSString *)phone
              identifyingcode:(NSString *)identifyingcode
           identifyingCodePwd:(NSString *)identifyingcodepwd
                      success:(void (^)(NSDictionary *))success
                      failure:(void (^)(int, NSString *))failure
{
    NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:
                               phone,@"phone",
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
@end
