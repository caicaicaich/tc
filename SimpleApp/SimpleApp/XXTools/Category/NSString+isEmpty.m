//
//  NSString+isEmpty.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "NSString+isEmpty.h"

@implementation NSString (isEmpty)

-(BOOL)isNotEmpty{
  return !(self == nil
           || ([self respondsToSelector:@selector(length)]
               && [(NSString *)self length] == 0)
           || [self isKindOfClass:[NSNull class]]
           || ([self respondsToSelector:@selector(length)]
               && [(NSData *)self length] == 0)
           || ([self respondsToSelector:@selector(count)]
               && [(NSArray *)self count] == 0)
           || ([self isKindOfClass:[NSDictionary class]]
               && [(NSDictionary *)self allValues].count == 0));
  
}

+ (BOOL)compareTwoStringsAreTheSameWithStringA:(NSString *)stringA andStringB:(NSString *)stringB {
  do {
    if ([NSString isEmpty:stringA] && [NSString isEmpty:stringB]) {
      // 两个空字符串, 我们认为是相同的
      break;
    }
    
    //
    if ([stringA isEqualToString:stringB]) {
      break;
    }
    
    return NO;
  } while (NO);
  
  return YES;
}

+ (BOOL)isEmpty:(NSString *)string {
  do {
    if (![string isKindOfClass:[NSString class]]) {
      break;
    }
    
    if ([string length] <= 0) {
      break;
    }
    
    return NO;
  } while (NO);
  
  return YES;
}

- (BOOL)isNull
{
  if (!self) return YES;
  if (self == nil) return YES;
  if ([self isKindOfClass:[NSNull class]]) return YES;
  return NO;
  
}

@end
