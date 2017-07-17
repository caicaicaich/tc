//
//  LoginDomainBeanHelper.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "LoginDomainBeanHelper.h"
#import "ErrorCodeEnum.h"
#import "LoginNetRespondBean.h"
#import "UrlConstantForThisProject.h"
#import "NSString+isEmpty.h"
#import "ErrorBean.h"

@implementation LoginDomainBeanHelper

/**
 * 当前业务Bean, 对应的URL地址.
 * @return
 */
- (NSString *)specialUrlPathWithNetRequestBean:(id)netRequestBean {
  return UrlConstant_SpecialPath_login;
}

/**
 * 考虑到后台不是同时都支持GET和POST请求, 而做的设计
 * @return GET/POST
 */
- (NSString *)httpMethod:(in id)netRequestBean {
  return @"POST";
}

/**
 * 检查当前NetRespondBean是否有效
 * 这里的设计含义是 : 我们因为直接使用KVC, 将网络返回的数据字典直接解析成NetRespondBean, 但是这里有个隐患, 就是服务器返回的数据字典可能和本地的NetRespondBean字段不匹配, 所以每个NetRespondBean都应该设计有核心字段的概念, 只要服务器返回的数据字典包含有核心字典, 就认为本次数据有效,比如说登录接口,当登录成功后, 服务器会返回username和uid和其他一些字段, 那么uid和username就是核心字段, 只要这两个字段有效就可以认为本次网络请求有效
 * @return
 */
- (BOOL)isNetRespondBeanValidity:(in LoginNetRespondBean *)netRespondBean errorOUT:(out ErrorBean **)errorOUT {
  NSString *errorMessage = nil;
  do {
//    if (netRespondBean.userId < 0) {
//      errorMessage = @"服务器返回的数据 丢失关键字段 userId.";
//      break;
//    }
    
    return YES;
  } while (NO);
  
  if (errorOUT != NULL) {
    *errorOUT = [ErrorBean errorBeanWithErrorCode:ErrorCodeEnum_Server_LostCoreField errorMessage:errorMessage];
  }
  return NO;
}


@end
