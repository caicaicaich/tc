//
//  LoginParseDomainBeanToDD.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "LoginParseDomainBeanToDD.h"
#import "NSString+isEmpty.h"
#import "LoginNetRequestBean.h"
#import "NSString+Helper.h"
#import "ErrorBean.h"

@implementation LoginParseDomainBeanToDD


/**
 *  将一个 "网络请求业务Bean" 解析成发往服务器的 "数据字典", 在这里设置的Key, 是跟服务器约定好的
 *
 *  @param netRequestDomainBean 网络请求业务Bean
 *  @param error                如果出现错误, 就通过这个error参数传递出去, 错误的原因可能用户传入的 netRequestDomainBean 无效
 *
 *  @return "发往服务器的数据字典"
 */
- (NSDictionary *)parseNetRequestDomainBeanToDataDictionary:(in LoginNetRequestBean *)netRequestBean error:(out ErrorBean *__autoreleasing *)errorOUT {
   NSString *errorMessage = nil;
  do {
    if (![netRequestBean isMemberOfClass:[LoginNetRequestBean class]]) {
      errorMessage = @"传入的业务Bean的类型不符 !";
      break;
    }
    
    if ([NSString isEmpty:netRequestBean.loginName]) {
      errorMessage = @"丢失关键参数 : loginName";
      break;
    }
    if ([NSString isEmpty:netRequestBean.password]) {
      errorMessage = @"丢失关键参数 : password";
      break;
    }
    
    if ([NSString isEmpty:netRequestBean.token]) {
      errorMessage = @"丢失关键参数 : token";
      break;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //
    params[@"loginName"] = netRequestBean.loginName;
    
    /**
     * MD5简介
     * Message Digest Algorithm MD5（中文名为消息摘要算法第五版）
     * 为计算机安全领域广泛使用的一种散列函数，用以提供消息的完整性保护。
     *
     * MD5即Message-Digest Algorithm 5（信息-摘要算法5），
     * 用于确保信息传输完整一致。是计算机广泛使用的杂凑算法之一（又译摘要算法、哈希算法）
     *
     *
     * MD5应用
     * 1.一致性验证 : 典型应用是对一段信息（Message）产生信息摘要（Message-Digest），以防止被篡改。
     * 2.数字签名 : MD5的典型应用是对一段Message(字节串)产生fingerprint(指纹），以防止被“篡改”。
     * 3.安全访问认证 : MD5还广泛用于操作系统的登陆认证上，
     *      如Unix、各类BSD系统登录密码、数字签名等诸多方面。
     *      如在Unix系统中用户的密码是以MD5（或其它类似的算法）经Hash运算后存储在文件系统中。
     *      当用户登录的时候，系统把用户输入的密码进行MD5 Hash运算，然后再去和保存在文件系统中的MD5值进行比较，
     *      进而确定输入的密码是否正确。通过这样的步骤，系统在并不知道用户密码的明码的情况下就可以确定用户登
     *      录系统的合法性。这可以避免用户的密码被具有系统管理员权限的用户知道。
     */
    //params[@"password"] = [netRequestBean.password md5];
    params[@"password"] = netRequestBean.password;
    params[@"token"] = netRequestBean.token;
      

    
    // 通知外部, 一切OK
    if (errorOUT != NULL) {
      *errorOUT = nil;
    }
    return params;
  } while (NO);
  
  // 通知外部, 发生了错误
  if (errorOUT != NULL) {
    *errorOUT = [ErrorBean errorBeanWithErrorCode:1005 errorMessage:errorMessage];
  }
  return nil;
  
}

@end
