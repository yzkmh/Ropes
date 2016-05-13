//
//  KMTransaction.h
//  Ropes
//
//  Created by Madoka on 16/5/13.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMTransaction : NSObject
@property (nonatomic, copy) NSString *requestname;
@property (nonatomic, copy) NSString *bankname;
@property (nonatomic, copy) NSString *requestdate;
@property (nonatomic, copy) NSString *cashnum;
@property (nonatomic, copy) NSString *requsetphone;
@property (nonatomic, copy) NSString *bankcard;
@property (nonatomic, copy) NSString *status;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)transactionWithDict:(NSDictionary *)dict;
@end
