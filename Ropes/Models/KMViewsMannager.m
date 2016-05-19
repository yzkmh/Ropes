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
            if ([[conponInfo objectForKey:@"error"] isEqualToString:@"成功"]) {
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
                    if ([[conponInfo objectForKey:@"error"] isEqualToString:@"成功"]) {
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
                block(NO,nil);
            }];
        }
        else if (type  == KMAuthenticationType) {
            NSString *session = [KMUserManager getInstance].currentUser.sessionid;
            NSString *sessionpwd = [[KMUserManager getInstance].currentUser.sessionid md5WithTimes:6];
            [KMRequestCenter requestAuthenticationInfoWithPhoneNum:phone sessionId:session sessionIdPwd:sessionpwd  success:^(NSDictionary *dic) {
                for (NSDictionary *conponInfo in dic)
                {
                    if ([[conponInfo objectForKey:@"error"] isEqualToString:@"成功"]) {
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
                block(NO,nil);
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
            KMLottery *lottery = [[KMLottery alloc]initWithDict:lotterydic];
              if ([lottery.state  isEqual: @0]) {
                  [lotteryCanList addObject:lottery];
              }else{
                  [lotteryNotList addObject:lottery];
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
    
    [KMRequestCenter requestSendLotteryMessageWithPhoneNum:phone sessionId:session sessionIdPwd:sessionpwd tcode:tcode success:^(NSDictionary *dic) {
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
    
    [KMRequestCenter requestSendConponMessageWithPhoneNum:phone sessionId:session sessionIdPwd:sessionpwd tcode:tcode success:^(NSDictionary *dic) {
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
@end
