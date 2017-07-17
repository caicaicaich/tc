//
//  DomainBeanStub.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DomainBeanStub : NSObject

@property (nonatomic, readonly, assign) BOOL isUseStub;

#pragma mark -
#pragma mark - 构造方法
- (instancetype)initWithIsUseStub:(BOOL)isUseStub;

- (nullable instancetype)init DEPRECATED_ATTRIBUTE;

- (id)netRespondBeanStubByNetRequestBean:(id)netRequestBean;

@end

NS_ASSUME_NONNULL_END
