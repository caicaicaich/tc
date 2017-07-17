//
//  AppNetworkEngineSingleton+ForiDoool.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "AppNetworkEngineSingleton+ForiDoool.h"
#import "ErrorBean.h"
#import "ProjectHelper.h"
#import "UrlConstantForThisProject.h"
#import "EngineHelperSingleton.h"

@implementation AppNetworkEngineSingleton (ForiDoool)

- (id<INetRequestHandle>)requestFileUploadWithUrl:(in NSString *)urlString
                                    uploadFileKey:(in NSString *)uploadFileKey
                                   uploadFilePath:(in NSString *)uploadFilePath
                                    progressBlock:(in FileAsyncHttpResponseListenerInUIThreadProgressBlock)progressBlock
                                   successedBlock:(in UploadFileSuccessedBlock)successedBlock
                                      failedBlock:(in FileAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock {
  return [self requestFileUploadWithUrl:urlString params:nil uploadFileKey:uploadFileKey uploadFilePath:uploadFilePath progressBlock:^(double progress) {
    if (progressBlock != NULL) {
      progressBlock(progress);
    }
  } successedBlock:^(NSString *filePath, NSString *responseBody) {
    ErrorBean *errorOUT = nil;
    UploadFileInfoFromServer *uploadFileInfoFromServer = [ProjectHelper uploadFileIdFromServerResponseBody:responseBody errorOUT:&errorOUT];
    if (errorOUT == nil) {
      if (successedBlock) {
        successedBlock(uploadFileInfoFromServer);
      }
    } else {
      if (failedBlock != NULL) {
        failedBlock(errorOUT);
      }
    }
  } failedBlock:^(ErrorBean *error) {
    if (failedBlock != NULL) {
      failedBlock(error);
    }
  }];
  
}

- (id<INetRequestHandle>)requestImageUploadWithUploadFilePath:(in NSString *)uploadFilePath
                                                progressBlock:(in FileAsyncHttpResponseListenerInUIThreadProgressBlock)progressBlock
                                               successedBlock:(in UploadFileSuccessedBlock)successedBlock
                                                  failedBlock:(in FileAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock {
  NSString *urlString = [[[EngineHelperSingleton sharedInstance] spliceFullUrlByDomainBeanSpecialPathFunction] fullUrlByDomainBeanSpecialPath:UrlConstant_SpecialPath_uploadimage];
  return [self requestFileUploadWithUrl:urlString uploadFileKey:@"image" uploadFilePath:uploadFilePath progressBlock:progressBlock successedBlock:successedBlock failedBlock:failedBlock];
}

/**
 * 上传音频
 *
 * @param uploadFilePath                       要上传的音频的本地保存路径
 * @param uploadImageAsyncHttpResponseListener
 * @return
 */
- (id<INetRequestHandle>)requestAudioUploadWithUploadFilePath:(in NSString *)uploadFilePath
                                                progressBlock:(in FileAsyncHttpResponseListenerInUIThreadProgressBlock)progressBlock
                                               successedBlock:(in UploadFileSuccessedBlock)successedBlock
                                                  failedBlock:(in FileAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock {
  NSString *urlString = [[[EngineHelperSingleton sharedInstance] spliceFullUrlByDomainBeanSpecialPathFunction] fullUrlByDomainBeanSpecialPath:UrlConstant_SpecialPath_uploadaudio];
  return [self requestFileUploadWithUrl:urlString uploadFileKey:@"audio" uploadFilePath:uploadFilePath progressBlock:progressBlock successedBlock:successedBlock failedBlock:failedBlock];
  
}

@end
