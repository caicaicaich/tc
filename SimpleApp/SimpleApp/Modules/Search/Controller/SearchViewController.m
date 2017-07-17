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
#import "SearchNetRespondBean.h"
#import "ListRequestDirectionEnum.h"
#import "SearchTableViewCell.h"
#import "MJRefresh.h"
#import "UIScrollView+Refresh.h"
#import "Simpletoast.h"
#import "GDNavigationViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import "Search.h"


@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *searchText;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (strong, nonatomic) SearchViewModel *searchViewModel;

@property (strong, nonatomic) MBProgressHUD *hud;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  @weakify(self)
  self.searchViewModel = [[SearchViewModel alloc] init];
  
  
  self.searchButton.enabled = NO;
  [self.searchButton setTitle:@"取消" forState:UIControlStateNormal];
  [self.searchButton setBackgroundColor:[UIColor whiteColor]];
  [self.searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  
  
  [self.tableView registerNib:[UINib nibWithNibName:@"SearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchTableViewCell"];
  

  
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
       @strongify(self)
       [self.tableView.mj_header endRefreshing];
       [self.tableView.mj_footer endRefreshing];
       [self.tableView reloadData];
       if (self.searchViewModel.isLastPage) {
         [self.tableView.mj_footer setHidden:YES];
       } else {
         [self.tableView.mj_footer setHidden:NO];
       }
       
     } error:^(NSError *error) {
       @strongify(self)
       [self.hud hideAnimated:YES];
       [self.tableView.mj_header endRefreshing];
       [self.tableView.mj_footer endRefreshing];
       // 错误提示
       [Simpletoast showWithText:error.localizedDescription duration:2.0f];
       
     }];

    
  }];
  //上拉加载更多
  [self.tableView addRefreshFooterCallback:^{
    NSDictionary *requestDict = @{@"Direction":@(ListRequestDirectionEnum_LoadMore)};
    [self.searchViewModel.requestSearchCommand execute:requestDict];
  }];
  
  [[self.searchText rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(id x) {
    @strongify(self)
    if (self.searchText.text.length > 0) {
      self.searchButton.enabled = YES;
      [self.searchButton setBackgroundColor:[UIColor blueColor]];
      [self.searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      [self.searchButton setTitle:@"搜索" forState:UIControlStateNormal];
      
    } else {
      self.searchButton.enabled = NO;
      [self.searchButton setTitle:@"取消" forState:UIControlStateNormal];
      [self.searchButton setBackgroundColor:[UIColor whiteColor]];
      [self.searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
  }];
  
  
  [[self.searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    @strongify(self)
    if ([self.searchButton.titleLabel.text isEqualToString:@"搜索"]) {
      self.searchViewModel.name = self.searchText.text;
      self.searchViewModel.latitude = [NSString stringWithFormat:@"%lf",self.latitude];
      self.searchViewModel.longitude = [NSString stringWithFormat:@"%lf",self.longitude];
      NSDictionary *requestDict = @{@"Direction":@(ListRequestDirectionEnum_Refresh)};
      [self.searchViewModel.requestSearchCommand execute:requestDict];
      
    } else {
      [self.navigationController popViewControllerAnimated:YES];
    }
    
    
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.searchViewModel.searchArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  SearchTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SearchTableViewCell"];
  cell.searchModel = self.searchViewModel.searchArray[indexPath.row];
  return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
  Search *searchModel = self.searchViewModel.searchArray[indexPath.row];
  if (searchModel == nil) {
    return;
  }
  
  AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:39.96058159722222 longitude:116.4966021050347];
  AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:searchModel.latitude longitude:searchModel.longitude];
  GDNavigationViewController *GDNavVc = [[GDNavigationViewController alloc] init];
  GDNavVc.startPoint = startPoint;
  GDNavVc.endPoint = endPoint;
  [self.navigationController pushViewController:GDNavVc animated:YES];
  
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 80.0f;
  
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
