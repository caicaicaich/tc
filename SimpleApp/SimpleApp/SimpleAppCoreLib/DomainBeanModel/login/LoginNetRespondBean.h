//
//  LoginNetRespondBean.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "BaseModel.h"
#import "GlobalConstant.h"

@class LoginData;

@interface LoginNetRespondBean : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) LoginData *data;

@end
