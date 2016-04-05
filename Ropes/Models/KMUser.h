//
//  KMUser.h
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/3/27.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMUser : NSObject<NSCoding>

// id
@property (nonatomic, copy) NSString *userId;
// 姓名
@property (nonatomic, copy) NSString *name;
// 电话
@property (nonatomic, copy) NSString *phone;
// 性别 1男 2女
@property (nonatomic, assign) NSInteger gender;
// 密码
@property (nonatomic, copy) NSString *pwd;
// 银行卡
@property (nonatomic, copy) NSString *bandcard;
// 银行
@property (nonatomic, copy) NSString *bank;
// 地址
@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *sessionid;

@property (nonatomic, assign) BOOL isAutoLogin;
@property (nonatomic, assign) BOOL isRememberPwd;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)userWithDict:(NSDictionary *)dict;
@end
