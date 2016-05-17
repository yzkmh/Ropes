//
//  KMTransaction.m
//  Ropes
//
//  Created by Madoka on 16/5/13.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMTransaction.h"
#import "JsonUtil.h"
@implementation KMTransaction
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [JsonUtil bindDicData:dict Object:self];
    }
    return self;
}

+ (instancetype)transactionWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
@end
