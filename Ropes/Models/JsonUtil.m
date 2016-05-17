//
//  JsonUtil.m
//  GyyxQiBao
//
//  Created by wangcheng on 15/6/8.
//  Copyright (c) 2015年 gyyx. All rights reserved.
//

#import "JsonUtil.h"

#import <objc/runtime.h>

@implementation NSObject (PropertyListing)

/**
 *  获取对象的所有非空属性转为字典
 *
 *  @return 字典: 属性：属性值
 */
- (NSMutableDictionary *)properties2Dic
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue)
        {
            [props setObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    return props;
}


/**
 *  获取对象的所有属性转为数组
 *
 *  @return 数组
 */
- (NSMutableArray *)properties2Arr
{
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        
            [props addObject:propertyName ];
       
    }
   
    return props;
}



- (void) bindDicData:(NSDictionary*)dicData
{
    NSMutableArray* arrTarget = [self properties2Arr];
    for (id prop in arrTarget)
    {
        if([dicData objectForKey:prop])
        {
            [self setValue:[dicData objectForKey:prop] forKey:prop];
        }
        
    }
}

@end

@implementation JsonUtil

/**
 * @brief   将jsonData绑定到字典
 * @return  字典
 */
+(NSMutableDictionary *) bindJsonData:(NSData*)jsonData Dic:(NSMutableDictionary *)targetDic
{
    NSMutableDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    for (id key in [targetDic allKeys])
    {
        if([jsonDic objectForKey:key])
        {
            [targetDic setObject:[jsonDic objectForKey:key] forKey:key];
        }
    }
    
    return targetDic;
}

/**
 * @brief   将jsonData绑定到对象
 * @return  无返回
 */
+ (id) bindJsonData:(NSData*)jsonData Object:(id)targetObj
{
    NSMutableDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableArray* arrTarget = [targetObj properties2Arr];
    for (id prop in arrTarget)
    {
        if([jsonDic objectForKey:prop])
        {
             [targetObj setValue:[jsonDic objectForKey:prop] forKey:prop];
        }
       
    }

    return targetObj;
}


/**
 * @brief   将字典绑定到对象
 * @return  无返回
 */
+ (id) bindDicData:(NSDictionary*)dicData Object:(id)targetObj
{

    NSMutableArray* arrTarget = [targetObj properties2Arr];
    for (id prop in arrTarget)
    {
        if([dicData objectForKey:prop])
        {
            [targetObj setValue:[dicData objectForKey:prop] forKey:prop];
        }
        
    }
    
    return targetObj;
}
@end
