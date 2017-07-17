//
//  HttpRequestHandleOfAFNetworkingOfNSURLSessionTask.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "HttpRequestHandleOfAFNetworkingOfNSURLSessionTask.h"
#import "AFNetworking.h"
#import "RNAssert.h"

@interface HttpRequestHandleOfAFNetworkingOfNSURLSessionTask ()

@property (nonatomic, strong) NSURLSessionTask *sessionTask;
@end

@implementation HttpRequestHandleOfAFNetworkingOfNSURLSessionTask

- (id)init {
  if ((self = [super init])) {
    
  }
  
  return self;
}

- (void) setSessionTask:(NSURLSessionTask *)sessionTask {
  _sessionTask = sessionTask;
}

#pragma mark -
#pragma mark - 实现 KalendsINetRequestHandle 协议
/**
 * 判断当前网络请求, 是否处于空闲状态(只有处于空闲状态时, 才应该发起一个新的网络请求)
 *
 * @return BOOL
 */
- (BOOL)isBusy {
  return (_sessionTask.state != NSURLSessionTaskStateCompleted && _sessionTask.state != NSURLSessionTaskStateCanceling);
}


/**
 * 取消当前请求
 */
- (void)cancel {
  [_sessionTask cancel];
}

#pragma mark -
#pragma mark - 实现 INetRequestIsCancelled 协议
/**
 * 判断当前网络请求是否已经被取消
 *
 * @return BOOL
 */
- (BOOL)isCancelled {
  return (self.sessionTask.state == NSURLSessionTaskStateCanceling);
}
@end
