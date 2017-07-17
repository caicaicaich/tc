//
//  NSString+isEmpty.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

// 判断空字符串
@interface NSString (isEmpty)
+ (BOOL)isEmpty:(NSString *)string;
+ (BOOL)compareTwoStringsAreTheSameWithStringA:(NSString *)stringA andStringB:(NSString *)stringB;

-(BOOL)isNotEmpty;
-(BOOL)isNull;

@end
