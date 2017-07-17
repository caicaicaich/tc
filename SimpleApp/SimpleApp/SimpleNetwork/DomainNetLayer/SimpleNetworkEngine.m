//
//  SimpleNetworkEngine.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "SimpleNetworkEngine.h"
#import "HttpEngine.h"
#import "RNAssert.h"
#import "ErrorCodeEnum.h"
#import "PRPDebug.h"
#import "NSString+isEmpty.h"
#import "NetRequestHandleStub.h"
#import "IParseNetRequestDomainBeanToDataDictionary.h"
#import "DomainBeanStub.h"
#import "NetRequestHandleStub.h"
#import "NetRequestHandleNilObject.h"
#import "ErrorBean.h"

@interface SimpleNetworkEngine()
@property (nonatomic, strong) id<IEngineHelper> engineHelper;
@property (nonatomic, copy) NSString *mainUrl;
@property (nonatomic, strong) DomainBeanStub *domainBeanStub;
@property (nonatomic, strong) HttpEngine *httpEngine;
@end

@implementation SimpleNetworkEngine

static NSString *const TAG = @"AppNetworkEngineSingleton";

- (instancetype)initWithEngineHelper:(id<IEngineHelper>)engineHelper mainUrl:(NSString *)mainUrl domainBeanStub:(DomainBeanStub *)domainBeanStub {
  
  if ((self = [super init])) {
    _engineHelper = engineHelper;
    _mainUrl = [mainUrl copy];
    _domainBeanStub = domainBeanStub;
    _httpEngine = [[HttpEngine alloc] init];
  }
  
  return self;
}

#pragma mark -
#pragma mark Singleton Implementation

// 使用 Grand Central Dispatch (GCD) 来实现单例, 这样编写方便, 速度快, 而且线程安全.
- (id)init {
  // 禁止调用 -init 或 +new
  RNAssert(NO, @"Cannot create instance of Singleton");
  
  // 在这里, 你可以返回nil 或 [self initSingleton], 由你来决定是返回 nil还是返回 [self initSingleton]
  return nil;
}


#pragma mark -
#pragma mark 内部方法群
- (NSOperationQueuePriority)netLayerOperationPriorityTransform:(NetRequestOperationPriority)netRequestOperationPriority {
  switch (netRequestOperationPriority) {
    case NetRequestOperationPriorityVeryLow:
      return NSOperationQueuePriorityVeryLow;
      
    case NetRequestOperationPriorityLow:
      return NSOperationQueuePriorityLow;
      
    case NetRequestOperationPriorityNormal:
      return NSOperationQueuePriorityNormal;
      
    case NetRequestOperationPriorityHigh:
      return NSOperationQueuePriorityHigh;
      
    case NetRequestOperationPriorityVeryHigh:
      return NSOperationQueuePriorityVeryHigh;
  }
}

#pragma mark -
#pragma mark - request domainbean (全能方法)


