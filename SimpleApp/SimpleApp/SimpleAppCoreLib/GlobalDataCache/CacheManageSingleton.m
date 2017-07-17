//
//  CacheManageSingleton.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "CacheManageSingleton.h"
#import "GlobalDataCacheForDisk.h"
#import "ProjectHelper.h"
#import "PRPDebug.h"
#import "RNAssert.h"
#import "ListNetRespondBean.h"
#import "ListNetRequestBean.h"
#import "LoginNetRespondBean.h"
#import "LoginManager.h"

@implementation CacheManageSingleton

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
    
  }
  
  return self;
}

+ (instancetype)sharedInstance {
  static id singletonInstance = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{singletonInstance = [[self alloc] initSingleton];});
  return singletonInstance;
}

#pragma mark -
#pragma mark - 对外公开的方法

/**
 * 模块初始化方法, 使用模块前要先调用此方法(不能重复调用)
 */
- (void)initialize {
  
}

/**
 * 非增量更新一个列表, 就是在尾部追加
 */
- (void)updateList:(ListNetRespondBean *)localCahceDataSource newDataFromServer:(ListNetRespondBean *)newDataFromServer {
  localCahceDataSource.isLastPage = newDataFromServer.isLastPage;
  [(NSMutableArray *)localCahceDataSource.list addObjectsFromArray:newDataFromServer.list];
}

/**
 * 增量更新列表类型的数据
 *
 * @param localCahceDataSource 本地缓存的数据源
 * @param newDataFromServer    从服务器拉回的新数据
 * @param netRequestBean       网络请求业务Bean
 */
- (void)incrementalUpdateList:(ListNetRespondBean *)localCahceDataSource
            newDataFromServer:(ListNetRespondBean *)newDataFromServer
               netRequestBean:(ListNetRequestBean *)netRequestBean {
  
  if (netRequestBean.direction == ListRequestDirectionEnum_LoadMore) {// load more
    
    localCahceDataSource.isLastPage = newDataFromServer.isLastPage;
    [(NSMutableArray *)localCahceDataSource.list addObjectsFromArray:newDataFromServer.list];
    
  } else {// refresh
    
    //下拉刷新时, 如果没超出约定的一屏数据最大值, isLastPage 就返回true, 如果超出 isLastPage就返回false, 此时客户端要清除本地缓存
    if (newDataFromServer.isLastPage) {
      // 此时是增量更新, 本地缓存的数据都完好
      for (int i=(int)(newDataFromServer.list.count-1); i>=0; i--) {
        [(NSMutableArray *)localCahceDataSource.list insertObject:newDataFromServer.list[i] atIndex:0];
      }
    } else {
      // 此时已经无法进行增量追加, 所以要抛弃本地之前的缓存数据, 此处一定要将 isLastPage 置位为 false ,否则就无法上拉加载更多了.
      [(NSMutableArray *)localCahceDataSource.list removeAllObjects];
      [(NSMutableArray *)localCahceDataSource.list addObjectsFromArray:newDataFromServer.list];
      
      // 置位 isLastPage 为 NO, 好恢复上拉加载更多功能
      localCahceDataSource.isLastPage = NO;
    }
  }
}
/**
 * 缓存数据的方法(由应用网络层调用)
 *
 * @param netRequestBean   网络请求业务Bean(作为key)
 * @param netRespondBean   网络响应业务Bean(作为value)
 */
- (void)cacheNetRespondBean:(id)netRespondBean withNetRequestBean:(id)netRequestBean {
  
  // TODO : 以下接口调用成功时, 会返回当前登录用户最新的用户信息, 我们要及时进行缓存数据同步
  
  //OauthLoginNetRequestBean LoginNetRequestBean RegisterNetRequestBean
  //-----------> 注册接口 -----------> 登录接口 -----------> 第三方登录接口
  //这3个接口现在不在底层进行同步数据
  if (NO){
    
    do {
      // 当前登录用户的最新用户信息
      LoginNetRespondBean *currentLoginUserLatestInfo = nil;
      if ([netRespondBean isKindOfClass:[LoginNetRespondBean class]]) {
        
        currentLoginUserLatestInfo = (LoginNetRespondBean *) netRespondBean;
      } else {
        
      }
      
      if (currentLoginUserLatestInfo == nil) {
        // 异常, 不应该走到这里, 走到这里证明上面的代码漏掉了会导致用户信息更新的接口
        break;
      }
      
      // 更新登录用户用户信息
      [[LoginManager sharedInstance] updateLoginUserInfo:currentLoginUserLatestInfo];
    } while (NO);
    
  }
  
  
  
}



@end
