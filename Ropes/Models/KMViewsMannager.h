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
                               comlation:(void(^)(BOOL result,NSString *message, id user))block;

- (void)getLotteryInfoWithPhoneNum:(NSString *)phone comlation:(void(^)(BOOL result,NSArray *list))block;

- (void)getShopInfoWithPhoneNum:(NSString *)phone tcode:(NSString *)tcode comlation:(void(^)(BOOL result,NSArray *list))block;

- (void)getVoucerInfoWithPhoneNum:(NSString *)phone comlation:(void(^)(BOOL result,NSArray *list))block;


@end
