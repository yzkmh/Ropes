//
//  KMNetWorkingManager.h
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/3/27.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFNetworking.h"
@interface KMNetWorkingManager : AFHTTPSessionManager
/**
 *  单例
 */
+ (instancetype)sharedManager;
/**
 *  检测网络状态
 */
+ (void)checkNetWorkStatus;
/**
 *  post网络请求
 *
 *  @param parameters 参数
 *  @param suburl     接口
 *  @param block      Block回调
 */
- (void)postWithParameters:(NSDictionary *)parameters
                    subUrl:(NSString *)suburl
                     block:(void (^)(NSDictionary *resultDic, NSError *error))block;
/**
 *  get网络请求
 *
 *  @param parameters 参数
 *  @param suburl     接口
 *  @param block      Block回调
 */
- (void)getWithParameters:(NSDictionary *)parameters
                   subUrl:(NSString *)suburl
                    block:(void (^)(NSDictionary *resultDic, NSError *error))block;
/**
 *  取消网络请求
 */
- (void)cancelRequest;
@end
