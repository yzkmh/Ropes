//
//  KMShop.h
//  Ropes
//
//  Created by sunsea on 16/5/6.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMShop : NSObject
@property (nonatomic ,strong) NSString *address;
@property (nonatomic ,strong) NSString *telNum;
@property (nonatomic ,strong) NSString *useCounttype;
@property (nonatomic ,strong) NSString *consumetype;
@property (nonatomic ,strong) NSString *policyType;
@property (nonatomic ,strong) NSString *discountRate;
@property (nonatomic ,strong) NSString *detailName;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)userWithDict:(NSDictionary *)dict;

@end
