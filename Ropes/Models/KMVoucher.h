//
//  KMVoucher.h
//  Ropes
//
//  Created by sunsea on 16/5/6.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMVoucher : NSObject

@property (nonatomic ,strong) NSString *policyName;//名称
@property (nonatomic ,strong) NSString *policyType;//类型
@property (nonatomic ,strong) NSString *policyDescription;//描述 使用条件
@property (nonatomic ,strong) NSString *consumeCount;//金额总数
@property (nonatomic ,strong) NSNumber *consumetype;//消费类型 1.一次2.多次3.固定
@property (nonatomic ,strong) NSString *balance;//当前余额
@property (nonatomic ,strong) NSString *invalidDate;//有效期
@property (nonatomic ,strong) NSString *useCounttype;//使用次数类型 1.单 2.双
@property (nonatomic ,strong) NSString *useCount;//可使用次数（总次数）
@property (nonatomic ,strong) NSString *usedCount;//已使用次数
@property (nonatomic ,strong) NSString *discountRate;//折扣率 *100
@property (nonatomic ,strong) NSString *senceName;//场景名称 企业名称
@property (nonatomic ,strong) NSString *address;//店铺详细地址
@property (nonatomic ,strong) NSString *detailName;//可使用门店
@property (nonatomic ,strong) NSString *usedDetail;//消费地点
@property (nonatomic ,strong) NSString *usedDate;//消费时间
@property (nonatomic ,strong) NSString *consume;//当次消费

@property (nonatomic ,strong) NSString *state;//状态
@property (nonatomic ,strong) NSString *tcode;//券编号


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)userWithDict:(NSDictionary *)dict;
@end
