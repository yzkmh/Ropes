//
//  NSString+MD5.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/3/27.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "NSString+MD5.h"

@implementation NSString (MD5)

- (NSString *)md5WithTimes:(NSInteger)times
{
    NSString *str = self.copy;
    for (int i = 0; i < times; ++i) {
        str = str.md5String;
        //NSLog(@"第%d次加密, 密文:%@",i,str);
    }
    return str;
}
- (NSString *)md5String
{
    const char *str = self.UTF8String;
    int length = (int)strlen(str);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, length, bytes);
    
    return [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)stringFromBytes:(unsigned char *)bytes length:(int)length
{
    NSMutableString *strM = [NSMutableString string];
    
    for (int i = 0; i < length; i++) {
        [strM appendFormat:@"%02x", bytes[i]];
    }
    
    return [strM copy];
}
@end
