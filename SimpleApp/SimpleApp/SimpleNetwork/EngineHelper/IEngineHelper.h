//
//  IEngineHelper.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDomainBeanHelper.h"

#import "IPostDataPackage.h"
#import "INetResponseRawEntityDataUnpack.h"
#import "IServerResponseDataValidityTest.h"
#import "IGetServerResponseDataValidityData.h"
#import "ISpliceFullUrlByDomainBeanSpecialPath.h"
#import "INetRequestPublicParams.h"
#import "ICustomHttpHeaders.h"
#import "INetResponseDataToNSDictionary.h"
#import "ICacheNetRespondBean.h"
#import "RequestDomainBeanContentTypeEnum.h"

/**
 *  EngineHelper 是项目级别的配置, 不同的App, 只需要在这里进行配置, 就可以复用引擎框架
 *  下面定义的, 都是不同App之间会发生变化的抽象方法
 */
@protocol IEngineHelper <NSObject>

// 打包post数据(可在这里进行数据的加密工作)
- (id<IPostDataPackage>) postDataPackageFunction;

// 将网络返回的原生数据, 解压成可识别的UTF8字符串(可在这里进行数据的解密工作)
- (id<INetResponseRawEntityDataUnpack>) netResponseRawEntityDataUnpackFunction;

// 服务器返回的数据有效性检测(这是业务层面有效性检测, 比如说, 调用后台一个搜索接口, 传入关键字,
// 在后台没有搜索到结果的情况下, 在业务层面, 我们认为是失败的)
// 在这里主要是检查跟服务器约定好的 errorCode 和 errorMessage
- (id<IServerResponseDataValidityTest>) serverResponseDataValidityTestFunction;

// 从服务器返回的数据中, 获取 data 部分(真正的有效数据)
- (id<IGetServerResponseDataValidityData>) getServerResponseDataValidityDataFunction;

// 拼接一个网络接口的完整请求URL
- (id<ISpliceFullUrlByDomainBeanSpecialPath>) spliceFullUrlByDomainBeanSpecialPathFunction;

// 业务Bean请求时,需要传递到服务器的公共参数
- (id<INetRequestPublicParams>) netRequestPublicParamsFunction;

// 自定义的http headers
- (id<ICustomHttpHeaders>) customHttpHeadersFunction;

// 将已经解压的网络响应数据(UTF8String格式)转成 NSDictionary 数据
- (id<INetResponseDataToNSDictionary>) netResponseDataToNSDictionaryFunction;

// 网络接口的映射
// requestBean ---> domainBeanHelper
- (IDomainBeanHelper *) domainBeanHelperByNetRequestBeanClassName:(NSString *)netResquestBeanClassName;

// 缓存层模块入口
- (id<ICacheNetRespondBean>)getCacheNetRespondBeanModelFunction;

// 获取 请求网络接口时, 所使用的 http ContentType ,有些项目需要使用类似 "application/json;charset:utf-8" 的方式
- (RequestDomainBeanContentTypeEnum)getRequestDomainBeanContentType;
@end
