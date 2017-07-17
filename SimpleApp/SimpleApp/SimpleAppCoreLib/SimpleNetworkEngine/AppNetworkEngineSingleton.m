//
//  AppNetworkEngineSingleton.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/14.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "AppNetworkEngineSingleton.h"
#import "RNAssert.h"
#import "UrlConstantForThisProject.h"
#import "EngineHelperSingleton.h"
#import "AppDomainBeanStub.h"

@interface AppNetworkEngineSingleton()
@property (nonatomic, strong) SimpleNetworkEngine *netwrokEngine;
@end

@implementation AppNetworkEngineSingleton

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
    self = [super init];
    if ((self = [super init])) {
        
        _netwrokEngine = [[SimpleNetworkEngine alloc] initWithEngineHelper:[EngineHelperSingleton sharedInstance] mainUrl:UrlConstant_MainUrl domainBeanStub:[[AppDomainBeanStub alloc] init]];
    }
    
    return self;
}

+ (instancetype)sharedInstance {
    static id singletonInstance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
    return singletonInstance;
}

#pragma mark -
#pragma mark - request domainbean

// --------------------              用于单纯的网络请求, 而不需要监听其响应的接口, 用于接口刷新            -------------------------

/// 普通形式(优先级默认是 NetRequestOperationPriorityNormal)
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean {
    return [_netwrokEngine requestDomainBeanWithRequestDomainBean:netRequestDomainBean];
}

// --------------------              不带优先级的接口                                                -------------------------

/// 普通形式(优先级默认是 NetRequestOperationPriorityNormal)
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock {
    return [_netwrokEngine requestDomainBeanWithRequestDomainBean:netRequestDomainBean
                                                   successedBlock:successedBlock
                                                      failedBlock:failedBlock];
}

/// 配合UI显示的形式(优先级默认是 NetRequestOperationPriorityNormal)
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                                     beginBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadBeginBlock)beginBlock
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock
                                                       endBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadEndBlock)endBlock {
    return [_netwrokEngine requestDomainBeanWithRequestDomainBean:netRequestDomainBean
                                                       beginBlock:beginBlock
                                                   successedBlock:successedBlock
                                                      failedBlock:failedBlock
                                                         endBlock:endBlock];
}

// --------------------               带优先级的接口                                                -------------------------

/// 普通形式
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                    netRequestOperationPriority:(in NetRequestOperationPriority)netRequestOperationPriority
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock {
    return [_netwrokEngine requestDomainBeanWithRequestDomainBean:netRequestDomainBean
                                      netRequestOperationPriority:netRequestOperationPriority
                                                   successedBlock:successedBlock
                                                      failedBlock:failedBlock];
}

/// 配合UI显示的形式
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                    netRequestOperationPriority:(in NetRequestOperationPriority)netRequestOperationPriority
                                                     beginBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadBeginBlock)beginBlock
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock
                                                       endBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadEndBlock)endBlock {
    return [_netwrokEngine requestDomainBeanWithRequestDomainBean:netRequestDomainBean
                                      netRequestOperationPriority:netRequestOperationPriority
                                                       beginBlock:beginBlock
                                                   successedBlock:successedBlock
                                                      failedBlock:failedBlock
                                                         endBlock:endBlock];
}



#pragma mark - request download file
- (id<INetRequestHandle>)requestDownloadFileWithUrl:(in NSString *)urlString
                               downloadFileSavePath:(in NSString *)downloadFileSavePath
                                      progressBlock:(in FileAsyncHttpResponseListenerInUIThreadProgressBlock)progressBlock
                                     successedBlock:(in FileAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                        failedBlock:(in FileAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock {
    return [_netwrokEngine requestDownloadFileWithUrl:urlString
                                 downloadFileSavePath:downloadFileSavePath
                                        progressBlock:progressBlock
                                       successedBlock:successedBlock
                                          failedBlock:failedBlock];
}

- (id<INetRequestHandle>)requestDownloadFileWithUrl:(in NSString *)urlString
                               downloadFileSavePath:(in NSString *)downloadFileSavePath
                                         httpMethod:(in NSString *)httpMethod
                        netRequestOperationPriority:(in NetRequestOperationPriority)netRequestOperationPriority
                                             params:(in NSDictionary *)params
                                 isNeedContinuingly:(in BOOL)isNeedContinuingly
                                      progressBlock:(in FileAsyncHttpResponseListenerInUIThreadProgressBlock)progressBlock
                                     successedBlock:(in FileAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                        failedBlock:(in FileAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock {
    return [_netwrokEngine requestDownloadFileWithUrl:urlString
                                 downloadFileSavePath:downloadFileSavePath
                                           httpMethod:httpMethod
                          netRequestOperationPriority:netRequestOperationPriority
                                               params:params
                                   isNeedContinuingly:isNeedContinuingly
                                        progressBlock:progressBlock
                                       successedBlock:successedBlock
                                          failedBlock:failedBlock];
}

#pragma mark - request upload file
- (id<INetRequestHandle>)requestFileUploadWithUrl:(in NSString *)urlString
                                           params:(in NSDictionary *)params
                                    uploadFileKey:(in NSString *)uploadFileKey
                                   uploadFilePath:(in NSString *)uploadFilePath
                                    progressBlock:(in FileAsyncHttpResponseListenerInUIThreadProgressBlock)progressBlock
                                   successedBlock:(in FileAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                      failedBlock:(in FileAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock {
    return [_netwrokEngine requestFileUploadWithUrl:urlString
                                             params:params
                                      uploadFileKey:uploadFileKey
                                     uploadFilePath:uploadFilePath
                                      progressBlock:progressBlock
                                     successedBlock:successedBlock
                                        failedBlock:failedBlock];
}




@end
