//
//  LoginData.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/17.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface LoginData : BaseModel

@property (assign, nonatomic) long long userId;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *realityName;

@end
