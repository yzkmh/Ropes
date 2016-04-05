//
//  NSNumber+FlickerNumber.m
//  Ropes
//
//  Created by 桐崎艾莉欧 on 16/4/4.
//  Copyright © 2016年 Madoka. All rights reserved.
//

#import "NSNumber+FlickerNumber.h"

@implementation NSNumber (FlickerNumber)
- (NSString *)formatNumberDecimal{
    
    if(self){
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        
        NSString *string = @"0";
        
        if([self multipleLongForNumber]){//long
            
            string = [formatter stringFromNumber:[NSNumber numberWithLong:[self longValue]]];
            
        }else{//double
            
            string = [formatter stringFromNumber:[NSNumber numberWithDouble:[self doubleValue]]];
            
        }
        
        return [NSString stringWithFormat:@"%@.00",string];
        
    }
    
    return @"0.00";
    
}


//是否是整数

- (BOOL)multipleLongForNumber{
    
    NSString *str = [NSString stringWithFormat:@"%@",self];
    
    if([str rangeOfString:@"."].location == NSNotFound){
        
        return YES;
        
    }
    
    return NO;
    
}



@end
