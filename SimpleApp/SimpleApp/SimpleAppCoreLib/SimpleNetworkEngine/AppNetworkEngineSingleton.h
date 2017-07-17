//
//  AppNetworkEngineSingleton.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/14.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleNetworkEngine.h"

@interface AppNetworkEngineSingleton : NSObject

#pragma mark - request domainbean

// --------------------              用于单纯的网络请求, 而不需要监听其响应的接口, 用于接口刷新            -------------------------

/// 普通形式(优先级默认是 NetRequestOperationPriorityNormal)
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean;

// --------------------              不带优先级的接口                                                -------------------------

/// 普通形式(优先级默认是 NetRequestOperationPriorityNormal)
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock;

/// 配合UI显示的形式(优先级默认是 NetRequestOperationPriorityNormal)
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                                     beginBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadBeginBlock)beginBlock
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock
                                                       endBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadEndBlock)endBlock;

// --------------------               带优先级的接口                                                -------------------------

/// 普通形式
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                    netRequestOperationPriority:(in NetRequestOperationPriority)netRequestOperationPriority
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock;

/// 配合UI显示的形式
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                    netRequestOperationPriority:(in NetRequestOperationPriority)netRequestOperationPriority
                                                     beginBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadBeginBlock)beginBlock
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock
                                                       endBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadEndBlock)endBlock;



#pragma mark - request download file
- (id<INetRequestHandle>)requestDownloadFileWithUrl:(in NSString *)urlString
                               downloadFileSavePath:(in NSString *)downloadFileSavePath
                                      progressBlock:(in FileAsyncHttpResponseListenerInUIThreadProgressBlock)progressBlock
                                     successedBlock:(in FileAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                        failedBlock:(in FileAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock;

- (id<INetRequestHandle>)requestDownloadFileWithUrl:(in NSString *)urlString
                               downloadFileSavePath:(in NSString *)downloadFileSavePath
                                         httpMethod:(in NSString *)httpMethod
                        netRequestOperationPriority:(in NetRequestOperationPriority)netRequestOperationPriority
                                             params:(in NSDictionary *)params
                                 isNeedContinuingly:(in BOOL)isNeedContinuingly
                                      progressBlock:(in FileAsyncHttpResponseListenerInUIThreadProgressBlock)progressBlock
                                     successedBlock:(in FileAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                        failedBlock:(in FileAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock;

#pragma mark - request upload file
- (id<INetRequestHandle>)requestFileUploadWithUrl:(in NSString *)urlString
                                           params:(in NSDictionary *)params
                                    uploadFileKey:(in NSString *)uploadFileKey
                                   uploadFilePath:(in NSString *)uploadFilePath
                                    progressBlock:(in FileAsyncHttpResponseListenerInUIThreadProgressBlock)progressBlock
                                   successedBlock:(in FileAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                      failedBlock:(in FileAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock;



#pragma mark -
+ (instancetype)sharedInstance;

@end
