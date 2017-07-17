//
//  ListNetRequestBean.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListRequestDirectionEnum.h"

@interface ListNetRequestBean : NSObject

// 定位锚点ID
@property (nonatomic, copy, readonly) NSString *anchorId;
// 以锚点为基准, 请求数据的方向
@property (nonatomic, assign, readonly) ListRequestDirectionEnum direction;

#pragma mark -
#pragma mark - 构造方法

- (instancetype)initWithAnchorId:(NSString *)anchorId direction:(ListRequestDirectionEnum)direction;

@end
