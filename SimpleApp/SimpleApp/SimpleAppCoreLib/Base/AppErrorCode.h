//
//  AppErrorCode.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#ifndef AppErrorCode_h
#define AppErrorCode_h

/**
 * 网络请求时, 错误码枚举
 *
 * @author zhihua.tang
 */

typedef NS_ENUM(NSInteger, AppErrorCodeEnum) {
  
  
  // ------------------------------------------------------------------------------------------------------------
  // TODO:和服务器约定好的错误码, 联网成功, 但是服务器那边发生了错误, 服务器要告知客户端错误的详细信息
  
  // 和服务器约定好的错误码, 联网成功, 但是服务器那边发生了错误, 服务器要告知客户端错误的详细信息
  AppErrorCodeEnum_Server_Custom_Error                                                     = -1,
  
  // 请求成功
  AppErrorCodeEnum_Server_Custom_Error_Success                                             = 0, // 请求数据成功
  // 请求数据失败
  AppErrorCodeEnum_Server_Custom_Error_Failed                                              = 1, // 操作失败.
  AppErrorCodeEnum_Server_Custom_Error_Exception                                           = 300001, // 处理异常.
  AppErrorCodeEnum_Server_Custom_Error_NoResult                                            = 300002, // 无结果返回.
  AppErrorCodeEnum_Server_Custom_Error_VerifCodeInvalid                                    = 300003, // 验证码错误.
  AppErrorCodeEnum_Server_Custom_Error_PhoneIsRegistered                                   = 300004, // 手机号码已经被注册.
  AppErrorCodeEnum_Server_Custom_Error_PhoneIsNotRegister                                  = 300005, // 手机号码尚未注册.
  AppErrorCodeEnum_Server_Custom_Error_NickNameNotLawful                                   = 300006, // 昵称不合法.
  AppErrorCodeEnum_Server_Custom_Error_PasswordWrong                                       = 300007, // 密码错误.
  
  AppErrorCodeEnum_Server_Custom_Error_DataHasbeenDeleted                                  = 300008, // 数据已被删除.
  AppErrorCodeEnum_Server_Custom_Error_TopicNotExist                                       = 300009, // 话题不存在.
  AppErrorCodeEnum_Server_Custom_Error_UserPermissionsDisabled                             = 300010, // 用户权限被禁用.
  AppErrorCodeEnum_Server_Custom_Error_TokenInvalid                                        = 300011, // token无效, 请重新登录."
  AppErrorCodeEnum_Server_Custom_Error_ParticipateWelfareActivityFail                      = 300012, // 参与福利活动失败.
  AppErrorCodeEnum_Server_Custom_Error_NotEnoughMoney                                      = 300013, // 金币不足.
  AppErrorCodeEnum_Server_Custom_Error_WelfarePropNotEnough                                = 300014, // 要兑换的福利道具数量不足.
  AppErrorCodeEnum_Server_Custom_Error_PostsHasBeenDelete                                  = 300016, // 帖子已被删除.
  AppErrorCodeEnum_Server_Custom_Error_CommentHasBeenDelete                                = 300017, // 评论已被删除.
};
#endif /* AppErrorCode_h */
