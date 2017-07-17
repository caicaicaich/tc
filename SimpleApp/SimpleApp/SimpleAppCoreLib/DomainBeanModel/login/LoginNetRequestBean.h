//
//  LoginNetRequestBean.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginNetRequestBean : NSObject

@property (nonatomic, copy, readonly) NSString *loginName;

@property (nonatomic, copy, readonly) NSString *password;

@property (nonatomic, copy, readonly) NSString *token;

#pragma mark -
#pragma mark - 构造方法
- (id)initWithLoginName:(NSString *) loginName password:(NSString *)password NS_DESIGNATED_INITIALIZER;

- (id)init DEPRECATED_ATTRIBUTE;
@end

NS_ASSUME_NONNULL_END
