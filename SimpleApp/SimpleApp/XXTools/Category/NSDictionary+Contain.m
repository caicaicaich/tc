//
//  NSDictionary+Contain.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "NSDictionary+Contain.h"

@implementation NSDictionary (Contain)

- (BOOL)containsKey:(id)key {
  if (key == nil || [key isKindOfClass:[NSNull class]]) {
    // 入参非法
    return NO;
  }
  
  NSArray *keys = [self allKeys];
  for (id item in keys) {
    if ([item isEqual:key]) {
      return YES;
    }
  }
  
  return NO;
}

- (BOOL)containsValue:(id)value {
  if (value == nil) {
    // 入参非法
    return NO;
  }
  
  NSArray *values = [self allValues];
  for (id item in values) {
    if ([item isEqual:value]) {
      return YES;
    }
  }
  
  return NO;
}

@end
