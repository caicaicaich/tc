//
//  FirstMarkManage.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "FirstMarkManage.h"
#import "GlobalDataCacheForDisk.h"
#import "RNAssert.h"

@implementation FirstMarkManage

#pragma mark -
#pragma mark 属性
- (void)setNotFirstEnterMainActivity:(BOOL)isNotFirstEnterMainActivity {
  _isNotFirstEnterMainActivity = isNotFirstEnterMainActivity;
  [GlobalDataCacheForDisk setNotFirstEnterMainActivityMark:isNotFirstEnterMainActivity];
}

//- (void)setNotFirstEnterStarHomepageActivity:(BOOL)isNotFirstEnterStarHomepageActivity {
//  _isNotFirstEnterStarHomepageActivity = isNotFirstEnterStarHomepageActivity;
//  [GlobalDataCacheForDisk setNotFirstEnterStarHomepageActivityMark:isNotFirstEnterStarHomepageActivity];
//}

#pragma mark -
#pragma mark 单例方法群

// 使用 Grand Central Dispatch (GCD) 来实现单例, 这样编写方便, 速度快, 而且线程安全.
- (id)init {
  // 禁止调用 -init 或 +new
  RNAssert(NO, @"Cannot create instance of Singleton");
  
  // 在这里, 你可以返回nil 或 [self initSingleton], 由你来决定是返回 nil还是返回 [self initSingleton]
  return nil;
}

// 真正的(私有)init方法
- (id)initSingleton {
  self = [super init];
  if ((self = [super init])) {
    // 初始化代码
    _isNotFirstEnterMainActivity = [GlobalDataCacheForDisk isNotFirstEnterMainActivity];
    //_isNotFirstEnterStarHomepageActivity = [GlobalDataCacheForDisk isNotFirstEnterStarHomepageActivity];
  }
  
  return self;
}

+ (instancetype)sharedInstance {
  static id singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
  return singletonInstance;
}

@end
