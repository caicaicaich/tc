//
//  LoginNetRequestBean.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "LoginNetRequestBean.h"
#import "PRPDebug.h"
#import "RNAssert.h"
#import "YYkit.h"

#define tokenSalt "17f20fAcf737f2Ef58b6462443a9aBa5"

@implementation LoginNetRequestBean

-(id)initWithLoginName:(NSString *)loginName password:(NSString *)password {
  if ((self = [super init])) {
    _loginName = [loginName copy];
    _password = [password copy];
    NSString *tempToken = [[NSString alloc] initWithFormat:@"%@%@%@",loginName,password,@tokenSalt];
    _token = [tempToken sha1String];
  }
  return self;
}



@end
