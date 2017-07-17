//
//  ErrorCodeEnum.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#ifndef ErrorCodeEnum_h
#define ErrorCodeEnum_h

/**
 * 网络请求时, 错误码枚举
 *
 * @author zhihua.tang
 */
typedef NS_ENUM(NSInteger, ErrorCodeEnum) {
  // 无效错误码
  ErrorCodeEnum_NONE = -2014,
  
  // ------------------------------------------------------------------------------------------------------------
  // TODO:HTTP错误代码段 (100 ~ 505)
  
  // ------------------------------------------------------------------------------------------------------------
  // TODO:客户端错误 (1000 ~ 1999)
  
  /// 客户端错误
  ErrorCodeEnum_Client_Error                                                            = 1000,
  // 客户端编程错误
  ErrorCodeEnum_Client_ProgrammingError                                                 = 1001,
  // 方法的参数错误
  ErrorCodeEnum_Client_IllegalArgument                                                  = 1002,
  // 空指针
  ErrorCodeEnum_Client_NullPointer                                                      = 1003,
  // 方法返回值无效(就是调用一个有返回值的方法, 结果发现返回值无效)
  ErrorCodeEnum_Client_MethodReturnValueInvalid                                         = 1004,
  // 网络请求业务Bean无效
  ErrorCodeEnum_Client_NetRequestBeanInvalid                                            = 1005,
  // 违法的状态异常。当在Java环境和应用尚未处于某个方法的合法调用状态，而调用了该方法时，抛出该异常。
  ErrorCodeEnum_Client_IllegalState                                                     = 1006,
  
  
  
  
  
  // ------------------------------------------------------------------------------------------------------------
  // TODO:服务器错误 (2000 ~ 2999)
  
  /// 服务器错误
  ErrorCodeEnum_Server_Error                                                            = 2000,
  
  // 从服务器端获得的实体数据为空(EntityData), 这种情况有可能是正常的, 比如 退出登录 接口, 服务器就只是通知客户端访问成功, 而不发送任何实体数据.
  ErrorCodeEnum_Server_NoResponseData                                                   = 2001,
  // 解析服务器端返回的实体数据失败, 在netUnpackedDataOfUTF8String不为空的时候, unpackNetResponseRawEntityDataToUTF8String是绝对不能为空的.
  ErrorCodeEnum_Server_UnpackedResponseDataFailed                                       = 2002,
  // 将网络返回的数据转换成 "字典" 失败, 可能原因是服务器和客户端的数据协议不同步照成的, 比如说客户端需要JSON, 而服务器返回的数据格式不是JSON
  ErrorCodeEnum_Server_ResponseDataToDictionaryFailed                                   = 2003,
  // 将数据字典, 通过KVC的方式, 解析成业务Bean失败.
  ErrorCodeEnum_Server_ParseDictionaryFailedToNetRespondBeanFailed                      = 2004,
  // 服务器传递给客户端的数据中, 关键字段丢失或者类型不正确
  ErrorCodeEnum_Server_LostCoreField                                                    = 2005,
  // 服务器返回的数据中, 丢失有效数据字段(data).
  ErrorCodeEnum_Server_LostDataField                                                    = 2006,
  // 服务器返回的数据中, 丢失错误码字段(errorCode).
  ErrorCodeEnum_Server_LostErrorCodeField                                               = 2007,
  
};


#endif /* ErrorCodeEnum_h */
