//
//  SearchViewModel.m
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/16.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "SearchViewModel.h"
#import "AppNetworkEngineSingleton.h"
#import "AppNetworkEngineSingleton+RACSupport.h"
#import "SearchNetRequestBean.h"
#import "SearchNetRespondBean.h"

@interface SearchViewModel ()

@property (nonatomic, readwrite, strong) RACCommand *requestSearchCommand;

@property (nonatomic, readwrite, strong) RACCommand *cancelRequestSearchCommand;

@end


@implementation SearchViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

-(void)initialize {
    @weakify(self)
    self.cancelRequestSearchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    
    
}


@end
