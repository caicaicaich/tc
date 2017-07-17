//
//  GlobalDataCacheForMemorySingleton.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalDataCacheForMemorySingleton : NSObject

#pragma mark -
#pragma mark - 其他配置
// 用户第一次启动App
@property (nonatomic, assign, setter=setFirstStartApp:) BOOL isFirstStartApp;
// 是否需要在app启动时, 显示 "初学者指南界面"
@property (nonatomic, assign, setter=setNeedShowBeginnerGuide:) BOOL isNeedShowBeginnerGuide;
// 是否需要自动登录的标志
@property (nonatomic, assign, setter=setNeedAutologin:) BOOL isNeedAutologin;


#pragma mark -
#pragma mark - 单例
+ (instancetype) sharedInstance;

@end