/**
 发起一个网络接口的请求操作
 
 @param netRequestBean                  网络请求业务Bean(作用 : 1.标识想要请求的网络接口. 2.包装接口访问参数)
 @param netRequestOperationPriority     本次网络请求发起后, 在请求队列中的优先级别.
 * @param beginBlock                    开始
 * @param successedBlock                成功
 * @param failedBlock                   失败
 * @param endBlock                      结束
 @return 网络句柄
 */
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestBean
                                    netRequestOperationPriority:(in NetRequestOperationPriority)netRequestOperationPriority
                                                     beginBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadBeginBlock)beginBlock
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock
                                                       endBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadEndBlock)endBlock {
  
  // TODO:20150215, 我感觉应该保证完整的流程, 也就是说, 即使发起一个网络请求在参数检验阶段就失败了, 也应该给调用者完整的生命周期
  if (beginBlock != NULL) {
    beginBlock();
  }
  
  // 请求参数错误
  ErrorBean *requestParamsError = nil;
  
  do {
    
    // <------------------------------------------------------------------------------------------------------->
    
    // 入参检测
    if (netRequestBean == nil) {
      requestParamsError = [ErrorBean errorBeanWithErrorCode:ErrorCodeEnum_Client_IllegalArgument errorMessage:@"方法入参 netRequestBean 不能为空."];
      break;
    }
    
    // "网络请求业务Bean" 作为一个网络接口的唯一标识, 它的类名(字符串格式), 作为跟这个接口有关的DomainBeanHelper的 Key Value 关联.
    NSString *const netRequestDomainBeanClassString = NSStringFromClass([netRequestBean class]);
    
    PRPLog(@"\n\n\n\n\n\n\n\n\n-----------------> 请求接口 : %@\n\n\n", netRequestDomainBeanClassString);
    
    // domainBeanHelper 中包含了跟当前网络接口相关的一组助手方法(这里使用了 "抽象工厂" 设计模式)
    const IDomainBeanHelper *domainBeanHelper = [_engineHelper domainBeanHelperByNetRequestBeanClassName:netRequestDomainBeanClassString];
    if (domainBeanHelper == nil) {
      requestParamsError = [ErrorBean errorBeanWithErrorCode:ErrorCodeEnum_Client_ProgrammingError errorMessage:[NSString stringWithFormat:@"接口 [%@] 找不到与其对应的 domainBeanHelper, 客户端编程错误.", netRequestDomainBeanClassString]];
      break;
    }
    
    // 发往服务器的完整的 "数据字典", 包括 "公共参数" 和 "私有参数"
    NSMutableDictionary *const fullParams = [NSMutableDictionary dictionaryWithCapacity:50];
    // 公共参数
    requestParamsError = nil;
    NSDictionary *const publicParams = [_engineHelper.netRequestPublicParamsFunction publicParamsWithErrorOUT:&requestParamsError];
    if (requestParamsError != nil) {
      // 获取公共参数失败
      break;
    }
    [fullParams addEntriesFromDictionary:publicParams];
    PRPLog(@"\n\n\npublicParams = %@\n\n\n", publicParams);
    
    // url
    NSString *urlString = nil;
    NSDictionary *privateParams = nil;
    
    // 普通情况, 需要添加目标接口的私有参数列表, 另外url也是目标接口设定好的
    
    // 具体接口的参数
    // 注意 : 一定要保证先填充 "公共参数", 然后再填充 "具体接口的参数", 这是因为有时候具体接口的参数需要覆盖公共参数.
    if (domainBeanHelper.parseNetRequestDomainBeanToDataDictionaryFunction != nil) {
      requestParamsError = nil;
      privateParams = [domainBeanHelper.parseNetRequestDomainBeanToDataDictionaryFunction parseNetRequestDomainBeanToDataDictionary:netRequestBean error:&requestParamsError];
      if (requestParamsError != nil) {
        // 获取具体接口的私有参数失败
        break;
      }
      [fullParams addEntriesFromDictionary:privateParams];
      PRPLog(@"\n\n\nprivateParams = %@\n\n\n", privateParams);
    }
    
    // 获取当前业务网络接口, 对应的URL
    NSString *const specialPath = [domainBeanHelper specialUrlPathWithNetRequestBean:netRequestBean];
    urlString = [[_engineHelper spliceFullUrlByDomainBeanSpecialPathFunction] fullUrlByDomainBeanSpecialPath:specialPath];
    
    if ([NSString isEmpty:urlString]) {
      NSString *errorMessage = [NSString stringWithFormat:@"接口 [%@] 找不到与其对应的 url, 客户端编程错误.", netRequestDomainBeanClassString];
      requestParamsError = [ErrorBean errorBeanWithErrorCode:ErrorCodeEnum_Client_IllegalArgument errorMessage:errorMessage];
      break;
    }
    
    PRPLog(@"\n\n\nurlString   = %@\n\n\n", urlString);
    
    
    // <------------------------------------------------------------------------------------------------------->
    // 使用桩数据
    if (_domainBeanStub.isUseStub) {
      PRPLog(@"\n\n\n本次网络请求使用桩数据 -> %@\n\n\n", netRequestDomainBeanClassString);
      
      NetRequestHandleStub *netRequestHandleStub = [[NetRequestHandleStub alloc] init];
      [netRequestHandleStub setBusy:YES];
      
      double delayInSeconds = 2.0;
      dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
      
      dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if (!netRequestHandleStub.isCancelled) {
          
          [netRequestHandleStub setBusy:NO];
          
          id netRespondBean = [_domainBeanStub netRespondBeanStubByNetRequestBean:netRequestBean];
          
          if (netRespondBean != nil) {
            PRPLog(@"\n\n\n本次网络请求成功(返回的是桩数据-->%@)\n\n\n", NSStringFromClass([netRespondBean class]));
            
            // TODO : 20160227 增加 "网络响应业务Bean 数据补充" 环节
            [domainBeanHelper netRespondBeanComplementWithNetRequestBean:netRequestBean netRespondBean:netRespondBean];
            
            // TODO:20151231增加缓存模块
            [_engineHelper.getCacheNetRespondBeanModelFunction cacheNetRespondBean:netRespondBean withNetRequestBean:netRequestBean];
            
            if (successedBlock != NULL) {
              successedBlock(netRespondBean);
            }
            
          } else {
            NSString *errorMessage = [NSString stringWithFormat:@"调用桩数据失败(%@).", netRequestDomainBeanClassString];
            
            if (failedBlock != NULL) {
              failedBlock([ErrorBean errorBeanWithErrorCode:ErrorCodeEnum_Client_ProgrammingError errorMessage:errorMessage]);
            }
            
          }
          
          // 通知控制层, 本次网络请求彻底完成
          if (endBlock != NULL) {
            endBlock();
          }
        }
        
      });
      return netRequestHandleStub;
    }
    // <------------------------------------------------------------------------------------------------------->
    
    
    
    
    // <------------------------------------------------------------------------------------------------------->
    /// 调用网络层接口, 开始HTTP请求
    id<INetRequestHandle> requestHandle = [_httpEngine requestDomainBeanWithUrlString:urlString httpMethod:[domainBeanHelper httpMethod:netRequestBean] httpContentType:_engineHelper.getRequestDomainBeanContentType httpHeaders:[_engineHelper.customHttpHeadersFunction customHttpHeaders] httpParams:fullParams customPostDataPackageHandler:_engineHelper.postDataPackageFunction operationPriority:[self netLayerOperationPriorityTransform:netRequestOperationPriority] successedBlock:^(id<INetRequestIsCancelled> netRequestIsCancelled, NSData *responseData) {
      
      // 网络层数据正常返回, 进入业务层的解析操作.
      
      // 网络响应业务Bean
      id netRespondBean = nil;
      // 服务器端响应数据错误
      ErrorBean *serverRespondDataError = nil;
      // 已经解包的数据字符串(UTF-8)
      NSString *netUnpackedDataOfUTF8String = nil;
      
      do {
        
        // ------------------------------------- >>>
        if ([netRequestIsCancelled isCancelled]) {
          // 本次网络请求被取消了
          break;
        }
        // ------------------------------------- >>>
        
        NSData *const netRawEntityData = responseData;
        if (![netRawEntityData isKindOfClass:[NSData class]] || netRawEntityData.length <= 0) {
          serverRespondDataError = [ErrorBean errorBeanWithErrorCode:ErrorCodeEnum_Server_NoResponseData errorMessage:@"服务器没有返回任何数据给客户端."];
          break;
        }
        PRPLog(@"\n\n\n-----------------> 接口 [%@] : 返回的 \"实体生数据\" 不为空(netRawEntityData.length=%d)\n\n\n", netRequestDomainBeanClassString, netRawEntityData.length);
        
        // 将网络层返回的 "生数据" 解包成 "可识别数据字符串(一般是utf-8)".
        // 这里要考虑网络传回的原生数据有加密的情况, 比如MD5加密的数据, 可以在这里先解密成可识别的字符串
        // 已经解密的可识别字符串(UTF8, 可能是JSON/XML/其他数据交换协议)
        netUnpackedDataOfUTF8String = [[_engineHelper netResponseRawEntityDataUnpackFunction] unpackNetResponseRawEntityDataToUTF8String:netRawEntityData];
        if ([NSString isEmpty:netUnpackedDataOfUTF8String]) {
          serverRespondDataError = [ErrorBean errorBeanWithErrorCode:ErrorCodeEnum_Server_UnpackedResponseDataFailed errorMessage:@"解包服务器端返回的 生数据(可能加密) 失败."];
          break;
        }
        //PRPLog(@"\n\n\n-----------------> 接口 [%@] : 解包服务器返回的 \"生数据\" 成功, 详细数据 =     \n\n%@\n\n\n", netRequestDomainBeanClassString, netUnpackedDataOfUTF8String);
        
        // 将 "数据交换协议字符串JSON/XML" 解析成 "cocoa 字典 NSDictionary"
        // 警告 : 这里假定服务器和客户端只使用一种 "数据交换协议" 进行通信.
        NSDictionary *const responseDataDictionary = [[_engineHelper netResponseDataToNSDictionaryFunction] netResponseDataToNSDictionary:netUnpackedDataOfUTF8String];
        if (![responseDataDictionary isKindOfClass:[NSDictionary class]]) {
          serverRespondDataError = [ErrorBean errorBeanWithErrorCode:ErrorCodeEnum_Server_ResponseDataToDictionaryFailed errorMessage:@"服务器返回的数据, 不能被成功解析成 Cocoa NSDictionary(服务器和客户端约定数据交换协议可能有变化)."];
          break;
        }
        //PRPLog(@"\n\n\n-----------------> 接口 [%@] : 将服务器返回的数据, 解析成 Cocoa NSDictionary 成功, 详细数据 =     \n\n%@\n\n\n", netRequestDomainBeanClassString, responseDataDictionary);
        
        // 检查服务器返回的数据是否在逻辑上有效(所谓逻辑上有效, 就是看服务器是否返回和客户端约定好的错误码), 如果无效, 要获取服务器返回的错误码和错误描述信息
        // (比如说某次网络请求成功了(http级别的成功 http code是200), 但是服务器那边没有有效的数据给客户端, 所以服务器会返回错误码和描述信息告知客户端访问结果)
        serverRespondDataError = nil;
        if (![[_engineHelper serverResponseDataValidityTestFunction] isServerResponseDataValid:responseDataDictionary errorOUT:&serverRespondDataError]) {
          PRPLog(@"\n\n\n-----------------> 接口 [%@] : 服务器端告知客户端, 本次网络业务访问未获取到有效数据(具体情况--> %@\n\n\n", netRequestDomainBeanClassString, serverRespondDataError);
          break;
        }
        PRPLog(@"\n\n\n-----------------> 接口 [%@] : 经过检验, 服务器返回的数据逻辑上有效\n\n", netRequestDomainBeanClassString);
        
        // 得到真正的有效数据
        id validityData = [[_engineHelper getServerResponseDataValidityDataFunction] serverResponseDataValidityData:responseDataDictionary];
        
        // 将 "数据字典" 直接通过 "KVC" 的方式转成 "网络响应业务Bean"
        @try {
          netRespondBean = [[[domainBeanHelper netRespondBeanClass] alloc] initWithDictionary:validityData];
        } @catch (NSException *exception) {
          // 如果value的类型和bean中定义的不匹配时, 会抛出异常
          NSString *errorMessage = [NSString stringWithFormat:@"将 NSDictionary 转换成 NetRespondBean 失败, 原因 : 异常名称 = %@ , 异常理由 = %@", exception.name, exception.reason];
          serverRespondDataError = [ErrorBean errorBeanWithErrorCode:ErrorCodeEnum_Server_ParseDictionaryFailedToNetRespondBeanFailed errorMessage:errorMessage];
          break;
        }
        PRPLog(@"\n\n\n-----------------> 接口 [%@] : 将 \"数据字典\" 直接通过 \"KVC\" 的方式转成 \"网络响应业务Bean\" 成功.\n\n", netRequestDomainBeanClassString);
        
        // 检查 netRespondBean 有效性, 在这里要检查服务器返回的数据中, 是否丢失了核心字段.
        serverRespondDataError = nil;
        if (![domainBeanHelper isNetRespondBeanValidity:netRespondBean errorOUT:&serverRespondDataError]) {
          break;
        }
        PRPLog(@"\n\n\n-----------------> 接口 [%@] : 经过检验, 服务器返回的数据完整, 没有丢失核心字段.\n\n\n", netRequestDomainBeanClassString);
        
        // TODO : 20160227 增加 "网络响应业务Bean 数据补充" 环节
        [domainBeanHelper netRespondBeanComplementWithNetRequestBean:netRequestBean netRespondBean:netRespondBean];
        
        PRPLog(@"\n\n\n-----------------> 接口 [%@] : 完成数据补充之后的 netRespondBean %@ 有效.\n打印详情:\n%@\n\n\n", netRequestDomainBeanClassString, NSStringFromClass([netRespondBean class]), [netRespondBean description]);
        
        // TODO:20151231增加缓存模块
        [_engineHelper.getCacheNetRespondBeanModelFunction cacheNetRespondBean:netRespondBean withNetRequestBean:netRequestBean];
        
        
        // ----------------------------------------------------------------------------
        //
        PRPLog(@"\n\n\n-----------------> 接口 [%@] : 本次网络业务请求, 圆满成功, 哦也!!!\n\n\n\n\n", netRequestDomainBeanClassString);
      } while (NO);
      
      // ------------------------------------- >>>
      // 通知控制层, 本次网络请求成功
      if (![netRequestIsCancelled isCancelled]) {
        
        // ------------------------------------- >>>
        // 通知控制层, 本次网络请求结果
        if (serverRespondDataError == nil) {// 业务层解析成功
          if (successedBlock != NULL) {
            successedBlock(netRespondBean);
          }
        } else {// 业务层解析失败
          if (failedBlock != NULL) {
            failedBlock(serverRespondDataError);
          }
          
        }
        // ------------------------------------- >>>
        
        // ------------------------------------- >>>
        // 通知控制层, 本次网络请求彻底完成
        if (endBlock != NULL) {
          endBlock();
        }
        // ------------------------------------- >>>
        
      } else {
        PRPLog(@"\n\n\n-----------------> 接口 [%@] : 网络请求, 已经被取消.\n\n\n", netRequestDomainBeanClassString);
      }
      // ------------------------------------- >>>
      
      if (serverRespondDataError != nil) {
        // 统计内部错误
        
      }
      
    } failedBlock:^(id<INetRequestIsCancelled> netRequestIsCancelled, NSError *error) {
      // 网络层访问失败.
      PRPLog(@"\n\n\n-----------------> 接口 [%@] : 网络层访问失败 , 原因-->\n\n%@\n\n\n", netRequestDomainBeanClassString, error.localizedDescription);
      
      // ------------------------------------- >>>
      // 通知控制层, 本次网络请求失败
      if (![netRequestIsCancelled isCancelled]) {
        
        if (failedBlock != NULL) {
          failedBlock([ErrorBean errorBeanWithNSError:error]);
        }
        
        // ------------------------------------- >>>
        // 通知控制层, 本次网络请求彻底完成
        if (endBlock != NULL) {
          endBlock();
        }
        // ------------------------------------- >>>
      } else {
        
        // 网络请求已经被取消
        PRPLog(@"\n\n\n-----------------> 接口 [%@] : 网络请求, 已经被取消.\n\n\n", netRequestDomainBeanClassString);
      }
      // ------------------------------------- >>>
      
      // 统计内部错误
      
    }];
    // <------------------------------------------------------------------------------------------------------->
    
    if (requestHandle == nil) {
      NSString *errorMessage = [NSString stringWithFormat:@"接口 [%@] 调用网络层模块失败, 客户端编程错误.", netRequestDomainBeanClassString];
      requestParamsError = [ErrorBean errorBeanWithErrorCode:ErrorCodeEnum_Client_ProgrammingError errorMessage:errorMessage];
      break;
      break;
    }
    
    
    // 一切OK.
    return requestHandle;
    
  } while (NO);
  
  // 告知外部调用者, 错误原因
  if (failedBlock != NULL) {
    failedBlock(requestParamsError);
  }
  
  // 通知控制层, 本次网络请求彻底完成
  if (endBlock != NULL) {
    endBlock();
  }
  return [[NetRequestHandleNilObject alloc] init];
  
}

