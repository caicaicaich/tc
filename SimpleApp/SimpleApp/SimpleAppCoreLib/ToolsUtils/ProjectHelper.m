//
//  ProjectHelper.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "ProjectHelper.h"
#import "NSString+Helper.h"
#import <WebKit/WebKit.h>
#import "UploadFileInfoFromServer.h"
#import "NSDictionary+Contain.h"
#import "AppErrorCode.h"
#import "PRPDebug.h"
#import "NSString+isEmpty.h"
#import "RNAssert.h"
#import "ErrorBean.h"

@implementation ProjectHelper

static BOOL isAppInBackground = NO;
static NSString *kDeviceToken = @"";


+ (void)initialize {
  // 这是为了子类化当前类后, 父类的initialize方法会被调用2次
  if (self == [ProjectHelper class]) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:[UIApplication sharedApplication]];
  }
}

+ (void)dealloc {
  
  if (self == [ProjectHelper class]) {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
  }
}

// app 进入后台
+ (void)applicationDidEnterBackground {
  isAppInBackground = YES;
}

// app 进入前台
+ (void)applicationWillEnterForeground {
  isAppInBackground = NO;
}

#pragma mark
#pragma mark 不能使用默认的init方法初始化对象, 而必须使用当前类特定的 "初始化方法" 初始化所有参数
- (id) init {
  RNAssert(NO, @"Can not use the default init method!");
  
  return nil;
}


#pragma mark
#pragma mark 对外的公开的工具类
// 时间戳
+ (NSString *)timestamp {
  NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
  NSTimeInterval timeInterval = [date timeIntervalSince1970] * 1000;
  return [NSString stringWithFormat:@"%f", timeInterval];
}

+ (void)clearCookie {
  // 清除cookies
  NSHTTPCookieStorage *httpCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  for (NSHTTPCookie *cookie in httpCookieStorage.cookies) {
    [httpCookieStorage deleteCookie:cookie];
  }
  
  //－－－－－－－－－－－－－－IOS9以上－－－－－－－－－－－－－－－－
  WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
  [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes] completionHandler:^(NSArray<WKWebsiteDataRecord *> * _Nonnull records) {
    for (WKWebsiteDataRecord *record  in records) {
      /* 取消备注，可以针对某域名清除，否则是全清
       if ( [record.displayName containsString:@"baidu"]) //
       {
       
       }
       */
      [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                forDataRecords:@[record]
                                             completionHandler:^{
                                               PRPLog(@"Cookies for %@ deleted successfully",record.displayName);
                                             }];
    }
  }];
  
  //－－－－－－－－－－－－－－IOS8以上－－－－－－－－－－－－－－－
  NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
  NSError *errors;
  [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
  
}

/*
 CFBundleVersion，标识（发布或未发布）的内部版本号。这是一个单调增加的字符串，包括一个或多个时期分隔的整数。
 
 CFBundleShortVersionString  标识应用程序的发布版本号。该版本的版本号是三个时期分隔的整数组成的字符串。
 第一个整数代表重大修改的版本，如实现新的功能或重大变化的修订。第二个整数表示的修订，实现较突出的特点。
 第三个整数代表维护版本。该键的值不同于“CFBundleVersion”标识。
 */
+ (NSString *)appVersion {
  NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
  NSString *versionName = [infoDic objectForKey:@"CFBundleShortVersionString"];
  return versionName;
}

+ (NSString *)appBuild {
  NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
  NSString *versionCode = [infoDic objectForKey:@"CFBundleVersion"];
  return versionCode;
}

/**
 * 上传文件成功后, 从服务器返回的 responseBody 中解析出 文件ID
 *
 * @param responseBody 上传成功后, 服务器返回的数据
 * @return
 */
+ (UploadFileInfoFromServer *)uploadFileIdFromServerResponseBody:(NSString *)responseBody errorOUT:(ErrorBean **)errorOUT {
  NSString *errorMessage = nil;
  
  do {
    NSError *error = nil;
    NSData *data = [responseBody dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonRootNSDictionary =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error != nil) {
      errorMessage = [error localizedDescription];
      break;
    }
    if (![jsonRootNSDictionary isKindOfClass:[NSDictionary class]]) {
      errorMessage = [NSString stringWithFormat:@"json 解析失败!-->responseBody = %@ ", responseBody];
      break;
    }
    
    if (![jsonRootNSDictionary containsKey:@"status"]) {
      errorMessage = @"服务器返回的数据中, 丢失关键字段 status";
      break;
    }
    
    if ([jsonRootNSDictionary[@"status"] integerValue] != AppErrorCodeEnum_Server_Custom_Error_Success) {
      errorMessage = jsonRootNSDictionary[@"msg"];
      break;
    }
    
    if (![jsonRootNSDictionary containsKey:@"data"]) {
      errorMessage = @"服务器返回的数据中, 丢失关键字段 data";
      break;
    }
    
    NSDictionary *dataJSONNSDictionary = jsonRootNSDictionary[@"data"];
    if (![dataJSONNSDictionary containsKey:@"_id"]) {
      errorMessage = @"服务器返回的数据中, 丢失关键字段 fileUrl";
      break;
    }
    
    NSString *fileIdFromServer = dataJSONNSDictionary[@"_id"];
    if ([NSString isEmpty:fileIdFromServer]) {
      errorMessage = @"服务器返回 _id 为空.";
      break;
    }
    
    NSString *fileUrlFromServer = dataJSONNSDictionary[@"fileUrl"];
    
    return [[UploadFileInfoFromServer alloc] initWithFileId:fileIdFromServer fileUrl:fileUrlFromServer];
  } while (NO);
  
  if (errorOUT != NULL) {
    *errorOUT = [ErrorBean errorBeanWithErrorCode:-1 errorMessage:errorMessage];
  }
  return nil;
}

// 发送一个同步 Notification
+ (void)sendSyncNotification:(NSNotification *)notification {
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  [notificationCenter postNotification:notification];
}

// 发送一个异步 Notification
+ (void)sendAsyncNotification:(NSNotification *)notification {
  [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostASAP];
}

// 判断app是否运行在后台
+ (BOOL)isAppInBackground {
  return isAppInBackground;
}

/**
 * 获取第三方登录时, 需要传给服务器的验证秘钥
 *
 * @param thirdPartyPlatformUID 第三方平台返回的UID
 * @return
 */
+ (NSString *)encryptionKey:(NSString *)thirdPartyPlatformUID {
  // 加密算法：（uid前两位 + uid后两位）进行两次md5操作
  NSMutableString *stringBuffer = [NSMutableString string];
  [stringBuffer appendString:[thirdPartyPlatformUID substringFrom:0 to:2]];
  [stringBuffer appendString:[thirdPartyPlatformUID substringFrom:thirdPartyPlatformUID.length - 2 to:thirdPartyPlatformUID.length]];
  return [[stringBuffer md5] md5];
}


/**
 * app注册服务端通知deviceToken
 * @return
 */
+ (NSString *)deviceToken{
  return kDeviceToken;
}

+ (void)setDeviceToken:(nonnull NSString *)value{
  if (![NSString isEmpty:value]) {
    kDeviceToken = value;
  }
}
@end
