//
//  HttpEngineOfAFNetworking.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "HttpEngineOfAFNetworking.h"

#import "AFURLRequestSerialization.h"
#import "AFURLResponseSerialization.h"
#import "UploadFileMIMETypeTools.h"
#import "IEngineHelper.h"
#import "AFNetworking.h"
#import "PRPDebug.h"
#import "HttpRequestHandleOfAFNetworkingOfNSURLSessionTask.h"
#import "NSDictionary+RequestEncoding.h"

static NSString *const TAG = @"HttpEngineOfAFNetworking";

@interface HttpEngineOfAFNetworking()

@property (nonatomic, strong) AFURLSessionManager *sessionManager;

@end

@implementation HttpEngineOfAFNetworking


- (instancetype)init {
  
  if ((self = [super init])) {
    // 初始化代码
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
  }
  
  return self;
}


#pragma mark - 私有方法

/**
 *  为了 AFURLSessionManager 准备的KVO
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  
  NSProgress *progress = nil;
  if ([object isKindOfClass:[NSProgress class]]) {
    progress = (NSProgress *)object;
  }
  if (progress) {
    dispatch_async(dispatch_get_main_queue(), ^{
      PRPLog(@"已经完成：%f", progress.fractionCompleted);
      if (progress.fractionCompleted == 1.0000) {
        //[self showLoadingMessage:@"正在处理"];
      } else {
        //[self showProgress:(float)progress.fractionCompleted Message:@"正在发布"];
      }
    });
  }
}

#pragma mark -
#pragma mark 实现 INetLayerInterface 协议
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
                                            failedBlock:(in NetLayerAsyncNetResponseListenerInUIThreadFailedBlock)failedBlock {
  
  
  PRPLog(@"\n\n\n\n\n\n\nhttp 访问相关信息\n-----------------> HTTP_URL = %@\n\n-----------------> HTTP_METHOD = %@\n\n-----------------> HTTP_HEADERS = %@\n\n-----------------> HTTP_PARAMS = %@\n\n-----------------> FULL_REQUEST_URL = \n%@\n\n\n\n\n\n\n", urlString, httpMethod, httpHeaders, httpParams, [NSString stringWithFormat:@"%@%@", urlString, [httpParams urlEncodedKeyValueString]]);
  
  
  if (httpContentType == RequestDomainBeanContentTypeEnum_Normal) {
    return [self requestDomainBeanAndContentTypeUseNormalWithUrlString:urlString httpMethod:httpMethod httpHeaders:httpHeaders httpParams:httpParams customPostDataPackageHandler:customPostDataPackageHandler operationPriority:operationPriority successedBlock:successedBlock failedBlock:failedBlock];
  } else {
    return [self requestDomainBeanAndContentTypeUseJsonWithUrlString:urlString httpMethod:httpMethod httpHeaders:httpHeaders httpParams:httpParams customPostDataPackageHandler:customPostDataPackageHandler operationPriority:operationPriority successedBlock:successedBlock failedBlock:failedBlock];
  }
}

- (id<INetRequestHandle>)requestDomainBeanAndContentTypeUseNormalWithUrlString:(in NSString *)urlString
                                                                    httpMethod:(in NSString *)httpMethod
                                                                   httpHeaders:(in NSDictionary *)httpHeaders
                                                                    httpParams:(in NSDictionary *)httpParams
                                                  customPostDataPackageHandler:(in id<IPostDataPackage>)customPostDataPackageHandler
                                                             operationPriority:(in NSOperationQueuePriority)operationPriority
                                                                successedBlock:(in NetLayerAsyncNetResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                                   failedBlock:(in NetLayerAsyncNetResponseListenerInUIThreadFailedBlock)failedBlock {
  
  
  
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  //设置超时时间
  manager.requestSerializer.timeoutInterval = 100.0f;
  //
  manager.securityPolicy.allowInvalidCertificates = YES;
  // 设置异步返回的数据类型为 二进制
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  //
  [httpHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
  }];
  
  PRPLog(@"\n\n\n-----------------> AFNetworking_HTTP_HEADER = \n%@\n\n\n", manager.requestSerializer.HTTPRequestHeaders);
  
  
  NSURLSessionTask *sessionTask = nil;
  HttpRequestHandleOfAFNetworkingOfNSURLSessionTask *netRequestHandle = [[HttpRequestHandleOfAFNetworkingOfNSURLSessionTask alloc] init];
  
  if ([@"GET" isEqualToString:httpMethod]) {
    
    
    sessionTask = [manager GET:urlString
                    parameters:httpParams
                      progress:^(NSProgress * _Nonnull downloadProgress) {
                        
                      }
                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         successedBlock(netRequestHandle, responseObject);
                       }
                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         failedBlock((id<INetRequestIsCancelled>)task, error);
                       }];
    
  } else if ([@"POST" isEqualToString:httpMethod]) {
    
    sessionTask = [manager POST:urlString
                     parameters:httpParams
                       progress:^(NSProgress * _Nonnull uploadProgress) {
                         
                       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         successedBlock(netRequestHandle, responseObject);
                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         failedBlock(netRequestHandle, error);
                       }];
    
  } else if ([@"PUT" isEqualToString:httpMethod]) {
    
    sessionTask = [manager PUT:urlString
                    parameters:httpParams
                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         successedBlock(netRequestHandle, responseObject);
                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         failedBlock(netRequestHandle, error);
                       }];
    
  } else {
    PRPLog(@"上层传递了, 网络层不能识别的 HttpMethod.");
    return nil;
  }
  
  [netRequestHandle setSessionTask:sessionTask];
  return netRequestHandle;
}

- (id<INetRequestHandle>)requestDomainBeanAndContentTypeUseJsonWithUrlString:(in NSString *)urlString
                                                                  httpMethod:(in NSString *)httpMethod
                                                                 httpHeaders:(in NSDictionary *)httpHeaders
                                                                  httpParams:(in NSDictionary *)httpParams
                                                customPostDataPackageHandler:(in id<IPostDataPackage>)customPostDataPackageHandler
                                                           operationPriority:(in NSOperationQueuePriority)operationPriority
                                                              successedBlock:(in NetLayerAsyncNetResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                                 failedBlock:(in NetLayerAsyncNetResponseListenerInUIThreadFailedBlock)failedBlock {
  
  
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  //设置超时时间
  manager.requestSerializer.timeoutInterval = 100.0f;
  //
  manager.securityPolicy.allowInvalidCertificates = YES;
  // 申明请求的数据是json类型
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  // 设置异步返回的数据类型为 二进制
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  //
  [httpHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
  }];
  
  NSURLSessionTask *sessionTask = nil;
  HttpRequestHandleOfAFNetworkingOfNSURLSessionTask *netRequestHandle = [[HttpRequestHandleOfAFNetworkingOfNSURLSessionTask alloc] init];
  
  PRPLog(@"\n\n\n-----------------> AFNetworking_HTTP_HEADER = \n%@\n\n\n", manager.requestSerializer.HTTPRequestHeaders);
  sessionTask = [manager POST:urlString
                   parameters:httpParams
                     progress:^(NSProgress * _Nonnull uploadProgress) {
                       
                     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                       successedBlock(netRequestHandle, responseObject);
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                       failedBlock(netRequestHandle, error);
                     }];
  
  [netRequestHandle setSessionTask:sessionTask];
  return netRequestHandle;
  
}

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
                                 failedBlock:(in NetLayerAsyncNetResponseListenerInUIThreadFailedBlock)failedBlock {
  
  
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
  AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
  
  __block BOOL managerDownloadFinishedBlockExecuted = NO;
  __block BOOL completionBlockExecuted = NO;
  
  
  NSURL *requestURL = [NSURL URLWithString:urlString];
  
  [manager setDownloadTaskDidFinishDownloadingBlock:^NSURL *(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, NSURL *location) {
    managerDownloadFinishedBlockExecuted = YES;
    //NSURL *dirURL  = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
    //return [dirURL URLByAppendingPathComponent:@"AFNetworking-master.zip"];
    return [NSURL URLWithString:downLoadFilePath];
    
  }];
  
  [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
    
    PRPLog(@"%.2f / %.2f",(float)totalBytesWritten/1024.0/1024.0,(float)totalBytesExpectedToWrite/1024.0/1024.0);
    
    if (progressBlock != NULL) {
      progressBlock((float)totalBytesWritten/(float)totalBytesExpectedToWrite);
    }
  }];
  
  __block NSURLSessionDownloadTask *downloadTask;
  HttpRequestHandleOfAFNetworkingOfNSURLSessionTask *netRequestHandle = [[HttpRequestHandleOfAFNetworkingOfNSURLSessionTask alloc] init];
  
  downloadTask = [manager
                  downloadTaskWithRequest:[NSURLRequest requestWithURL:requestURL]
                  progress:nil
                  destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                    //下载地址
                    PRPLog(@"默认下载地址:%@",targetPath);
                    
                    //设置下载路径，通过沙盒获取缓存地址，最后返回NSURL对象
                    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
                    return [NSURL fileURLWithPath:filePath];
                    
                  }
                  completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                    
                    completionBlockExecuted = YES;
                    if (error != nil && failedBlock != NULL) {
                      failedBlock(netRequestHandle,error);
                    }
                    
                    if (error == nil && successedBlock != NULL) {
                      NSData *data = [NSData dataWithContentsOfURL:filePath];
                      successedBlock(netRequestHandle, data);
                    }
                  }];
  [downloadTask resume];
  
  [netRequestHandle setSessionTask:downloadTask];
  return netRequestHandle;
  
  
}

/**
 发起一个文件上传的http请求
 
 @param urlString           完整的URL
 @param params              数据字典(需要传递到服务器的参数列表)
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
                               failedBlock:(in NetLayerAsyncNetResponseListenerInUIThreadFailedBlock)failedBlock{
  
  //1。创建管理者对象
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  // 设置异步返回的数据类型为 二进制
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  
  NSURLSessionDataTask *sessionDataTask = nil;
  HttpRequestHandleOfAFNetworkingOfNSURLSessionTask *netRequestHandle = [[HttpRequestHandleOfAFNetworkingOfNSURLSessionTask alloc] init];
  
  sessionDataTask = [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    [formData appendPartWithFileURL:[NSURL fileURLWithPath:uploadFilePath] name:uploadFileKey fileName:@"uploadfile" mimeType:[UploadFileMIMETypeTools MIMETypeFromUploadFile:uploadFilePath] error:nil];
  } progress:^(NSProgress * _Nonnull uploadProgress) {
    if (progressBlock != NULL) {
      progressBlock(uploadProgress.fractionCompleted);
    }
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    if (successedBlock != NULL) {
      successedBlock(netRequestHandle, responseObject);
    }
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    if (failedBlock != NULL) {
      failedBlock(netRequestHandle, error);
    }
  }];
  
  [netRequestHandle setSessionTask:sessionDataTask];
  return netRequestHandle;
  
  
  
  //  AFHTTPRequestOperation *operation = [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
  //    [formData appendPartWithFileURL:[NSURL fileURLWithPath:uploadFilePath] name:uploadFileKey fileName:@"uploadfile" mimeType:[UploadFileMIMETypeTools MIMETypeFromUploadFile:uploadFilePath] error:nil];
  //  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
  //    if (successedBlock != NULL) {
  //      successedBlock((id<INetRequestIsCancelled>)operation, operation.responseData);
  //    }
  //  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
  //    if (failedBlock != NULL) {
  //      failedBlock((id<INetRequestIsCancelled>)operation, error);
  //    }
  //  }];
  //  [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
  //    if (progressBlock != NULL) {
  //      progressBlock((double)totalBytesWritten/totalBytesExpectedToWrite * 100);
  //    }
  //    //PRPLog(@"\n\n\nbytesWritten = %zi\ntotalBytesWritten = %d\ntotalBytesExpectedToWrite = %d\n\n", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
  //  }];
  //
  //  return [[HttpRequestHandleOfAFNetworkingOfAFHTTPRequestOperation alloc] initWithAFHTTPRequestOperation:operation];
}
@end
