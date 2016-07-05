//
//  KMUserManager.m
//  Ropes
//
//  Created by yzk on 16/3/25.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMUserManager.h"
#import "KMRequestCenter.h"
#import "NSString+MD5.h"
@interface KMUserManager ()

@end

static KMUserManager *shareKMUserManager = nil ;

@implementation KMUserManager

+ (KMUserManager *)getInstance
{
    @synchronized(self)
    {
        if(shareKMUserManager == nil)
        {
            shareKMUserManager = [[self alloc] init];
        }
    }
    return shareKMUserManager;
    
}

- (void)getPhoneCodeWithPhoneNum:(NSString *)phoneNum andType:(NSString *)type complation:(void (^)(BOOL, NSString *, id))block
{
    // 6位数字验证码
    NSString *identifyingCode = @"";
    for(int i=0; i<6; i++)
    {
        identifyingCode = [ identifyingCode stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    NSString *identifyingCodePwd = [identifyingCode md5WithTimes:15];
    
    [KMRequestCenter requestForSendMessageWithPhone:phoneNum
                                            andType:type
                                    identifyingcode:identifyingCode
                                 identifyingCodePwd:identifyingCodePwd
                                            success:^(NSDictionary *resultDic) {
                                                
                                                NSLog(@"发送短信成功");
                                                block(YES, @"发送短信成功", [KMUser userWithDict:resultDic]);
                                        
                                            } failure:^(int code, NSString *errorStr) {
                                                NSLog(@"发送短信失败, errorCode: %d -- errorMsg: %@",code,errorStr);
                                                block(NO, errorStr, nil);
                                            }];
}


//注册
- (void)registWithPhoneNum:(NSString *)phoneNum verifyPhoneCode:(NSString *)phoneCode password:(NSString *)pwd comlation:(void(^)(BOOL, NSString *, id))block
{
    phoneCode = [phoneCode md5WithTimes:15];
    pwd = [pwd md5WithTimes:6];
    
    [KMRequestCenter requestForRegisterWithPhone:phoneNum
                              identifyingcodepwd:phoneCode
                                        password:pwd type:@"1"
                                         success:^(NSDictionary *resultDic) {
                                             
                                             KMUser *user = [KMUser userWithDict:resultDic];
                                             NSLog(@"注册成功 user:%@",user);
                                             block(YES, @"注册成功", user);
                                             
                                         } failure:^(int code, NSString *errorStr) {
                                             
                                             NSLog(@"注册失败 errorCode: %d -- errorMsg: %@",code,errorStr);
                                             block(NO, errorStr, nil);
                                             
                                         }];
}
//登录
- (void)loginWithPhoneNum:(NSString *)phoneNum password:(NSString *)pwd comlation:(void(^)(BOOL, NSString *, id))block
{
    __block BOOL loginFinished = YES;
    
    __block KMUser *user;
    
    pwd = [pwd md5WithTimes:6];
    
    [KMRequestCenter requestForLoginWithPhone:phoneNum
                                     password:pwd
                                      success:^(NSDictionary *resultDic) {
                                          user = [KMUser userWithDict:resultDic];
                                          //查询主页数据
                                          [KMRequestCenter requestMainViewInfoWithphoneNum:user.phone sessionId:user.sessionid sessionIdPwd:[user.sessionid md5WithTimes:6]  success:^(NSDictionary *dic) {
                                              user.ConponNumList = [[NSMutableDictionary alloc]initWithObjects:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"] forKeys:@[@"cl",@"nl",@"dc",@"dn",@"zc",@"zn",@"sc",@"sn"]];
                                              for (NSString *key in dic.allKeys) {
                                                   [user.ConponNumList setValue:[dic objectForKey:key] forKey:key];
                                              }
                                              [KMRequestCenter requestMainViewLotteryInfoWithphoneNum:user.phone sessionId:user.sessionid sessionIdPwd:[user.sessionid md5WithTimes:6] success:^(NSDictionary *dic) {
                                                  for (NSString *key in dic.allKeys) {
                                                      if ([key isEqualToString:@"ct"]) {
                                                          int sc = (int)[[user.ConponNumList objectForKey:@"sc"]intValue] + (int)[[dic objectForKey:@"ct"]intValue];
                                                          [user.ConponNumList setValue:[NSNumber numberWithInt:sc] forKey:@"sc"];
                                                      }else if ([key isEqualToString:@"nt"])
                                                      {
                                                          int nt = (int)[[user.ConponNumList objectForKey:@"sn"]intValue] + (int)[[dic objectForKey:@"nt"]intValue];
                                                          [user.ConponNumList setValue:[NSNumber numberWithInt:nt] forKey:@"sn"];
                                                      }else if ([key isEqualToString:@"cv"])
                                                      {
                                                          int dc = (int)[[user.ConponNumList objectForKey:@"dc"]intValue] + (int)[[dic objectForKey:@"cv"]intValue];
                                                          [user.ConponNumList setValue:[NSNumber numberWithInt:dc] forKey:@"dc"];
                                                      }else if ([key isEqualToString:@"nv"])
                                                      {
                                                          int dn = (int)[[user.ConponNumList objectForKey:@"dn"]intValue] + (int)[[dic objectForKey:@"nv"]intValue];
                                                          [user.ConponNumList setValue:[NSNumber numberWithInt:dn] forKey:@"dn"];
                                                      }else{
                                                          [user.ConponNumList setValue:[dic objectForKey:key] forKey:key];
                                                      }
                                                      
                                                  }
                                                  block(YES,@"登录成功",user);
                                              } failure:^(int code, NSString *errorStr) {
                                                  loginFinished = NO;
                                                  NSLog(@"登录失败 errorCode: %d -- errorMsg: %@",code,errorStr);
                                                  block(NO, errorStr, nil);
                                              }];
                                              
                                          }
                                                                                   failure:^(int code, NSString *errorStr) {
                                                                                       NSLog(@"获取主页信息失败");
                                                                                       loginFinished = NO;
                                                                                       block(NO, errorStr, nil);
                                                                                   }];

                                      }
                                      failure:^(int code, NSString *errorStr) {
                                          loginFinished = NO;
                                          NSLog(@"登录失败 errorCode: %d -- errorMsg: %@",code,errorStr);
                                          block(NO, errorStr, nil);
                                      }];

    
//    // 合并汇总结果
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
//        //并行执行的线程一
//
//    });
//    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
//        // 并行执行的线程二
//        [KMRequestCenter requestMainViewInfoWithphoneNum:[KMUserManager getInstance].currentUser.phone sessionId:[KMUserManager getInstance].currentUser.sessionid sessionIdPwd:[[KMUserManager getInstance].currentUser.sessionid md5WithTimes:6]  success:^(NSDictionary *dic) {
//            self.currentUser.ConponNumList = [NSDictionary dictionaryWithDictionary:dic];
//            //NSLog(@"登陆成功 user:%@",user);
//            //block(YES, @"登录成功", user);
//        }
//                                                 failure:^(int code, NSString *errorStr) {
//                                                     NSLog(@"获取主页信息失败");
//                                                     loginFinished = NO;
//                                                     block(NO, errorStr, nil);
//                                                 }];
//
//    });
//    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
//        // 并行执行的线程三
//        [KMRequestCenter requestMainViewLotteryInfoWithphoneNum:[KMUserManager getInstance].currentUser.phone sessionId:[KMUserManager getInstance].currentUser.sessionid sessionIdPwd:[[KMUserManager getInstance].currentUser.sessionid md5WithTimes:6]  success:^(NSDictionary *dic) {
//            for (NSString *key in dic.allKeys) {
//                [self.currentUser.ConponNumList setValue:[dic objectForKey:key] forKey:key];
//            }
//        }
//                                                 failure:^(int code, NSString *errorStr) {
//                                                     NSLog(@"获取主页彩票信息失败");
//                                                     loginFinished = NO;
//                                                     block(NO, errorStr, nil);
//                                                 }];
//    });
//    dispatch_group_notify(group, dispatch_get_global_queue(0,0), ^{
//        // 汇总结果
//        if (loginFinished) {
//            block(YES,@"注册成功",user);
//        }
//    });
}
//找回密码
- (void)resetPasswordWithPhoneNum:(NSString *)phoneNum verifyPhoneCode:(NSString *)phoneCode password:(NSString *)pwd comlation:(void(^)(BOOL, NSString *, id))block
{
    phoneCode = [phoneCode md5WithTimes:15];
    pwd = [pwd md5WithTimes:6];
    
    [KMRequestCenter requestForRegisterWithPhone:phoneNum
                              identifyingcodepwd:phoneCode
                                        password:pwd type:@"2"
                                         success:^(NSDictionary *resultDic) {
                                             
                                             KMUser *user = [KMUser userWithDict:resultDic];
                                             NSLog(@"修改密码成功 user:%@",user);
                                             block(YES, @"修改密码成功", user);
                                             
                                         } failure:^(int code, NSString *errorStr) {
                                             
                                             NSLog(@"修改密码失败 errorCode: %d -- errorMsg: %@",code,errorStr);
                                             block(NO, errorStr, nil);
                                             
                                         }];

}
// 完善客户信息
- (void)UpdateDetailWithName:(NSString *)name
                       phone:(NSString *)phone
                      gender:(int)gender
                     address:(NSString *)address
                   comlation:(void(^)(BOOL result,NSString *message, id user))block
{
    NSString *sessionid = [KMUserManager getInstance].currentUser.sessionid;
    NSString* sessionidpwd = [sessionid md5WithTimes:6];
    
    [KMRequestCenter requestForUpdateDetailWithName:name
                                              phone:phone
                                             gender:gender
                                            address:address
                                          sessionId:sessionid
                                       sessionIdPwd:sessionidpwd
                                            success:^(NSDictionary *resultDic) {
                                                
                                                KMUser *user = [KMUser userWithDict:resultDic];
                                                NSLog(@"完善用户信息成功");
                                                block(YES, @"修改个人信息成功", user);
                                                
                                            } failure:^(int code, NSString *errorStr) {
                                                NSLog(@"完善用户信息失败 errorCoder: %d -- errorMsg: %@",code, errorStr);
                                                block(NO, errorStr, nil);
                                            }];
    
}
@end
