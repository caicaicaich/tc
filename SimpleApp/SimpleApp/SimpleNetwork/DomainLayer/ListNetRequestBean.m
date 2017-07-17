//
//  ListNetRequestBean.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "ListNetRequestBean.h"
#import "PRPDebug.h"


@implementation ListNetRequestBean

- (instancetype)initWithAnchorId:(NSString *)anchorId direction:(ListRequestDirectionEnum)direction {
  
  if ((self = [super init])) {
    _anchorId = [anchorId copy];
    _direction = direction;
  }
  
  return self;
}

- (NSString *)description {
  return descriptionForDebug(self);
}

@end
