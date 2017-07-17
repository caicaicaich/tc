//
//  DomainBeanStub.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "DomainBeanStub.h"
#import "RNAssert.h"

@implementation DomainBeanStub

- (instancetype)initWithIsUseStub:(BOOL)isUseStub {
  
  if ((self = [super init])) {
    _isUseStub = isUseStub;
  }
  
  return self;
}

#pragma mark -
#pragma mark - 不能使用默认的init方法初始化对象, 而必须使用当前类特定的 "初始化方法" 初始化所有参数
- (nullable instancetype)init {
  RNAssert(NO, @"Can not use the default init method!");
  
  return nil;
}


- (id)netRespondBeanStubByNetRequestBean:(id)netRequestBean {
  return nil;
}

@end
