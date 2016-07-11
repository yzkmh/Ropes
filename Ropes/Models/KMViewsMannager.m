//
//  KMViewsMannager.m
//  Ropes
//
//  Created by sunsea on 16/5/5.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMViewsMannager.h"
#import "KMUserManager.h"
#import "NSString+MD5.h"
#import "KMLottery.h"
#import "KMShop.h"
#import "KMVoucher.h"
#import "KMHistory.h"
#import <UIKit/UIKit.h>
#import "LCProgressHUD.h"

@interface KMViewsMannager ()
{

}
@end


static KMViewsMannager * _shareKMViewsManager;

@implementation KMViewsMannager

+ (KMViewsMannager *)getInstance
{
    @synchronized(self)
    {
        if(_shareKMViewsManager == nil)
        {
            _shareKMViewsManager = [[self alloc] init];
        }
    }
    return _shareKMViewsManager;
}

/**
 *  获取界面信息
 *
 *  @param type  1.折扣券 2.代金券 3.身份认证
 *  @param block 回调
 */
- (void)getViewsInfomationWithConponType:(KMConponType)type
                               comlation:(void(^)(BOOL result,NSArray *list))block
{
    NSString *phone = [KMUserManager getInstance].currentUser.phone;
    NSString *session = [KMUserManager getInstance].currentUser.sessionid;
    NSString *sessionpwd = [[KMUserManager getInstance].currentUser.sessionid md5WithTimes:6];
    __block NSMutableArray *voucherCanList = [NSMutableArray new];
    __block NSMutableArray *voucherNotList = [NSMutableArray new];
    [KMRequestCenter requestViewInformationWithphoneNum:phone sessionId:session sessionIdPwd:sessionpwd conponType:type success:^(NSDictionary *dic) {
        for (NSDictionary *conponInfo in dic)
        {
            if ([[conponInfo objectForKey:@"error_code"] isEqual:@200]) {
                KMVoucher *voucher =[[KMVoucher new]initWithDict:conponInfo];
                if ([voucher.state  isEqual: @0]) {
                    [voucherCanList addObject:voucher];
                }else{
                    [voucherNotList addObject:voucher];
                }
            }
        }
        if (type  == KMVoucherType) {
            [KMRequestCenter requestVoucherInfoWithPhoneNum:phone success:^(NSDictionary *dic) {
                for (NSDictionary *conponInfo in dic)
                {
                    if ([[conponInfo objectForKey:@"error_code"] isEqual:@200]) {
                        KMVoucher *voucher =[[KMVoucher new]initWithDict:conponInfo];
                        voucher.isLottery = YES;
                        if ([voucher.state  isEqual: @0]) {
                            [voucherCanList addObject:voucher];
                        }else{
                            [voucherNotList addObject:voucher];
                        }
                    }
                }
                NSLog(@"获取优惠数据成功");
                block(YES,@[voucherCanList,voucherNotList]);
            } failure:^(int result, NSString *errorStr) {
                NSLog(@"%@",errorStr);
                block(YES,@[voucherCanList,voucherNotList]);
            }];
        }
        else if (type  == KMAuthenticationType) {
            NSString *session = [KMUserManager getInstance].currentUser.sessionid;
            NSString *sessionpwd = [[KMUserManager getInstance].currentUser.sessionid md5WithTimes:6];
            [KMRequestCenter requestAuthenticationInfoWithPhoneNum:phone sessionId:session sessionIdPwd:sessionpwd  success:^(NSDictionary *dic) {
                for (NSDictionary *conponInfo in dic)
                {
                    if ([[conponInfo objectForKey:@"error_code"] isEqual:@200]) {
                        KMVoucher *voucher =[[KMVoucher new]initWithDict:conponInfo];
                        voucher.isLottery = YES;
                        if ([voucher.state  isEqual: @0]) {
                            [voucherCanList addObject:voucher];
                        }else{
                            [voucherNotList addObject:voucher];
                        }
                    }
                }
                NSLog(@"获取优惠数据成功");
                block(YES,@[voucherCanList,voucherNotList]);
            } failure:^(int result, NSString *errorStr) {
                block(YES,@[voucherCanList,voucherNotList]);
            }];
        }else{
            NSLog(@"获取优惠数据成功");
            block(YES,@[voucherCanList,voucherNotList]);
        }
    } failure:^(int code, NSString *ErrorStr) {
        NSLog(@"%@",ErrorStr);
        block(NO,nil);
    }];
}
- (void)getLotteryInfoWithPhoneNum:(NSString *)phone comlation:(void(^)(BOOL result,NSArray *list))block

{
    
    NSMutableArray *lotteryCanList = [NSMutableArray new];
    NSMutableArray *lotteryNotList = [NSMutableArray new];
    [KMRequestCenter requestLotteryInfoWithPhoneNum:phone success:^(NSDictionary *dic) {
        
        for (NSDictionary *lotterydic in dic) {
            if ([[lotterydic objectForKey:@"error_code"] isEqual:@200]){
                KMLottery *lottery = [[KMLottery alloc]initWithDict:lotterydic];
                  if ([lottery.state  isEqual: @0]) {
                      [lotteryCanList addObject:lottery];
                  }else{
                      [lotteryNotList addObject:lottery];
                  }
            }
        }
        NSLog(@"获取彩票数据成功");
        block(YES,@[lotteryCanList,lotteryNotList]);
    } failure:^(int code, NSString *ErrorStr) {
        
    }];
}

