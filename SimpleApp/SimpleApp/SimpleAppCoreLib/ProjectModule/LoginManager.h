//
//  LoginManager.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/14.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstant.h"
#import "AppNetworkEngineSingleton.h"

@class LoginNetRespondBean;



@class LoginNetRespondBean;

@interface LoginManager : NSObject

#pragma mark - 登录相关

// 用户类型(标识着用户的权限)
@property (nonatomic, readonly, assign) UserTypeEnum userTypeEnum;

// 用户登录成功后, 服务器返回的 "用户信息" (只在有登录用户时, 这个属性才不为空, 目前看 UserType 不是 Guest 时, 这个属性就不为空)
@property (nonatomic, readonly, strong) LoginNetRespondBean *latestLoginNetRespondBean;

/**
 * 更新登录用户用户信息
 *
 * @param latestUserInfo 最新的用户信息模型
 */
- (void)updateLoginUserInfo:(LoginNetRespondBean *)loginNetRespondBean;

/**
 * 刷新最新的用户信息(当前登录用户)
 *
 * @return
 */
- (void)refreshLatestUserInfo;

/**
 * 登出请求
 */
- (void)logout;


/**
 * 用于判断当前是否有用户登录
 *
 * @return
 */
- (BOOL)isHasLoginUser;

/**
 * 判断当前登录用户是否是目标明星
 * @return
 */
- (BOOL)isStarLogin;

#pragma mark -
#pragma mark - 单例
+ (instancetype) sharedInstance;


@end
