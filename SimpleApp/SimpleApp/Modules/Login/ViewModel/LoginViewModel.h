//
//  LoginViewModel.h
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/16.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LoginViewModel : NSObject

@property (nonatomic, readonly, strong) RACCommand *requestLoginCommand;

@property (nonatomic, readonly, strong) RACCommand *cancelRequestLoginCommand;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *password;

@end
