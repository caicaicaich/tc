//
//  LoginNetRespondBean.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "LoginNetRespondBean.h"
#import "LoginData.h"

@implementation LoginNetRespondBean


#pragma mark -
#pragma mark - KVC
- (void)setValue:(id)value forKey:(NSString *)key {
  if ([key isEqualToString:@"data"]) {

    if ([value isKindOfClass:[LoginData class]]) {
      _data = value;
    } else if ([value isKindOfClass:[NSDictionary class]]) {
      _data = [[LoginData alloc] initWithDictionary:value];
    }
    
  } else {
  [super setValue:value forKey:key];
  }
}

@end
