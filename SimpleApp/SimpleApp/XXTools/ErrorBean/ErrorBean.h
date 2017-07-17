//
//  ErrorBean.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorBean : NSError

@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, assign) NSInteger errorCode;

- (NSString *)localizedOption;

/**
 * 重新初始化
 *
 * @param srcObject 错误内容
 */
- (void)reinitialize:(ErrorBean *)srcObject;

// 默认的初始化方法(会默认设置errorMessage=@"NONE", errorCode=ErrorCodeEnum_NONE)
- (id)init;

// 方便构造
+ (id)errorBeanWithErrorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage;
+ (id)errorBeanWithNSError:(NSError *)error;

@end
