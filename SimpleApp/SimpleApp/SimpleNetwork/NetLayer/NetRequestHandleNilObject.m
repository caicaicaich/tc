//
//  NetRequestHandleNilObject.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "NetRequestHandleNilObject.h"

@implementation NetRequestHandleNilObject

/**
 * 判断当前网络请求, 是否处于空闲状态(只有处于空闲状态时, 才应该发起一个新的网络请求)
 *
 * @return BOOL
 */
- (BOOL)isBusy {
  return  NO;
}

/**
 * 取消当前请求
 */
- (void)cancel{
  
}

@end
