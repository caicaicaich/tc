//
//  LocalCacheDataPathConstant.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalCacheDataPathConstant : NSObject {
  
}

/************************************************************************************/

// 苹果建议将程序中建立的或在程序中浏览到的文件数据保存在该目录下，iTunes备份和恢复的时候会包括此目录
+ (NSString *)documentsPath;
// 存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除
+ (NSString *)cachesPath;
// 提供一个即时创建临时文件的地方
// iTunes在与iPhone同步时，备份所有的Documents和Library文件。
// iPhone在重启时，会丢弃所有的tmp文件
+ (NSString *)tmpPath;


/************************************************************************************/
// 用户数据的本地缓存根目录(这个目录下面, 会根据用户id, 来创建N个具体用户账号目录)
+ (NSString *)userDataCacheRootPath;

/************************************************************************************/

// area数据库在SD卡上面的缓存目录
+ (NSString *)areaDatabaseCachePath;
// 项目中 "缩略图" 缓存目录
+ (NSString *)thumbnailCachePath;
// 项目中 "高清大图" 缓存目录 (在设备存储中, 可以被清除)
+ (NSString *)HDImageCachePath;
// 用户头像临时缓存文件夹
+ (NSString *)userIconTmpCachePath;
// 帖子图片临时缓存文件夹
+ (NSString *)postsImageTmpCachePath;
// 帖子音频临时缓存文件夹
+ (NSString *)postsAudioTmpCachePath;
// 帖子图片临时缓存文件夹(需要同步到第三方平台的的帖子图片)
+ (NSString *)postsImageSyncToThirdPartyPlatformTmpCachePath;
// app主题包临时缓存文件
+ (NSString *)themeTmpCachePath;
/************************************************************************************/

// 那些需要始终被保存, 不能由用户进行清除的文件
+ (NSString *)importantDataCachePath;

// 业务Bean缓存目录(可以被删除)
+ (NSString *)domainbeanCachePath;

/************************************************************************************/

// 返回能被用户清空的文件目录数组(可以从这里获取用户可以直接清空的文件夹路径数组)
+ (NSArray *)directoriesCanBeClearByTheUser;

// 创建本地数据缓存目录(一次性全部创建, 不会重复创建)
+ (void)createLocalCacheDirectories;

// 本地缓存的数据的大小(字节)
+ (long long)localCacheDataSize;

// 清理本地缓存(只清理那些, 我们指定的缓存数据)
+ (void)clearLocalCache;
/************************************************************************************/

@end
