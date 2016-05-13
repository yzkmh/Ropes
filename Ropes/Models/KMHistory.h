//
//  KMHistory.h
//  Ropes
//
//  Created by yzk on 16/5/12.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMHistory : NSObject
@property (nonatomic ,strong) NSString *policyName;
@property (nonatomic ,strong) NSString *usedDetail;
@property (nonatomic ,strong) NSString *usedData;
@property (nonatomic ,strong) NSString *consume;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)userWithDict:(NSDictionary *)dict;
@end
