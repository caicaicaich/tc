//
//  GlobalConstant.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "GlobalConstant.h"


/**
 * 本地广播(只在本app中流转的)
 */
// 启动图点击
NSString *const kLocalBroadcastAction_LaunchADClick = @"APPLaunchADClick";
// 用户退出登录
//Logout,
// 用户信息更新
NSString *const kLocalBroadcastAction_UserInfoUpdate = @"UserInfoUpdate";
// 当前登录用户被列入黑名单, 客户端要将其踢出
NSString *const kLocalBroadcastAction_LoginUserWasBlacklisted = @"LoginUserWasBlacklisted";
// 退出APP
NSString *const kLocalBroadcastAction_ExitApp = @"ExitApp";
// token无效, 需要用户重新登录
NSString *const kLocalBroadcastAction_TokenInvalid = @"TangzhihuaTokenInvalid";

@implementation GlobalConstant



@end
