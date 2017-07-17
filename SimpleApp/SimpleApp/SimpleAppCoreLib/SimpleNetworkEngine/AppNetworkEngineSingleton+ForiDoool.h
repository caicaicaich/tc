//
//  AppNetworkEngineSingleton+ForiDoool.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "AppNetworkEngineSingleton.h"
#import "UploadFileInfoFromServer.h"
/**
 * 上传成功回调块
 *
 * @param fileIdFromServer 服务器返回的 "文件ID"
 * @param fileUrlFromServer 服务器返回的 "文件下载URL"
 */
typedef void (^UploadFileSuccessedBlock)(UploadFileInfoFromServer *uploadFileInfoFromServer);

/**
 * 上传文件的异步监听接口(图片/声音/视频)
 *
 * @author zhihua.tang
 */
@interface AppNetworkEngineSingleton (ForiDoool)

/**
 * 上传图片
 *
 * @param uploadFilePath                       要上传的图片的本地保存路径
 * @param uploadImageAsyncHttpResponseListener
 * @return
 */
- (id<INetRequestHandle>)requestImageUploadWithUploadFilePath:(in NSString *)uploadFilePath
                                                progressBlock:(in FileAsyncHttpResponseListenerInUIThreadProgressBlock)progressBlock
                                               successedBlock:(in UploadFileSuccessedBlock)successedBlock
                                                  failedBlock:(in FileAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock;

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
                                                  failedBlock:(in FileAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock;

@end
