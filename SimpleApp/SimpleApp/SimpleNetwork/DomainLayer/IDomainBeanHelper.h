//
//  IDomainBeanHelper.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ErrorBean;
@protocol IParseNetRequestDomainBeanToDataDictionary;

@interface IDomainBeanHelper : NSObject

/**
 * 将NetRequestDomainBean(网络请求业务Bean), 解析成发往服务器的数据字典(key要跟服务器定义的接口协议对应, value可以在这里进行二次处理, 比如密码的md5加密)
 * @return 解析业务Bean
 */
- (id<IParseNetRequestDomainBeanToDataDictionary>) parseNetRequestDomainBeanToDataDictionaryFunction;

/**
 * 当前网络接口, 对应的URL(api path)
 * @return url
 */
- (NSString *)specialUrlPathWithNetRequestBean:(id)netRequestBean;


/**
 * 当前网络接口对应的NetRespondBean
 * 我们使用KVC的方式直接从字典和Class映射成具体的模型对象, 这里设置的就是要转换的 [NetRespondBean Class]
 * @return RespondBeanClass
 */
- (Class)netRespondBeanClass;

/**
 * 检查当前NetRespondBean是否有效
 * 这里的设计含义是 : 我们因为直接使用KVC, 将网络返回的数据字典直接解析成NetRespondBean, 但是这里有个隐患, 就是服务器返回的数据字典可能和本地的NetRespondBean字段不匹配, 所以每个NetRespondBean都应该设计有核心字段的概念, 只要服务器返回的数据字典包含有核心字典, 就认为本次数据有效,比如说登录接口,当登录成功后, 服务器会返回username和uid和其他一些字段, 那么uid和username就是核心字段, 只要这两个字段有效就可以认为本次网络请求有效
 * @return BOOL
 */
- (BOOL)isNetRespondBeanValidity:(in id)netRespondBean errorOUT:(out ErrorBean **)errorOUT;

/**
 * 对 网络响应业务bean 做 数据补充
 * <p/>
 * 说明 : 有时候, 我们的 网络响应业务bean 中的一些属性是本地存在的, 那么就需要在网络请求完成时对 网络响应业务Bean 做数据补充
 *
 * @param netRequestBean 请求Bean
 * @param netRespondBean 响应Bean
 */
- (void)netRespondBeanComplementWithNetRequestBean:(in id)netRequestBean netRespondBean:(in id)netRespondBean;


/**
 * 考虑到后台不是同时都支持GET和POST请求, 而做的设计
 * @return 请求类型
 */
- (NSString *)httpMethod:(in id)netRequestBean;

@end
