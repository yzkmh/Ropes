//
//  KMViewsMannager.h
//  Ropes
//
//  Created by sunsea on 16/5/5.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMRequestCenter.h"

@interface KMViewsMannager : NSObject

//单例
+ (KMViewsMannager *)getInstance;
/**
 *  获取界面信息
 *
 *  @param type  1.折扣券 2.代金券 3.身份认证
 *  @param block 回调
 */
- (void)getViewsInfomationWithConponType:(KMConponType)type
                               comlation:(void(^)(BOOL result,NSArray *list))block;
/**
 *  查询彩票信息
 *
 *  @param phone 手机号
 *  @param block 回调
 */
- (void)getLotteryInfoWithPhoneNum:(NSString *)phone comlation:(void(^)(BOOL result,NSArray *list))block;
/**
 *  查询商店信息
 *
 *  @param phone 手机号
 *  @param tcode 辅助码
 *  @param block 回调
 */
- (void)getShopInfoWithPhoneNum:(NSString *)phone tcode:(NSString *)tcode comlation:(void(^)(BOOL result,NSArray *list))block;
/**
 *  查询代金券等信息
 *
 *  @param phone 手机号
 *  @param block 回调
 */
- (void)getVoucerInfoWithPhoneNum:(NSString *)phone comlation:(void(^)(BOOL result,NSArray *list))block;
/**
 *  发送优惠券到手机
 *
 *  @param tcode 辅助码
 *  @param block 回调
 */
- (void)sendMessageWithtcode:(NSString *)tcode comlation:(void(^)(BOOL result,NSString *message))block;
/**
 *  获取使用记录
 *
 *  @param tcode 辅助码
 *  @param block 回调
 */
- (void)getHistoryInfoWithtcode:(NSString *)tcode comlation:(void(^)(BOOL result,NSArray *list))block;


@end
