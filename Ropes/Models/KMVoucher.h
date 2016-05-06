//
//  KMVoucher.h
//  Ropes
//
//  Created by sunsea on 16/5/6.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMVoucher : NSObject
@property (nonatomic ,strong) NSString *policyName;
@property (nonatomic ,strong) NSString *balance;
@property (nonatomic ,strong) NSString *senceName;
@property (nonatomic ,strong) NSString *consumeCount;
@property (nonatomic ,strong) NSString *consumetype;
@property (nonatomic ,strong) NSString *useCounttype;
@property (nonatomic ,strong) NSString *usedCount;
@property (nonatomic ,strong) NSString *useCount;
@property (nonatomic ,strong) NSString *state;
@property (nonatomic ,strong) NSString *tcode;
@property (nonatomic ,strong) NSString *policyType;
@property (nonatomic ,strong) NSString *discountRate;
@property (nonatomic ,strong) NSString *invalidDate;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)userWithDict:(NSDictionary *)dict;
@end
