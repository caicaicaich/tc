//
//  ProjectHelper.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ErrorBean;

@class UploadFileInfoFromServer;
@interface ProjectHelper : NSObject

// 时间戳
+ (nonnull NSString *)timestamp;

+ (void)clearCookie;


+ (nonnull NSString *)appVersion;
+ (nonnull NSString *)appBuild;

/**
 * 上传文件成功后, 从服务器返回的 responseBody 中解析出 文件ID
 *
 * @param responseBody 上传成功后, 服务器返回的数据
 * @return
 */
+ (nonnull UploadFileInfoFromServer *)uploadFileIdFromServerResponseBody:(nonnull NSString *)responseBody errorOUT:(ErrorBean *_Nonnull*_Nonnull)errorOUT;

// 发送一个同步 Notification
+ (void)sendSyncNotification:(NSNotification *_Nonnull)notification;

// 发送一个异步 Notification
+ (void)sendAsyncNotification:(NSNotification *_Nonnull)notification;

// 判断app是否运行在后台
+ (BOOL)isAppInBackground;

/**
 * 获取第三方登录时, 需要传给服务器的验证秘钥
 *
 * @param thirdPartyPlatformUID 第三方平台返回的UID
 * @return
 */
+ (nonnull NSString *)encryptionKey:(nonnull NSString *)thirdPartyPlatformUID;

/**
 * app注册服务端通知deviceToken
 * @return
 */
+ (nonnull NSString *)deviceToken;

+ (void)setDeviceToken:(nonnull NSString *)value;

@end
