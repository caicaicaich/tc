//
//  SearchDomainBeanHelper.m
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/16.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "SearchDomainBeanHelper.h"
#import "ErrorCodeEnum.h"
#import "UrlConstantForThisProject.h"
#import "NSString+isEmpty.h"
#import "ErrorBean.h"

@implementation SearchDomainBeanHelper

/**
 * 当前业务Bean, 对应的URL地址.
 * @return
 */
- (NSString *)specialUrlPathWithNetRequestBean:(id)netRequestBean {
    return UrlConstant_SpecialPath_search;
}

/**
 * 考虑到后台不是同时都支持GET和POST请求, 而做的设计
 * @return GET/POST
 */
- (NSString *)httpMethod:(in id)netRequestBean {
    return @"POST";
}



@end
