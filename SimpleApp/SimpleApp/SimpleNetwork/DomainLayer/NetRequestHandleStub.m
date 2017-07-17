//
//  NetRequestHandleStub.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "NetRequestHandleStub.h"

@implementation NetRequestHandleStub
{
   BOOL _isBusy;
}

- (instancetype)init {
  if (self = [super init]) {
    _isBusy = YES;
  }
  
  return self;
}
- (void)setBusy:(BOOL)isBusy {
  _isBusy = isBusy;
}

#pragma mark -
#pragma mark - 实现 KalendsINetRequestHandle 协议
/**
 * 判断当前网络请求, 是否处于空闲状态(只有处于空闲状态时, 才应该发起一个新的网络请求)
 *
 * @return BOOL
 */
- (BOOL)isBusy {
  return _isBusy;
}

/**
 * 取消当前请求
 */
- (void)cancel {
  _isBusy = NO;
}

#pragma mark -
#pragma mark - 实现 INetRequestIsCancelled 协议
/**
 * 判断当前网络请求是否已经被取消
 *
 * @return BOOL
 */
- (BOOL)isCancelled {
  return !_isBusy;
}


@end
