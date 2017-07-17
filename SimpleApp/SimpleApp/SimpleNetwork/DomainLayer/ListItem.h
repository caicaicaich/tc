//
//  ListItem.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "BaseModel.h"

@interface ListItem : BaseModel

// 创建时间戳 (用这个字段来做增量更新的链接标志)
@property (nonatomic, assign) long long createTime;

@end
