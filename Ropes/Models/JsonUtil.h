//
//  JsonUtil.h
//  GyyxQiBao
//
//  Created by wangcheng on 15/6/8.
//  Copyright (c) 2015年 gyyx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PropertyListing)
- (NSMutableDictionary *)properties2Dic;
- (NSMutableArray *)properties2Arr;

/**
 * @brief   将jsonData绑定到对象
 * @return  无返回
 */
- (void) bindDicData:(NSDictionary*)dicData;
@end

@interface JsonUtil : NSObject

/**
 * @brief   将jsonData绑定到字典
 * @return  字典
 */
+(NSMutableDictionary *) bindJsonData:(NSData*)jsonData Dic:(NSMutableDictionary *)targetDic;



/**
 * @brief   将jsonData绑定到对象
 * @return  无返回
 */
+ (id) bindJsonData:(NSData*)jsonData Object:(id)targetObj;

/**
 * @brief   将字典绑定到对象
 * @return  无返回
 */
+ (id) bindDicData:(NSDictionary*)dicData Object:(id)targetObj;

@end
