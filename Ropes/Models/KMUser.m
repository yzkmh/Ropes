//
//  KMUser.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/3/27.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMUser.h"
#import <objc/runtime.h>
#import "JsonUtil.h"

@implementation KMUser

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

// 持久化
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // 把自定义对象归档的时候, 必须遵守NSCoding协议
    // 获取成员变量列表
    [aCoder encodeObject:self.userId forKey:@"userid"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%ld",(long)self.gender] forKey:@"gender"];
    [aCoder encodeObject:self.pwd forKey:@"pwd"];
    [aCoder encodeObject:self.bankcard forKey:@"bankcard"];
    [aCoder encodeObject:self.bankname forKey:@"bankname"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.sessionid forKey:@"sessionid"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.isAutoLogin] forKey:@"isAutoLogin"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.isRememberPwd] forKey:@"isRememberPwd"];
    [aCoder encodeObject:self.loginDate forKey:@"loginDate"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    // 反归档 从文件中还原对象
    self.userId = [aDecoder decodeObjectForKey:@"userId"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.phone = [aDecoder decodeObjectForKey:@"phone"];
    self.gender = [[aDecoder decodeObjectForKey:@"gender"]intValue];
    self.pwd = [aDecoder decodeObjectForKey:@"pwd"];
    self.bankcard = [aDecoder decodeObjectForKey:@"bankcard"];
    self.bankname = [aDecoder decodeObjectForKey:@"bankname"];
    self.address = [aDecoder decodeObjectForKey:@"address"];
    self.sessionid = [aDecoder decodeObjectForKey:@"sessionid"];
    self.isAutoLogin = [[aDecoder decodeObjectForKey:@"isAutoLogin"]boolValue];
    self.isRememberPwd = [[aDecoder decodeObjectForKey:@"isRememberPwd"]boolValue];
    self.loginDate = [aDecoder decodeObjectForKey:@"loginDate"];
    return self;
}


@end
