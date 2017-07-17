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
#import "Search.h"

@interface SearchViewModel ()

@property (nonatomic, readwrite, strong) RACCommand *requestSearchCommand;

@property (nonatomic, readwrite, strong) RACCommand *cancelRequestSearchCommand;

@property (nonatomic, readwrite, assign) NSInteger pageNo;

@property (copy, readwrite, nonatomic) NSArray <Search *> *searchArray;

@property (strong, readwrite, nonatomic) NSMutableArray <Search *> *mutableSearchArray;

@property (assign, readwrite, nonatomic) BOOL isLastPage;


@end


@implementation SearchViewModel

- (instancetype)init {
    if (self = [super init]) {
      [self initialize];
      self.mutableSearchArray = [NSMutableArray array];
    }
    return self;
}

-(void)initialize {
    @weakify(self)
    self.cancelRequestSearchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
  
    self.requestSearchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
      @strongify(self)
      SearchNetRequestBean *searchNetRequestBean = [[SearchNetRequestBean alloc] initWithName:self.name pageNo:self.pageNO +1 pageSize:20 longitude:self.longitude latitude:self.latitude];
      
      return [[[[AppNetworkEngineSingleton sharedInstance] signalForNetRequestDomainBean:searchNetRequestBean] materialize] takeUntil:self.cancelRequestSearchCommand.executionSignals];
      
    }];
  
  [self.requestSearchCommand.executionSignals subscribeNext:^(RACSignal *execution) {
    [[execution dematerialize]
    subscribeNext:^(SearchNetRespondBean *respondBean) {
      @strongify(self)
      if (respondBean.Data != nil && respondBean.Data.count < 1) {
        self.isLastPage = YES;
      }
      self.pageNO ++;
      [self.mutableSearchArray addObjectsFromArray:respondBean.Data];
      self.searchArray = [NSArray arrayWithArray:self.mutableSearchArray];
    }];
  }];
}


@end