#pragma mark - request domainbean(重载方法群)

// --------------------              用于单纯的网络请求, 而不需要监听其响应的接口, 用于接口刷新            -------------------------

/// 普通形式(优先级默认是 NetRequestOperationPriorityNormal)
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean {
  return [self requestDomainBeanWithRequestDomainBean:netRequestDomainBean
                          netRequestOperationPriority:NetRequestOperationPriorityNormal
                                           beginBlock:NULL
                                       successedBlock:NULL
                                          failedBlock:NULL
                                             endBlock:NULL];
}


// --------------------              不带优先级的接口            -------------------------

/// 普通形式(不使用缓存/优先级默认是 NetRequestOperationPriorityNormal)
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock {
  return [self requestDomainBeanWithRequestDomainBean:netRequestDomainBean
                          netRequestOperationPriority:NetRequestOperationPriorityNormal
                                           beginBlock:NULL
                                       successedBlock:successedBlock
                                          failedBlock:failedBlock
                                             endBlock:NULL];
}

/// 配合UI显示的形式(不使用缓存/优先级默认是 NetRequestOperationPriorityNormal)
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                                     beginBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadBeginBlock)beginBlock
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock
                                                       endBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadEndBlock)endBlock {
  return [self requestDomainBeanWithRequestDomainBean:netRequestDomainBean
                          netRequestOperationPriority:NetRequestOperationPriorityNormal
                                           beginBlock:beginBlock
                                       successedBlock:successedBlock
                                          failedBlock:failedBlock
                                             endBlock:endBlock];
}



