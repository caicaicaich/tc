//
//  ICacheNetRespondBean.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ICacheNetRespondBean <NSObject>

/**
 * 缓存数据的方法(由应用网络层调用)
 *
 * @param netRequestBean   网络请求业务Bean(作为key)
 * @param netRespondBean   网络响应业务Bean(作为value)
 */
- (void)cacheNetRespondBean:(id)netRespondBean withNetRequestBean:(id)netRequestBean;

@end
