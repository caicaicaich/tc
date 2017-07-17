//
//  HeartbeatManage.h
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/15.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeartbeatManage : NSObject

#pragma mark -
#pragma mark - 单例
+ (instancetype) sharedInstance;

/**
 * 重置整个心跳模块的标志位, 在退出登录时调用
 */
- (void)resetAllMark;


/**
 * 启动 "心跳检测" 模块
 */
- (void)start;

/**
 * 关闭 "心跳检测" 模块
 */
- (void)stop;

@end
