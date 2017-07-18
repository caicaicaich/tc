//
//  NearByViewController.m
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/18.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "NearByViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MBProgressHUD.h"
#import "NearByViewModel.h"
#import "SearchNetRespondBean.h"
#import "MJRefresh.h"
#import "UIScrollView+Refresh.h"
#import "Simpletoast.h"
#import "GDNavigationViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import "Search.h"
#import "TCLocationCell.h"
#import <RTRootNavigationController.h>

@interface NearByViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NearByViewModel *viewModel;

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation NearByViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    self.title = @"周边停车场";
    self.viewModel = [[NearByViewModel alloc] init];
    self.rt_navigationController.navigationBar.backItem.title = @"返回";
    self.navigationController.navigationBar.backItem.title = @"返回";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TCLocationCell" bundle:nil] forCellReuseIdentifier:@"TCLocationCell"];
    
    [self.viewModel.requestSearchCommand.executing subscribeNext:^(NSNumber *executing) {
        if (executing.boolValue) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        } else {
            [self.hud hideAnimated:YES];
        }
    }];
    
    [self.viewModel.requestSearchCommand.executionSignals
     subscribeNext:^(RACSignal *execution) {
         [[execution dematerialize] subscribeNext:^(SearchNetRespondBean *respondBean) {
             @strongify(self)
             [self.tableView.mj_header endRefreshing];
             [self.tableView.mj_footer endRefreshing];
             [self.tableView reloadData];
             if (self.viewModel.isLastPage) {
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
        @strongify(self)
        [self.viewModel.requestSearchCommand execute:nil];
    }];
    
    self.viewModel.name = @"停车场";
    self.viewModel.latitude = [NSString stringWithFormat:@"%lf",self.latitude];
    self.viewModel.longitude = [NSString stringWithFormat:@"%lf",self.longitude];
    [self.viewModel.requestSearchCommand execute:nil];
    
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
    return self.viewModel.searchArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCLocationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TCLocationCell"];
    [cell bindModel:self.viewModel.searchArray[indexPath.row]];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Search *searchModel = self.viewModel.searchArray[indexPath.row];
    if (searchModel == nil) {
        return;
    }
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:self.latitude longitude:self.longitude];
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:searchModel.latitude longitude:searchModel.longitude];
    GDNavigationViewController *GDNavVc = [[GDNavigationViewController alloc] init];
    GDNavVc.startPoint = startPoint;
    GDNavVc.endPoint = endPoint;
    [self.navigationController pushViewController:GDNavVc animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
    
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
