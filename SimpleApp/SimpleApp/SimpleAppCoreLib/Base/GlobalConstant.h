//
//  GlobalConstant.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 本地广播(只在本app中流转的)
 */

extern NSString *const kLocalBroadcastAction_LaunchADClick;

// 用户信息更新
extern NSString *const kLocalBroadcastAction_UserInfoUpdate;


// 退出APP
extern NSString *const kLocalBroadcastAction_ExitApp;
// token无效, 需要用户重新登录
extern NSString *const kLocalBroadcastAction_TokenInvalid;


// 性别
typedef NS_ENUM(NSInteger, GenderEnum) {
  GenderEnum_Female = 0, // 女性
  GenderEnum_Male = 1    // 男性
};

// 获取 ListRequestDirectionEnum 对应的发往服务器的值
#define GetListRequestDirectionEnumToServerValue(x) (x == ListRequestDirectionEnum_Refresh ? @"true" : @"false")

// 第三方平台
typedef NS_ENUM(NSInteger, ThirdPartyPlatformEnum) {
  ThirdPartyPlatformEnum_SinaWeibo = 1, // 新浪微博
  ThirdPartyPlatformEnum_Weixin    = 2, // 微信
  ThirdPartyPlatformEnum_QQ        = 3, // QQ
  ThirdPartyPlatformEnum_Facebook  = 4  // 朋友圈
};

// 登录用户的用户类型(用户所属的权限组, 不同的权限可以做不同的事情)
typedef NS_ENUM(NSInteger, UserTypeEnum) {
  UserTypeEnum_Guest       = 0,  // 游客
  UserTypeEnum_NewRegister = 1,  // 新注册用户(还未完善用户信息的用户是新用户, 必须完善用户信息之后, 才能晋级为普通用户)
  UserTypeEnum_Normal      = 2,  // 普通用户
  UserTypeEnum_Blacklist   = 100 // 被列入黑名单的用户
};


/**
 * 推送类型
 */
typedef NS_ENUM(NSInteger, PushTypeEnum) {
  PushTypeEnum_All = 1, // 全体
  pushTypeEnum_One = 2  // 单体
};


@interface GlobalConstant : NSObject

@end
