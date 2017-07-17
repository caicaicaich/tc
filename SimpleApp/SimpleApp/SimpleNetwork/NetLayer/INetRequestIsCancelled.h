//
//  INetRequestIsCancelled.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

// 判断当前网络请求是否已经被取消了
@protocol INetRequestIsCancelled <NSObject>
/**
 * 判断当前网络请求是否已经被取消
 *
 * @return BOOL
 */
- (BOOL)isCancelled;

@end
