//
//  LoginViewModel.m
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/16.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "LoginViewModel.h"
#import "AppNetworkEngineSingleton.h"
#import "AppNetworkEngineSingleton+RACSupport.h"
#import "LoginNetRespondBean.h"
#import "LoginNetRequestBean.h"
#import "LoginManager.h"

@interface LoginViewModel ()

@property (nonatomic, readwrite, strong) RACCommand *requestLoginCommand;

@property (nonatomic, readwrite, strong) RACCommand *cancelRequestLoginCommand;

@end

@implementation LoginViewModel

- (instancetype)init {
    if (self = [super init]) {
        
        [self initialize];
    }
    return self;
}

- (void)initialize {
    @weakify(self)
    self.cancelRequestLoginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    
    self.requestLoginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *input) {
        @strongify(self)
        LoginNetRequestBean *loginNetRequestBean = [[LoginNetRequestBean alloc] initWithLoginName:self.phone password:self.password];
        
        return [[[[AppNetworkEngineSingleton sharedInstance] signalForNetRequestDomainBean:loginNetRequestBean] materialize] takeUntil:self.cancelRequestLoginCommand.executionSignals];
        
    }];
    
}



@end
