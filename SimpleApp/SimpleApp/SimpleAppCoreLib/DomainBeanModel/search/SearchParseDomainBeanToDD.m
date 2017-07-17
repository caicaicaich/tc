//
//  SearchParseDomainBeanToDD.m
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/16.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "SearchParseDomainBeanToDD.h"
#import "SearchNetRequestBean.h"
#import "ErrorBean.h"
#import "ErrorCodeEnum.h"
#import "NSString+isEmpty.h"
#import "GlobalConstant.h"


@implementation SearchParseDomainBeanToDD

/**
 *  将一个 "网络请求业务Bean" 解析成发往服务器的 "数据字典", 在这里设置的Key, 是跟服务器约定好的
 *
 *  @param netRequestDomainBean 网络请求业务Bean
 *  @param error                如果出现错误, 就通过这个error参数传递出去, 错误的原因可能用户传入的 netRequestDomainBean 无效
 *
 *  @return "发往服务器的数据字典"
 */
- (NSDictionary *)parseNetRequestDomainBeanToDataDictionary:(in SearchNetRequestBean *)netRequestDomainBean error:(out ErrorBean *__autoreleasing *)errorOUT {
    NSString *errorMessage = nil;
    do {
        if (![netRequestDomainBean isMemberOfClass:[SearchNetRequestBean class]]) {
            errorMessage = @"传入的业务Bean的类型不符 !";
            break;
        }
        
        if (netRequestDomainBean.pageNO < 0) {
            errorMessage = @"pageNO 不能小于0";
            break;
        }
        
        if (netRequestDomainBean.pageSize < 0) {
            errorMessage = @"pageSize 不能小于0";
            break;
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"name"] = netRequestDomainBean.name;
        params[@"longitude"] = netRequestDomainBean.longitude;
        params[@"latitude"] = netRequestDomainBean.latitude;
        params[@"token"] = netRequestDomainBean.token;
        params[@"pageNo"] = [NSString stringWithFormat:@"%ld",netRequestDomainBean.pageNO] ;
        params[@"pageSize"] = [NSString stringWithFormat:@"%ld",netRequestDomainBean.pageSize];
        
        // 通知外部, 一切OK
        if (errorOUT != NULL) {
            *errorOUT = nil;
        }
        return params;
    } while (NO);
    // 通知外部, 发生了错误
    if (errorOUT != NULL) {
        *errorOUT = [ErrorBean errorBeanWithErrorCode:ErrorCodeEnum_Client_NetRequestBeanInvalid errorMessage:errorMessage];
    }
    return nil;
}

@end
