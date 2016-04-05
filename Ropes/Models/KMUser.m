//
//  KMUser.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/3/27.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMUser.h"
#import <objc/runtime.h>

@implementation KMUser

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        //获取成员变量列表
        unsigned int count;
        objc_property_t *list = class_copyPropertyList([self class], &count);
        for (unsigned int i; i<count; i++) {
            objc_property_t pty = list[i];
            const char *cname = property_getName(pty);
            NSString *propertyName = [NSString stringWithUTF8String:cname];
            
            if (![propertyName isEqualToString:@"isAutoLogin"] && ![propertyName isEqualToString:@"isRememberPwd"]) {
                if ([propertyName isEqualToString:@"gender"]) {
                    if(dict[@"gender"] != [NSNull null]){
                        self.gender = [dict[@"gender"] intValue];
                    }
                } else {
                    if(dict[propertyName] != [NSNull null]){
                        [self setValue:dict[propertyName] forKey:propertyName];
                    }
                }
            }
        }
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
    unsigned int count;
    objc_property_t *list = class_copyPropertyList([self class], &count);
    for (unsigned int i; i<count; i++) {
        objc_property_t pty = list[i];
        const char *cname = property_getName(pty);
        NSString *propertyName = [NSString stringWithUTF8String:cname];
        if ([propertyName isEqualToString:@"gender"]) {
            
            [aCoder encodeInt:[[self valueForKey:propertyName] intValue] forKey:propertyName];
        } else {
            [aCoder encodeObject:[self valueForKey:propertyName] forKey:propertyName];
        }
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    // 反归档 从文件中还原对象
    if(self = [super init])
    {
        unsigned int count;
        objc_property_t *list = class_copyPropertyList([self class], &count);
        for (unsigned int i; i<count; i++) {
            objc_property_t pty = list[i];
            const char *cname = property_getName(pty);
            NSString *propertyName = [NSString stringWithUTF8String:cname];
            if ([propertyName isEqualToString:@"gender"]) {
                if([aDecoder decodeObjectForKey:propertyName] != [NSNull null]){
                    self.gender = [[aDecoder decodeObjectForKey:propertyName] intValue];
                }
            } else {
                [self setValue:[aDecoder decodeObjectForKey:propertyName] forKey:propertyName];
            }
        }
    }
    return self;
}

@end
