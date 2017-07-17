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

@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchText;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  @weakify(self)
  [[self.searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    @strongify(self)
    
    
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
