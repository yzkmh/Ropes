//
//  KMNetWorkingManager.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/3/27.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "KMNetWorkingManager.h"
#import "LCProgressHUD.h"

@implementation KMNetWorkingManager

static KMNetWorkingManager *_instance = nil;

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBASEURL]];
        _instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", nil];
        _instance.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return _instance;
}

+ (void)checkNetWorkStatus{
    
    /**
     *  AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     *  AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     *  AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G
     *  AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络Wifi
     */
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusNotReachable){
            
            NSLog(@"网络连接已断开，请检查您的网络！");
            
            return ;
        }
    }];
}
- (void)postWithParameters:(NSDictionary *)parameters
                    subUrl:(NSString *)suburl
                     block:(void (^)(NSDictionary *resultDic, NSError *error))block{
    
    [[self class] checkNetWorkStatus];
    NSString *urlString = [NSString stringWithFormat:@"%@.htmls",suburl];
    NSLog(@"urlstring = %@",urlString);
    NSLog(@"parameter = %@",parameters);
    
   [[[self class] sharedManager] POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       NSError *error;
       NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
       NSLog(@"resultDic -- %@",dic);
       if (block && dic) {
          block(dic,error);
       }else{
           NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
           if ([aString isEqualToString:@"true"]) {
               block(@{@"result":@"true"},error);
           }else{
               block(nil,error);
           }
       }

   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       // 请求失败
       if (error.code == -1001) {
           [LCProgressHUD showFailure:@"请求超时，请重试"];
       }
       NSLog(@"error -- %@",error);
       
       if (block) {
           block(nil,error);
       }
       NSLog(@"%@", [error localizedDescription]);
   }];
    
}

- (void)getWithParameters:(NSDictionary *)parameters
                   subUrl:(NSString *)suburl
                    block:(void (^)(NSDictionary *resultDic, NSError *error))block
{
    [[self class] checkNetWorkStatus];
    NSString *urlString = [NSString stringWithFormat:@"%@.htmls",suburl];
    NSLog(@"urlstring = %@",urlString);
    NSLog(@"parameter = %@",parameters);
    
    [[[self class] sharedManager] GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        NSLog(@"resultDic -- %@",dic);
        if (block && dic) {
            block(dic,error);
        }else{
            NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([aString isEqualToString:@"true"]) {
                block(@{@"result":@"true"},error);
            }else{
                block(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        if (error.code == -1001) {
            [LCProgressHUD showFailure:@"请求超时，请重试"];
        }
        NSLog(@"error -- %@",error);
        
        if (block) {
            block(nil,error);
        }
        NSLog(@"%@", [error localizedDescription]);
    }];
}
#pragma mark 取消网络请求
- (void)cancelRequest{
    
    NSLog(@"cancelRequest");
    [[[[self class] sharedManager] operationQueue] cancelAllOperations];
    
}
@end
