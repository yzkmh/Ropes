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
                               comlation:(void(^)(BOOL result,NSString *message, id user))block
{
    NSString *phone = [KMUserManager getInstance].currentUser.phone;
    NSString *session = [KMUserManager getInstance].currentUser.sessionid;
    NSString *sessionpwd = [[KMUserManager getInstance].currentUser.sessionid md5WithTimes:6];
    
    [KMRequestCenter requestViewInformationWithphoneNum:phone sessionId:session sessionIdPwd:sessionpwd conponType:type success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
    } failure:^(int code, NSString *ErrorStr) {
        NSLog(@"%@",ErrorStr);
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
              }else if([lottery.state  isEqual: @2]){
                  [lotteryNotList addObject:lottery];
              }
        }
        NSLog(@"获取彩票数据成功");
        block(YES,@[lotteryCanList,lotteryNotList]);
    } failure:^(int code, NSString *ErrorStr) {
        
    }];
}

- (void)getShopInfoWithPhoneNum:(NSString *)phone tcode:(NSString *)tcode comlation:(void(^)(BOOL result,NSArray *list))block
{
    [KMRequestCenter requestShopInfoWithPhoneNum:phone tcode:tcode success:^(NSDictionary *dic) {
        //KMShop *shop = [[KMShop alloc]initWithDict:dic];
        NSMutableArray *shopList = [NSMutableArray new];
        for (NSDictionary *lotterydic in dic) {
            KMShop *shop = [[KMShop alloc]initWithDict:lotterydic];
            [shopList addObject:shop];
            
        }
        block(YES,shopList);
    } failure:^(int code, NSString *errorStr) {
        
    }];
}

- (void)getVoucerInfoWithPhoneNum:(NSString *)phone comlation:(void(^)(BOOL result,NSArray *list))block
{
    [KMRequestCenter requestVoucherInfoWithPhoneNum:phone success:^(NSDictionary *dic) {
        
    } failure:^(int code, NSString *errorStr) {
        
    }];
}
@end
