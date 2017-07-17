//
//  ServerResponseDataValidityTest.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "ServerResponseDataValidityTest.h"
#import "ProjectHelper.h"
#import "NSDictionary+Contain.h"
#import "AppErrorCode.h"
#import "ErrorCodeEnum.h"
#import "ErrorBean.h"
#import "GlobalConstant.h"

@implementation ServerResponseDataValidityTest

#pragma mark 实现 IServerResponseDataValidityTest 接口
/**
 *  测试服务器返回的数据, 在业务上是否有效
 *
 *  @param serverResponseDataDictionary 数据字典
 *  @param errorOUT 如果业务上无效, 就通过这个参数回传外部调用者
 *
 *  @return YES : 业务上有效, NO : 业务上无效.
 */
- (BOOL)isServerResponseDataValid:(in NSDictionary *)serverResponseDataDictionary errorOUT:(out ErrorBean **)errorOUT {
  
  NSInteger errorCode = ErrorCodeEnum_Server_Error;
  NSString *errorMessage = nil;
  do {
    if (![serverResponseDataDictionary containsKey:@"code"]) {
      errorCode = ErrorCodeEnum_Server_LostErrorCodeField;
      errorMessage = @"服务器返回的数据中, 丢失错误码字段(status)";
      break;
    }
    
    NSNumber *retcode = serverResponseDataDictionary[@"code"];
    NSString *retmsg = serverResponseDataDictionary[@"msg"];
    if (retcode.intValue != AppErrorCodeEnum_Server_Custom_Error_Success) {
      errorCode = retcode.intValue;
      errorMessage = retmsg;
      
      // TODO: 判断token是否无效, 如果无效就需要用户重新登录
      if (errorCode == AppErrorCodeEnum_Server_Custom_Error_TokenInvalid) {
        
        NSNotification *notification = [NSNotification notificationWithName:kLocalBroadcastAction_TokenInvalid object:nil];
        [ProjectHelper sendAsyncNotification:notification];
      }
      break;
    }
    
    if (![serverResponseDataDictionary containsKey:@"data"]) {
      errorCode = ErrorCodeEnum_Server_LostDataField;
      errorMessage = @"服务器返回的数据中, 丢失有效数据字段(data).";
      break;
    }
    
    return YES;
  } while (NO);
  
  // 服务器端告知客户端, 本次请求发生错误.
  if (errorOUT != NULL) {
    *errorOUT = [ErrorBean errorBeanWithErrorCode:errorCode errorMessage:errorMessage];
  }
  // 服务器告知客户端, 本次网络业务请求逻辑上有效
  return NO;
}

@end
