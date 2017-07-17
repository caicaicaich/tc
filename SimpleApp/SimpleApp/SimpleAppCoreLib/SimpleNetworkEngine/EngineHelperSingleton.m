//
//  EngineHelperSingleton.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "EngineHelperSingleton.h"
#import "SpliceFullUrlByDomainBeanSpecialPath.h"
#import "RNAssert.h"
#import "NetResponseRawEntityDataUnpack.h"
#import "NetResponseDataToNSDictionary.h"
#import "ServerResponseDataValidityTest.h"
#import "GetServerResponseDataValidityData.h"
#import "CustomHttpHeaders.h"

#import "NetRequestPublicParams.h"//? ProjectModule
#import "CacheManageSingleton.h"//? DomainBeanModel

static NSString *const TAG = @"EngineHelperSingleton";

@interface EngineHelperSingleton ()

@property (nonatomic, strong) id<INetResponseRawEntityDataUnpack> netResponseRawEntityDataUnpackFunction;
@property (nonatomic, strong) id<INetResponseDataToNSDictionary> netResponseDataToNSDictionaryFunction;
@property (nonatomic, strong) id<IServerResponseDataValidityTest> serverResponseDataValidityTestFunction;
@property (nonatomic, strong) id<IGetServerResponseDataValidityData> serverResponseDataValidityDataFunction;
@property (nonatomic, strong) id<INetRequestPublicParams> netRequestPublicParamsFunction;
@property (nonatomic, strong) id<ICustomHttpHeaders> customHttpHeadersFunction;
@property (nonatomic, strong) id<ISpliceFullUrlByDomainBeanSpecialPath> spliceFullUrlByDomainBeanSpecialPathFunction;
@end

@implementation EngineHelperSingleton

#pragma mark -
#pragma mark 单例方法群

// 使用 Grand Central Dispatch (GCD) 来实现单例, 这样编写方便, 速度快, 而且线程安全.
- (id)init {
  // 禁止调用 -init 或 +new
  RNAssert(NO, @"Cannot create instance of Singleton");
  
  // 在这里, 你可以返回nil 或 [self initSingleton], 由你来决定是返回 nil还是返回 [self initSingleton]
  return nil;
}

// 真正的(私有)init方法
- (id)initSingleton {
  
  if ((self = [super init])) {
    
    _netResponseRawEntityDataUnpackFunction = [[NetResponseRawEntityDataUnpack alloc] init];
    _netResponseDataToNSDictionaryFunction = [[NetResponseDataToNSDictionary alloc] init];
    _serverResponseDataValidityTestFunction = [[ServerResponseDataValidityTest alloc] init];
    _serverResponseDataValidityDataFunction = [[GetServerResponseDataValidityData alloc] init];
    _netRequestPublicParamsFunction = [[NetRequestPublicParams alloc] init];
    _customHttpHeadersFunction = [[CustomHttpHeaders alloc] init];
    _spliceFullUrlByDomainBeanSpecialPathFunction = [[SpliceFullUrlByDomainBeanSpecialPath alloc] init];
  }
  
  return self;
}

+ (EngineHelperSingleton *)sharedInstance {
  static EngineHelperSingleton *singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
  return singletonInstance;
}

#pragma mark -
#pragma mark - 对外的接口

- (id<IPostDataPackage>) postDataPackageFunction {
  return nil;
}

- (id<INetResponseRawEntityDataUnpack>) netResponseRawEntityDataUnpackFunction {
  return _netResponseRawEntityDataUnpackFunction;
}

- (id<INetResponseDataToNSDictionary>) netResponseDataToNSDictionaryFunction {
  return _netResponseDataToNSDictionaryFunction;
}

- (id<IServerResponseDataValidityTest>) serverResponseDataValidityTestFunction {
  return _serverResponseDataValidityTestFunction;
}

- (id<IGetServerResponseDataValidityData>) getServerResponseDataValidityDataFunction {
  return _serverResponseDataValidityDataFunction;
}

- (id<INetRequestPublicParams>) netRequestPublicParamsFunction {
  return _netRequestPublicParamsFunction;
}

- (id<ICustomHttpHeaders>) customHttpHeadersFunction {
  return _customHttpHeadersFunction;
}

// 网络接口的映射 (requestBean ---> domainBeanHelper)
- (IDomainBeanHelper *) domainBeanHelperByNetRequestBeanClassName:(NSString *)netResquestBeanClassName {
  @try {
    NSRange range = [netResquestBeanClassName rangeOfString:@"NetRequestBean"];
    NSString *packageName = [netResquestBeanClassName substringWithRange:NSMakeRange(0, range.location)];
    Class domainBeanHelper = NSClassFromString([NSString stringWithFormat:@"%@%@", packageName, @"DomainBeanHelper"]);
    return [[domainBeanHelper alloc] init];
  } @catch (NSException *exception) {
    return nil;
  }
}


- (id<ISpliceFullUrlByDomainBeanSpecialPath>) spliceFullUrlByDomainBeanSpecialPathFunction {
  return _spliceFullUrlByDomainBeanSpecialPathFunction;
}

// 缓存层模块入口
- (id<ICacheNetRespondBean>)getCacheNetRespondBeanModelFunction {
  return [CacheManageSingleton sharedInstance];
}

// 获取 请求网络接口时, 所使用的 http ContentType ,有些项目需要使用类似 "application/json;charset:utf-8" 的方式
- (RequestDomainBeanContentTypeEnum)getRequestDomainBeanContentType {
  return RequestDomainBeanContentTypeEnum_Normal;
}
@end
