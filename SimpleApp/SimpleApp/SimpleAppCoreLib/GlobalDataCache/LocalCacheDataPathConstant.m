//
//  LocalCacheDataPathConstant.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "LocalCacheDataPathConstant.h"
#import "SimpleFolderTools.h"
#import "PRPDebug.h"

@implementation LocalCacheDataPathConstant

// 静态初始化方法
+ (void) initialize {
  // 这是为了子类化当前类后, 父类的initialize方法会被调用2次
  if (self == [LocalCacheDataPathConstant class]) {
    
  }
}

#pragma mark -
#pragma mark - iOS 系统基础路径
+ (NSString *)documentsPath {
  static NSString *path = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = paths[0];
  });
  return path;
}
+ (NSString *)cachesPath {
  static NSString *path = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    path = paths[0];
  });
  return path;
}
+ (NSString *)tmpPath {
  return NSTemporaryDirectory();
}

#pragma mark -
#pragma mark - 用户数据的本地缓存根目录(这个目录下面, 会根据用户id, 来创建N个具体用户账号目录)
// 用户数据的本地缓存根目录(这个目录下面, 会根据用户id, 来创建N个具体用户账号目录)
+ (NSString *)userDataCacheRootPath {
  static NSString *path = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{
    path = [[self documentsPath] stringByAppendingPathComponent:@"UserData"];
  });
  return path;
}

#pragma mark -
#pragma mark -
// area数据库在SD卡上面的缓存目录
+ (NSString *)areaDatabaseCachePath {
  static NSString *path = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{
    path = [[self cachesPath] stringByAppendingPathComponent:@"AreaDatabase"];
  });
  return path;
}

// 项目中图片缓存目录(可以被删除)
+ (NSString *)thumbnailCachePath {
  static NSString *path = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{
    path = [[self cachesPath] stringByAppendingPathComponent:@"ThumbnailCachePath"];
  });
  return path;
}

// 项目中 "高清大图" 缓存目录 (在设备存储中, 可以被清除)
+ (NSString *)HDImageCachePath {
  static NSString *path = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{
    path = [[self cachesPath] stringByAppendingPathComponent:@"HDImageCachePath"];
  });
  return path;
}

// 用户头像临时缓存文件夹
+ (NSString *)userIconTmpCachePath {
  static NSString *path = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{
    path = [[self cachesPath] stringByAppendingPathComponent:@"UserIconTmpCachePath"];
  });
  return path;
}

// 帖子图片临时缓存文件夹
+ (NSString *)postsImageTmpCachePath {
  static NSString *path = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{
    path = [[self cachesPath] stringByAppendingPathComponent:@"PostsImageTmpCachePath"];
  });
  return path;
  
}

// 帖子音频临时缓存文件夹
+ (NSString *)postsAudioTmpCachePath {
  static NSString *path = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{
    path = [[self cachesPath] stringByAppendingPathComponent:@"PostsAudioTmpCachePath"];
  });
  return path;
}

// 帖子图片临时缓存文件夹(需要同步到第三方平台的的帖子图片)
+ (NSString *)postsImageSyncToThirdPartyPlatformTmpCachePath {
  static NSString *path = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{
    path = [[self cachesPath] stringByAppendingPathComponent:@"PostsImageSyncToThirdPartyPlatformTmpCachePath"];
  });
  return path;
}
// app主题包临时缓存文件
+ (NSString *)themeTmpCachePath {
  static NSString *path = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{
    path = [[self cachesPath] stringByAppendingPathComponent:@"ThemeTmpCachePath"];
  });
  return path;
}

#pragma mark -
#pragma mark -

// 那些需要始终被保存, 不能由用户进行清除的文件
+ (NSString *)importantDataCachePath {
  static NSString *path = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{
    path = [[self documentsPath] stringByAppendingPathComponent:@"ImportantDataCache"];
  });
  return path;
}

// 业务Bean缓存目录(可以被删除)
+ (NSString *)domainbeanCachePath {
  static NSString *path = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{
    path = [[self cachesPath] stringByAppendingPathComponent:@"DomainBeanCache"];
  });
  return path;
}

#pragma mark -
#pragma mark -

// 能否被用户清空的目录数组(可以从这里获取用户可以直接清空的文件夹路径数组)
+ (NSArray *)directoriesCanBeClearByTheUser {
  NSArray *directories = [NSArray arrayWithObjects:[self thumbnailCachePath], [self domainbeanCachePath], [self HDImageCachePath], [self userIconTmpCachePath], [self postsImageTmpCachePath], [self postsAudioTmpCachePath], [self postsImageSyncToThirdPartyPlatformTmpCachePath], nil];
  return directories;
}

// 创建本地数据缓存目录(一次性全部创建, 不会重复创建)
+ (void)createLocalCacheDirectories {
  PRPLog(@"\n\n-------------------------->     开始创建本地缓存目录      <--------------------------\n\n");
  // 创建本地数据缓存目录(一次性全部创建, 不会重复创建)
  NSArray *directories = [NSArray arrayWithObjects:
                          [self thumbnailCachePath],
                          [self importantDataCachePath],
                          [self domainbeanCachePath],
                          [self areaDatabaseCachePath],
                          [self userDataCacheRootPath],
                          [self HDImageCachePath],
                          [self userIconTmpCachePath],
                          [self postsImageTmpCachePath],
                          [self postsAudioTmpCachePath],
                          [self postsImageSyncToThirdPartyPlatformTmpCachePath],
                          [self themeTmpCachePath],
                          nil];
  
  NSMutableString *pathPrintString = [NSMutableString string];
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  for (NSString *path in directories) {
    if (![fileManager fileExistsAtPath:path]) {
      [fileManager createDirectoryAtPath:path
             withIntermediateDirectories:YES
                              attributes:nil
                                   error:nil];
    }
    
    // debug
    [pathPrintString appendString:path];
    [pathPrintString appendString:@"\n"];
    
  }
  
  PRPLog(@"%@", pathPrintString);
}

// 本地缓存的数据的大小(字节)
+ (long long)localCacheDataSize {
  long long size = 0;
  NSArray *directories = [LocalCacheDataPathConstant directoriesCanBeClearByTheUser];
  for(NSString *directory in directories) {
    size += [SimpleFolderTools folderSizeAtPath3:directory];
  }
  
  return size;
}

// 清理本地缓存(只清理那些, 我们指定的缓存数据)
+ (void)clearLocalCache {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  for (NSString *cacheFolderPath in [self directoriesCanBeClearByTheUser]) {
    [SimpleFolderTools deleteFolderAtPath:cacheFolderPath isDeleteRootFolder:NO];
  }
}

@end
