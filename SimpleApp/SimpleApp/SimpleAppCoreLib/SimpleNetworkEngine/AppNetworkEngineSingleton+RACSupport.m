//
//  AppNetworkEngineSingleton+RACSupport.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/14.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "AppNetworkEngineSingleton+RACSupport.h"
#import "ErrorBean.h"

@implementation AppNetworkEngineSingleton (RACSupport)

- (RACSignal *)signalForNetRequestDomainBean:(in id)netRequestDomainBean {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        id<INetRequestHandle> netRequestHandle
        = [self requestDomainBeanWithRequestDomainBean:netRequestDomainBean successedBlock:^(id respondDomainBean) {
            [subscriber sendNext:respondDomainBean];
            [subscriber sendCompleted];
        } failedBlock:^(ErrorBean *error) {
            [subscriber sendError:error];
        }];
        
        //
        return [RACDisposable disposableWithBlock:^{
            [netRequestHandle cancel];
        }];
    }];
}

- (RACSignal *)signalForNetRequestDomainBean:(in id)netRequestDomainBean
                                  isUseCache:(in BOOL)isUseCache {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        id<INetRequestHandle> netRequestHandle
        = [self requestDomainBeanWithRequestDomainBean:netRequestDomainBean successedBlock:^(id respondDomainBean) {
            [subscriber sendNext:respondDomainBean];
            [subscriber sendCompleted];
        } failedBlock:^(ErrorBean *error) {
            [subscriber sendError:error];
        }];
        
        //
        return [RACDisposable disposableWithBlock:^{
            [netRequestHandle cancel];
        }];
    }];
}

- (RACSignal *)signalForNetRequestDomainBean:(in id)netRequestDomainBean
                 netRequestOperationPriority:(in NetRequestOperationPriority)netRequestOperationPriority {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        id<INetRequestHandle> netRequestHandle
        = [self requestDomainBeanWithRequestDomainBean:netRequestDomainBean netRequestOperationPriority:netRequestOperationPriority successedBlock:^(id respondDomainBean) {
            [subscriber sendNext:respondDomainBean];
            [subscriber sendCompleted];
        } failedBlock:^(ErrorBean *error) {
            [subscriber sendError:error];
        }];
        
        //
        return [RACDisposable disposableWithBlock:^{
            [netRequestHandle cancel];
        }];
    }];
}

- (RACSignal *)signalForNetRequestDomainBean:(in id)netRequestDomainBean
                                  isUseCache:(in BOOL)isUseCache
                 netRequestOperationPriority:(in NetRequestOperationPriority)netRequestOperationPriority {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        id<INetRequestHandle> netRequestHandle
        = [self requestDomainBeanWithRequestDomainBean:netRequestDomainBean netRequestOperationPriority:netRequestOperationPriority successedBlock:^(id respondDomainBean) {
            [subscriber sendNext:respondDomainBean];
            [subscriber sendCompleted];
        } failedBlock:^(ErrorBean *error) {
            [subscriber sendError:error];
        }];
        
        //
        return [RACDisposable disposableWithBlock:^{
            [netRequestHandle cancel];
        }];
    }];
}

@end
