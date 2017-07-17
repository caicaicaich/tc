//
//  ListNetRequestBeanEx.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "ListNetRequestBeanEx.h"
#import "PRPDebug.h"

@implementation ListNetRequestBeanEx

- (instancetype)initWithOffset:(NSInteger)offset limit:(NSInteger)limit {
  
  if ((self = [super init])) {
    _offset = offset;
    _limit = limit;
  }
  
  return self;
}

- (instancetype)initWithOffset:(NSInteger)offset {
  if ((self = [super init])) {
    _offset = offset;
    _limit = 20;
  }
  
  return self;
}
- (NSString *)description {
  return descriptionForDebug(self);
}

@end
