//
//  GlobalDataCacheForDisk.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "GlobalDataCacheForDisk.h"
#import "SimpleObjectSerialization.h"
#import "LocalCacheDataPathConstant.h"
#import "ProjectHelper.h"
#import "NSString+isEmpty.h"


@implementation GlobalDataCacheForDisk


#pragma mark - 缓存常量key定义
// 用户是否是首次启动App
static NSString *const kCacheDataNameEnum_FirstStartApp = @"last_run_version_of_application";
// 当前app版本号, 用了防止升级app时, 本地缓存的序列化数据恢复出错.
static NSString *const kCacheDataNameEnum_LocalAppVersion = @"LocalAppVersion";

// 用户最后一次登录成功时的 LoginNetRespondBean
static NSString *const kCacheDataNameEnum_LatestLoginNetRespondBean = @"LatestLoginNetRespondBean";
//
static NSString *const kCacheDataNameEnum_Cookie = @"Cookie";

// ----------------- 缓存模块中的数据 ---------------------


// 是否是第一次进入主界面
static NSString *const kCacheDataNameEnum_IsNotFirstEnterMainActivity = @"IsNotFirstEnterMainActivity";


// 记录是否已经显示过用户升级对话框了
static NSString *const kCacheDataNameEnum_IsShowedUserUpgradeDialog = @"IsShowedUserUpgradeDialog";

static NSString *const kCacheDataNameEnum_SearchHistory = @"SearchHistory";

#pragma mark -

// 缓存目录路径
+ (NSString *)cacheDirectoryPath {
  return [LocalCacheDataPathConstant importantDataCachePath];
}

static id DeserializeObject(NSString *key) {
  return SimpleDeserializeObject(key, [GlobalDataCacheForDisk cacheDirectoryPath]);
}

static void SerializeObject(id object, NSString *key) {
  SimpleSerializeObject(object, key, [GlobalDataCacheForDisk cacheDirectoryPath]);
}

#pragma mark -

+ (void)initialize {
  // 这是为了子类化当前类后, 父类的initialize方法会被调用2次
  if (self == [GlobalDataCacheForDisk class]) {
    
    // 新版本升级处理
    [self newVersionUpgradeHandle];
  }
}

#pragma mark -
// 新版本升级的处理工作(要删除之前的序列化对象文件, 防止类模型发生了变化)
+ (void)newVersionUpgradeHandle {
  // 检查app版本是否发生了变化, 如果发生了变化, 可能是发生了 "软件升级"
  NSString *newVerMark = [NSString stringWithFormat:@"%@/%@", self.cacheDirectoryPath, [ProjectHelper appVersion]];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if (![fileManager fileExistsAtPath:newVerMark]) {
    //
    [fileManager removeItemAtPath:self.cacheDirectoryPath error:nil];
    
    [fileManager createDirectoryAtPath:self.cacheDirectoryPath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
    
    [fileManager createFileAtPath:newVerMark contents:nil attributes:nil];
  }
}


#pragma mark - Get 方法群
/**
 * 第一次启动APP的标志位
 *
 * @return true : 是第一次启动, false : 不是第一次启动
   */
+ (BOOL)isFirstStartApp {
  NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                              objectForKey:@"CFBundleShortVersionString"];
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  NSString *lastRunVersion = [defaults objectForKey:kCacheDataNameEnum_FirstStartApp];
  
  if (!lastRunVersion) {
    [defaults setObject:currentVersion forKey:kCacheDataNameEnum_FirstStartApp];
    return YES;
  } else if (![lastRunVersion isEqualToString:currentVersion]) {
    [defaults setObject:currentVersion forKey:kCacheDataNameEnum_FirstStartApp];
    return YES;
  }
  return NO;
}

/**
 * 获取用户最后一次成功登录时的 LoginNetRespondBean
 *
 * @return
 */
+ (LoginNetRespondBean *)latestLoginNetRespondBean {
    LoginNetRespondBean *loginNetRespondBean = DeserializeObject(kCacheDataNameEnum_LatestLoginNetRespondBean);
    return loginNetRespondBean;
}


/**
 * 判断是否已经显示过, 用户升级对话框了.
 *
 * @return
 */
+ (BOOL)isShowedUserUpgradeDialog {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  return [userDefaults boolForKey:kCacheDataNameEnum_IsShowedUserUpgradeDialog];
}


/**
 * 是否是第一次进入主界面
 *
 * @return true : 是第一次, false : 不是第一次
 */
+ (BOOL)isNotFirstEnterMainActivity {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  return [userDefaults boolForKey:kCacheDataNameEnum_IsNotFirstEnterMainActivity];
}

+ (NSArray *)SearchHistory {
    NSUserDefaults *userDeafults = [NSUserDefaults standardUserDefaults];
    return [userDeafults arrayForKey:kCacheDataNameEnum_SearchHistory];
}


#pragma mark -
#pragma mark - Set 方法群

/**
 * 保存用户登录信息到设备文件系统中
 *
 * @param latestLoginNetRespondBean
 */
+ (void)setLatestLoginNetRespondBean:(LoginNetRespondBean *)latestLoginNetRespondBean {
    SerializeObject(latestLoginNetRespondBean, kCacheDataNameEnum_LatestLoginNetRespondBean);
}

+ (void)setNotFirstEnterMainActivityMark:(BOOL)isNotFirstEnterMainActivity {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setBool:isNotFirstEnterMainActivity forKey:kCacheDataNameEnum_IsNotFirstEnterMainActivity];
}

+ (void)setSearchHistory:(NSArray *)search {
    NSUserDefaults *userDeaults = [NSUserDefaults standardUserDefaults];
    [userDeaults setObject:search forKey:kCacheDataNameEnum_SearchHistory];
}

@end
