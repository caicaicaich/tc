//
//  RequestDomainBeanContentTypeEnum.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#ifndef RequestDomainBeanContentTypeEnum_h
#define RequestDomainBeanContentTypeEnum_h

//发起业务接口请求时,所使用的 http content-type
typedef NS_ENUM (NSInteger, RequestDomainBeanContentTypeEnum) {
  RequestDomainBeanContentTypeEnum_Normal = 0, // 通常情况
  RequestDomainBeanContentTypeEnum_Json   = 1  // JSON ("application/json;charset:utf-8")
};


#endif /* RequestDomainBeanContentTypeEnum_h */
