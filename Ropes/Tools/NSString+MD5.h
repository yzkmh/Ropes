//
//  NSString+MD5.h
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/3/27.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
@interface NSString (MD5)
/**
 *  字符串的md5密文
 */
@property (nonatomic, readonly) NSString *md5String;
/**
 *  多次MD5
 *
 *  @param times 加密次数
 *
 *  @return 加密密文
 */
- (NSString *)md5WithTimes:(NSInteger)times;
@end