// --------------------               带优先级的接口            -------------------------

/// 普通形式
- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                    netRequestOperationPriority:(in NetRequestOperationPriority)netRequestOperationPriority
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock {
  return [self requestDomainBeanWithRequestDomainBean:netRequestDomainBean
                          netRequestOperationPriority:netRequestOperationPriority
                                           beginBlock:NULL
                                       successedBlock:successedBlock
                                          failedBlock:failedBlock
                                             endBlock:NULL];
}






#pragma mark -
#pragma mark - download file
- (id<INetRequestHandle>)requestDownloadFileWithUrl:(in NSString *)urlString
                               downloadFileSavePath:(in NSString *)downloadFileSavePath
                                      progressBlock:(in FileAsyncHttpResponseListenerInUIThreadProgressBlock)progressBlock
                                     successedBlock:(in FileAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                        failedBlock:(in FileAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock {
  
  return [self requestDownloadFileWithUrl:urlString
                     downloadFileSavePath:downloadFileSavePath
                               httpMethod:@"GET"
              netRequestOperationPriority:NSOperationQueuePriorityNormal
                                   params:nil
                       isNeedContinuingly:YES
                            progressBlock:progressBlock
                           successedBlock:successedBlock
                              failedBlock:failedBlock];
}

- (id<INetRequestHandle>)requestDownloadFileWithUrl:(in NSString *)urlString
                               downloadFileSavePath:(in NSString *)downloadFileSavePath
                                         httpMethod:(in NSString *)httpMethod
                        netRequestOperationPriority:(in NSOperationQueuePriority)operationQueuePriority
                                             params:(in NSDictionary *)params
                                 isNeedContinuingly:(in BOOL)isNeedContinuingly
                                      progressBlock:(in FileAsyncHttpResponseListenerInUIThreadProgressBlock)progressBlock
                                     successedBlock:(in FileAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                        failedBlock:(in FileAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock {
  
  
  return [_httpEngine requestDownloadFile:urlString
                        operationPriority:operationQueuePriority
                       isNeedContinuingly:isNeedContinuingly
                         downLoadFilePath:downloadFileSavePath
                            progressBlock:^(double progress) {
                              
                              // 向控制层回报下载进度
                              if (progressBlock != NULL) {
                                progressBlock(progress);
                              }
                            }
                           successedBlock:^(id<INetRequestIsCancelled> netRequestIsCancelled, NSData *responseData) {
                             if (successedBlock != NULL) {
                               successedBlock(downloadFileSavePath, nil);
                             }
                           }
                              failedBlock:^(id<INetRequestIsCancelled> netRequestIsCancelled, NSError *error) {
                                
                                // 文件下载失败
                                if (![netRequestIsCancelled isCancelled]) {
                                  if (failedBlock != NULL) {
                                    failedBlock([ErrorBean errorBeanWithNSError:error]);
                                  }
                                }
                                
                                // 统计内部错误
                                
                              }];
  
}

#pragma mark - request upload file
- (id<INetRequestHandle>)requestFileUploadWithUrl:(in NSString *)urlString
                                           params:(in NSDictionary *)params
                                    uploadFileKey:(in NSString *)uploadFileKey
                                   uploadFilePath:(in NSString *)uploadFilePath
                                    progressBlock:(in FileAsyncHttpResponseListenerInUIThreadProgressBlock)progressBlock
                                   successedBlock:(in FileAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                      failedBlock:(in FileAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock {
  
  NSMutableDictionary *fullParams = [NSMutableDictionary dictionary];
  NSDictionary *const publicParams = [_engineHelper.netRequestPublicParamsFunction publicParamsWithErrorOUT:NULL];
  [fullParams addEntriesFromDictionary:publicParams];
  [fullParams addEntriesFromDictionary:params];
  
  
  return [_httpEngine requestUploadFile:urlString
                                 params:fullParams
                          uploadFileKey:uploadFileKey
                         uploadFilePath:uploadFilePath
                          progressBlock:^(double progress) {
                            // 向控制层回报上传进度
                            if (progressBlock != NULL) {
                              progressBlock(progress);
                            }
                          }
                         successedBlock:^(id<INetRequestIsCancelled> netRequestIsCancelled, NSData *responseData) {
                           // 文件上传成功
                           if (![netRequestIsCancelled isCancelled]) {
                             if (successedBlock != NULL) {
                               successedBlock(uploadFilePath, [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                             }
                           }
                         }
                            failedBlock:^(id<INetRequestIsCancelled> netRequestIsCancelled, NSError *error) {
                              // 文件上传失败
                              if (![netRequestIsCancelled isCancelled]) {
                                if (failedBlock != NULL) {
                                  failedBlock([ErrorBean errorBeanWithNSError:error]);
                                }
                              }
                              // 统计内部错误
                            }];
  
}
@end
