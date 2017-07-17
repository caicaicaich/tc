//
//  IndexViewModel.m
//  SimpleApp
//
//  Created by jearoc on 2017/7/17.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "IndexViewModel.h"
#import "AppNetworkEngineSingleton.h"
#import "AppNetworkEngineSingleton+RACSupport.h"

@interface IndexViewModel ()

@property (nonatomic, readwrite, strong) RACCommand *requestLocationListCommand;

@property (nonatomic, readwrite, strong) RACCommand *cancelRequestLocationListCommand;

@property (nonatomic, readwrite, strong) NSMutableArray *locationList;

@end

@implementation IndexViewModel

- (instancetype)init {
  if (self = [super init]) {
    
    _locationList = [NSMutableArray arrayWithCapacity:0];
    [self initialize];
  }
  return self;
}

- (void)initialize {
  @weakify(self)
  self.cancelRequestLocationListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    return [RACSignal empty];
  }];
  
  self.requestLocationListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *input) {
    @strongify(self);
    
    
    SearchNetRequestBean *RequestBean = [[SearchNetRequestBean alloc] initWithName:input[@"location"]
                                                                                    pageNo:1
                                                                                  pageSize:20
                                                                                 longitude:input[@"longitude"]
                                                                                  latitude:input[@"latitude"]];
    
    return [[[[AppNetworkEngineSingleton sharedInstance] signalForNetRequestDomainBean:RequestBean] materialize] takeUntil:self.cancelRequestLocationListCommand.executionSignals];
    
  }];
  
  [self.requestLocationListCommand.executionSignals subscribeNext:^(RACSignal *execution) {
    [[execution dematerialize] subscribeNext:^(SearchNetRespondBean *respondBean) {
      @strongify(self);
      
      self.locationList = [NSMutableArray arrayWithArray:respondBean.Data];
      
    } error:^(NSError *error) {
      @strongify(self);
      
      self.locationList = self.locationList;
    }];
    
  }];
  
}


@end
