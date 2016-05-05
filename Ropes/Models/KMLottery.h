//
//  KMLottery.h
//  Ropes
//
//  Created by sunsea on 16/5/5.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMLottery : NSObject

@property (nonatomic ,copy) NSString *lotteryTypeName;
@property (nonatomic ,copy) NSString *lotteryNumber;
@property (nonatomic ,copy) NSString *lotterySchedule;
@property (nonatomic ,copy) NSString *lotteryGetDate;
@property (nonatomic ,copy) NSString *lotteryPrizeResult;
@property (nonatomic ,copy) NSString *lotteryPrizeDate;
@property (nonatomic ,copy) NSString *tcode;
@property (nonatomic ,copy) NSString *policyType;
@property (nonatomic ,copy) NSString *senceName;
@property (nonatomic ,copy) NSString *usedCount;
@property (nonatomic ,copy) NSString *useCount;
@property (nonatomic ,copy) NSNumber *state;
@property (nonatomic ,copy) NSString *useCounttype;
@property (nonatomic ,copy) NSString *invalidDate;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)userWithDict:(NSDictionary *)dict;
@end