- (void)getShopInfoWithPhoneNum:(NSString *)phone tcode:(NSString *)tcode conponType:(KMConponType)type comlation:(void(^)(BOOL result,NSArray *list))block
{
    [KMRequestCenter requestShopInfoWithPhoneNum:phone tcode:tcode conponType:type success:^(NSDictionary *dic) {
        NSMutableArray *shopList = [NSMutableArray new];
        for (NSDictionary *lotterydic in dic) {
            KMShop *shop = [[KMShop alloc]initWithDict:lotterydic];
            [shopList addObject:shop];
            
        }
        block(YES,shopList);
    } failure:^(int code, NSString *errorStr) {
        block(NO,nil);
    }];
}

- (void)sendLotteryMessageWithtcode:(NSString *)tcode comlation:(void(^)(BOOL result,NSString *message))block
{
    NSString *phone = [KMUserManager getInstance].currentUser.phone;
    NSString *session = [KMUserManager getInstance].currentUser.sessionid;
    NSString *sessionpwd = [[KMUserManager getInstance].currentUser.sessionid md5WithTimes:6];
    [self checkConponMessageSendStatusInfo];
    if ([self checkConponMessageSendStatusWithtcode:tcode]) {
        return;
    }
    [KMRequestCenter requestSendLotteryMessageWithPhoneNum:phone sessionId:session sessionIdPwd:sessionpwd tcode:tcode success:^(NSDictionary *dic) {
        [self writeConponMessageSendStatusWithtcode:tcode];
        block(YES,@"发送成功");
    } failure:^(int result, NSString *errorStr) {
        block(result,errorStr);
    }];
}
- (void)sendConponMessageWithtcode:(NSString *)tcode comlation:(void(^)(BOOL result,NSString *message))block
{
    
    NSString *phone = [KMUserManager getInstance].currentUser.phone;
    NSString *session = [KMUserManager getInstance].currentUser.sessionid;
    NSString *sessionpwd = [[KMUserManager getInstance].currentUser.sessionid md5WithTimes:6];
    [self checkConponMessageSendStatusInfo];
    if ([self checkConponMessageSendStatusWithtcode:tcode]) {
        return;
    }
    [KMRequestCenter requestSendConponMessageWithPhoneNum:phone sessionId:session sessionIdPwd:sessionpwd tcode:tcode success:^(NSDictionary *dic) {
        [self writeConponMessageSendStatusWithtcode:tcode];
        block(YES,@"发送成功");
    } failure:^(int result, NSString *errorStr) {
        block(result,errorStr);
    }];
}
- (void)getHistoryInfoWithtcode:(NSString *)tcode conponType:(KMConponType)type  comlation:(void(^)(BOOL result,NSArray *list))block
{
    NSString *phone = [KMUserManager getInstance].currentUser.phone;
    NSString *session = [KMUserManager getInstance].currentUser.sessionid;
    NSString *sessionpwd = [[KMUserManager getInstance].currentUser.sessionid md5WithTimes:6];
    [KMRequestCenter requestForHistoryWithPhoneNum:phone sessionId:session sessionIdPwd:sessionpwd tcode:tcode conponType:type success:^(NSDictionary *dic) {
        NSMutableArray *historyList = [NSMutableArray new];
        for (NSDictionary *historydic in dic) {
            KMHistory *history = [[KMHistory alloc]initWithDict:historydic];
            [historyList addObject:history];
            
        }
        block(YES,historyList);
    } failure:^(int result, NSString *errorStr) {
        block(NO,nil);
    }];
    
}
- (BOOL)checkConponMessageSendStatusWithtcode:(NSString *)tcode
{
    NSMutableDictionary *dic = [[[NSUserDefaults standardUserDefaults]objectForKey:@"MessageStatus"]objectForKey:@"tcodes"];
    int times = [[dic objectForKey:tcode]intValue];
    if (times >= 3) {
        [LCProgressHUD showInfoMsg:@"此信息今日已发送3次，请查看您的手机"];
        return YES;
    }
    return NO;
}


- (BOOL)writeConponMessageSendStatusWithtcode:(NSString *)tcode
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[[NSUserDefaults standardUserDefaults]objectForKey:@"MessageStatus"]objectForKey:@"tcodes"]];
    int times = [[dic objectForKey:tcode]intValue];
    if (times>0) {
        times ++;
        [dic setObject:[NSString stringWithFormat:@"%d",times] forKey:tcode];
    }else{
        [dic setObject:@"1" forKey:tcode];
    }
    NSMutableDictionary *statusDic =  [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"MessageStatus"]];
    [statusDic setObject:dic forKey:@"tcodes"];
    
    [[NSUserDefaults standardUserDefaults]setObject:statusDic forKey:@"MessageStatus"];
    return [[NSUserDefaults standardUserDefaults]synchronize];
}


- (void)checkConponMessageSendStatusInfo
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"MessageStatus"];
    if (dic) {
        NSDate *sendDate = [dic objectForKey:@"sendDate"];
        if ([self isSendDateBeyondOnedayWithDate:sendDate]) {
            //生成一个新的字典记录发送状态
            NSMutableDictionary *statusDic = [NSMutableDictionary new];
            [statusDic setObject:[NSMutableDictionary new] forKey:@"tcodes"];
            [statusDic setObject:[NSDate date] forKey:@"sendDate"];
            [[NSUserDefaults standardUserDefaults]setObject:statusDic forKey:@"MessageStatus"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }else{
        NSMutableDictionary *statusDic = [NSMutableDictionary new];
        [statusDic setObject:[NSMutableDictionary new] forKey:@"tcodes"];
        [statusDic setObject:[NSDate date] forKey:@"sendDate"];
        [[NSUserDefaults standardUserDefaults]setObject:statusDic forKey:@"MessageStatus"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

- (BOOL)isSendDateBeyondOnedayWithDate:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:date toDate:[NSDate date] options:0];
    BOOL result = NO;
    if (d.day >0) {
        result = YES;
    }
    return result;
}

@end
