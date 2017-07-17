//
//  INetLayerInterface.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestDomainBeanContentTypeEnum.h"

@protocol INetRequestIsCancelled;
@protocol INetRequestHandle;
@protocol IPostDataPackage;

//异步网络响应监听快
// ---> 成功
typedef void (^NetLayerAsyncNetResponseListenerInUIThreadSuccessedBlock)(id<INetRequestIsCancelled> netRequestIsCanceled,NSData *responseData);
// ---> 失败
typedef void(^NetLayerAsyncNetResponseListenerInUIThreadFailedBlock)(id<INetRequestIsCancelled> netRequestIsCancelled, NSError *error);
// ---> 进度
typedef void(^NetLayerAsyncNetResponseListenerInUIThreadProgressBlock)(double progress);

/**
 *  "网络层" 提供给 "业务网络层" 的接口
 */
@protocol INetLayerInterface <NSObject>

/**
 *  发起一个业务Bean的http请求
 *
 *  @param urlString                          完整的URL
 *  @param httpMethod                         http method
 *  @param httpContentType                    http content type
 *  @param httpHeaders                        http headers
 *  @param httpParams                         数据字典(需要传递到服务器的参数列表)
 *  @param customPostDataPackageHandler       自定义的POST数据打包函数
 *  @param operationPriority                  请求优先级
 *  @param successedBlock                     网络请求成功时的异步块
 *  @param failedBlock                        网络请求失败时的异步块
 *
 *  @return 控制本次网络请求的操作句柄
 */
- (id<INetRequestHandle>)requestDomainBeanWithUrlString:(in NSString *)urlString
                                             httpMethod:(in NSString *)httpMethod
                                        httpContentType:(in RequestDomainBeanContentTypeEnum)httpContentType
                                            httpHeaders:(in NSDictionary *)httpHeaders
                                             httpParams:(in NSDictionary *)httpParams
                           customPostDataPackageHandler:(in id<IPostDataPackage>)customPostDataPackageHandler
                                      operationPriority:(in NSOperationQueuePriority)operationPriority
                                         successedBlock:(in NetLayerAsyncNetResponseListenerInUIThreadSuccessedBlock)successedBlock
                                            failedBlock:(in NetLayerAsyncNetResponseListenerInUIThreadFailedBlock)failedBlock;

/**
 *  发起一个文件下载的http请求
 *
 *  @param urlString                    完整的URL
 *  @param operationPriority            请求优先级
 *  @param isNeedContinuingly           是否需要断点续传
 *  @param downLoadFilePath             下载文件的保存路径
 *  @param progressBlock                下载进度回调块
 *  @param successedBlock               下载成功时的异步块
 *  @param failedBlock                  下载失败时的异步块
 *
 *  @return 控制本次网络请求的操作句柄
 */
- (id<INetRequestHandle>)requestDownloadFile:(in NSString *)urlString
                           operationPriority:(in NSOperationQueuePriority)operationPriority
                          isNeedContinuingly:(in BOOL)isNeedContinuingly
                            downLoadFilePath:(in NSString *)downLoadFilePath
                               progressBlock:(in NetLayerAsyncNetResponseListenerInUIThreadProgressBlock)progressBlock
                              successedBlock:(in NetLayerAsyncNetResponseListenerInUIThreadSuccessedBlock)successedBlock
                                 failedBlock:(in NetLayerAsyncNetResponseListenerInUIThreadFailedBlock)failedBlock;

/**
 发起一个文件上传的http请求
 
 @param urlString           完整的URL
 @param params              数据字典(需要传递到服务器的参数列表)
 @param uploadFileKey       uploadFileKey description
 @param uploadFilePath      要上传的文件的保存路径
 @param progressBlock       上传进度回调块
 @param successedBlock      上传成功时的异步块
 @param failedBlock         上传失败时的异步块
 @return                     控制本次网络请求的操作句柄
 */
- (id<INetRequestHandle>)requestUploadFile:(in NSString *)urlString
                                    params:(in NSDictionary *)params
                             uploadFileKey:(in NSString *)uploadFileKey
                            uploadFilePath:(in NSString *)uploadFilePath
                             progressBlock:(in NetLayerAsyncNetResponseListenerInUIThreadProgressBlock)progressBlock
                            successedBlock:(in NetLayerAsyncNetResponseListenerInUIThreadSuccessedBlock)successedBlock
                               failedBlock:(in NetLayerAsyncNetResponseListenerInUIThreadFailedBlock)failedBlock;



@end
