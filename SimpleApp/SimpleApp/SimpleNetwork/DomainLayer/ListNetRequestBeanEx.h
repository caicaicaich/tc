//
//  ListNetRequestBeanEx.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListNetRequestBeanEx : NSObject

@property (nonatomic, readonly, assign) NSInteger offset;
@property (nonatomic, readonly, assign) NSInteger limit;

#pragma mark -
#pragma mark - 构造方法

- (instancetype)initWithOffset:(NSInteger)offset limit:(NSInteger)limit;

- (instancetype)initWithOffset:(NSInteger)offset;

@end
