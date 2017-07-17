//
//  LoginManager.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/14.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "LoginManager.h"
#import "AppNetworkEngineSingleton.h"
#import "LoginNetRespondBean.h"
#import "CacheManageSingleton.h"
#import "HeartbeatManage.h"
#import "GlobalDataCacheForDisk.h"
#import "NetRequestHandleNilObject.h"
#import "ProjectHelper.h"
#import "NSString+isEmpty.h"
#import "RNAssert.h"

@interface LoginManager ()

// 注意 : 如果重写 setter=setLoggingIn: 会导致 isLoggingIn 属性KVO失效
//@property (nonatomic, assign, setter=setLoggingIn:, readwrite) BOOL isLoggingIn;
//@property (nonatomic, assign, readwrite) BOOL isLoggingIn;

@property (nonatomic, readwrite, strong) LoginNetRespondBean *latestLoginNetRespondBean;

@property (nonatomic, strong) id<INetRequestHandle> netRequestHandleForRefreshLatestUserInfo;

@end

@implementation LoginManager

// 使用 Grand Central Dispatch (GCD) 来实现单例, 这样编写方便, 速度快, 而且线程安全.
- (id)init {
    // 禁止调用 -init 或 +new
    RNAssert(NO, @"Cannot create instance of Singleton");
    
    // 在这里, 你可以返回nil 或 [self initSingleton], 由你来决定是返回 nil还是返回 [self initSingleton]
    return nil;
}

// 真正的(私有)init方法
- (id)initSingleton {
    self = [super init];
    if ((self = [super init])) {
        // 初始化代码
        _netRequestHandleForRefreshLatestUserInfo = [[NetRequestHandleNilObject alloc] init];
        
        // 从 持久缓存模块 读取缓存的登录用户信息
        _latestLoginNetRespondBean = [GlobalDataCacheForDisk latestLoginNetRespondBean];
        
        if (_latestLoginNetRespondBean == nil) {
            // 如果本地没有登录的用户, 就清空本地缓存的cookice (因为服务器从 cookice 中读取登录用户的 uid/token)
            [ProjectHelper clearCookie];
        }
        
    }
    
    return self;
}

+ (instancetype)sharedInstance {
    static id singletonInstance = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
    return singletonInstance;
}

- (void)setLatestLoginNetRespondBean:(LoginNetRespondBean *)latestLoginNetRespondBean {
    _latestLoginNetRespondBean = latestLoginNetRespondBean;
    // 硬盘缓存
    [GlobalDataCacheForDisk setLatestLoginNetRespondBean:latestLoginNetRespondBean];
}


#pragma mark - 一些对外的工具类
/**
 * 用于判断当前是否有用户登录
 *
 * @return
 */
- (BOOL)isHasLoginUser {
    return self.latestLoginNetRespondBean != nil;
}

#pragma mark -
/**
 * 更新登录用户用户信息
 *
 * @param latestUserInfo 最新的用户信息模型
 */
- (void)updateLoginUserInfo:(LoginNetRespondBean *)loginNetRespondBean {
    if (loginNetRespondBean == nil) {
        // 异常情况, 入参不应该为空
        return;
    }
    
    @synchronized (self) {
        
        // 对外发送 "用户信息更新广播"
        NSNotification *notification = [NSNotification notificationWithName:kLocalBroadcastAction_UserInfoUpdate object:nil];
        [ProjectHelper sendAsyncNotification:notification];
        
        // TODO : 一定在最后调用
        self.latestLoginNetRespondBean = loginNetRespondBean;
    }
}

#pragma mark -

/**
 * 刷新最新的用户信息
 *
 * @return
 */
- (void)refreshLatestUserInfo {
    if (![self isHasLoginUser]) {
        // 没有用户登录
        return;
    }
    
    if ([_netRequestHandleForRefreshLatestUserInfo isBusy]) {
        // 网络请求未结束
        return;
    }
    
}




@end
