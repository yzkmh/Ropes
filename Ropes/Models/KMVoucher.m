//
//  KMVoucher.m
//  Ropes
//
//  Created by sunsea on 16/5/6.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMVoucher.h"
#import "JsonUtil.h"

@implementation KMVoucher
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [JsonUtil bindDicData:dict Object:self];
    }
    return self;
}

+ (instancetype)userWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
@end
