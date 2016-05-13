//
//  KMHistory.m
//  Ropes
//
//  Created by yzk on 16/5/12.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMHistory.h"
#import "JsonUtil.h"

@implementation KMHistory
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
