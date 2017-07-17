//
//  GlobalDataCacheForDisk.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstant.h"

@class LoginNetRespondBean;


// GlobalDataCacheForMemorySingleton 类中有些数据是需要固化到设备中的,
// 本类就是用来完成这些数据固化工作的 "通讯录模式"
@interface GlobalDataCacheForDisk : NSObject

/**
 * 第一次启动APP的标志位
 *
 * @return true : 是第一次启动, false : 不是第一次启动
 */
+ (BOOL)isFirstStartApp;
/**
 * 获取用户最后一次成功登录时的 LoginNetRespondBean
 *
 * @return
 */
+ (LoginNetRespondBean *)latestLoginNetRespondBean;

+ (NSArray *)SearchHistory;


/**
 * 判断是否已经显示过, 用户升级对话框了.
 *
 * @return
 */
+ (BOOL)isShowedUserUpgradeDialog;

/**
 * 是否是第一次进入主界面
 *
 * @return true : 是第一次, false : 不是第一次
 */
+ (BOOL)isNotFirstEnterMainActivity;


#pragma mark - Set 方法群

+(void) setSearchHistory:(NSArray *) search;

+ (void)setFirstStartAppMark:(BOOL)isFirstStartApp;

/**
 * 保存用户登录信息到设备文件系统中
 *
 * @param latestLoginNetRespondBean
 */
+ (void)setLatestLoginNetRespondBean:(LoginNetRespondBean *)latestLoginNetRespondBean;


+ (void)setNotFirstEnterMainActivityMark:(BOOL)isNotFirstEnterMainActivity;





@end
