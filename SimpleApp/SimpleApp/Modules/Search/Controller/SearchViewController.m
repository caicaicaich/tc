//
//  SearchViewController.m
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/16.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "SearchViewController.h"
#import <RTRootNavigationController.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MBProgressHUD.h"
#import "SearchViewModel.h"
#import "NSString+isEmpty.h"
#import "Simpletoast.h"
#import "SearchNetRespondBean.h"

@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchText;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (strong, nonatomic) SearchViewModel *searchViewModel;

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  @weakify(self)
  self.searchViewModel = [[SearchViewModel alloc] init];
  
  [self.searchViewModel.requestSearchCommand.executing subscribeNext:^(NSNumber *executing) {
    if (executing.boolValue) {
      self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    } else {
      [self.hud hideAnimated:YES];
    }
  }];
  
  [self.searchViewModel.requestSearchCommand.executionSignals
   subscribeNext:^(RACSignal *execution) {
     [[execution dematerialize] subscribeNext:^(SearchNetRespondBean *respondBean) {
       
       
     } error:^(NSError *error) {
       
     }];

    
  }];
  
  
  [[self.searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    @strongify(self)
    self.searchViewModel.name = @"停车场";
    self.searchViewModel.latitude = @"39.9703452314";
    self.searchViewModel.longitude = @"116.5034008026";
    self.searchViewModel.pageNO = 1;
    self.searchViewModel.pageSize = 100;
    [self.searchViewModel.requestSearchCommand execute:nil];
  }];
  
}

- (void)createUI {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.rt_navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
