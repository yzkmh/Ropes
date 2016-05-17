//
//  KMLottery.m
//  Ropes
//
//  Created by sunsea on 16/5/5.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMLottery.h"
#import "JsonUtil.h"
@implementation KMLottery
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
