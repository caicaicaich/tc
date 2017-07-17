//
//  ListRequestDirectionEnum.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#ifndef ListRequestDirectionEnum_h
#define ListRequestDirectionEnum_h

// 列表类接口, 请求方向(一个下拉刷新, 一个上拉加载更多)
typedef NS_ENUM(NSInteger, ListRequestDirectionEnum) {
  ListRequestDirectionEnum_Refresh  = 0, // 刷新
  ListRequestDirectionEnum_LoadMore = 1  // 加载更多
};


#endif /* ListRequestDirectionEnum_h */
