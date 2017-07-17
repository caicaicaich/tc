//
//  FirstMarkManage.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirstMarkManage : NSObject

// 是否是第一次进入主界面
@property (nonatomic, assign, setter=setNotFirstEnterMainActivity:) BOOL isNotFirstEnterMainActivity;

// 是否是第一次进入明星首页
@property (nonatomic, assign, setter=setNotFirstEnterStarHomepageActivity:) BOOL isNotFirstEnterStarHomepageActivity;

#pragma mark -
#pragma mark - 单例
+ (instancetype) sharedInstance;

@end
