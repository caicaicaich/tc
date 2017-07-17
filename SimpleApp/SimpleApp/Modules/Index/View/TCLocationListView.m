//
//  TCLocationListView.m
//  SimpleApp
//
//  Created by jearoc on 2017/7/17.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "TCLocationListView.h"
#import "TCLocationCell.h"

@interface TCLocationListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TCLocationListView

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    self.viewModel = [[IndexViewModel alloc] init];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = self.bounds;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TCLocationCell" bundle:nil] forCellReuseIdentifier:@"TCLocationCell"];
    
    [self addSubview:self.tableView];
    
    @weakify(self);
    [RACObserve(self.viewModel, locationList) subscribeNext:^(id x) {
      @strongify(self);
      self.locationCount = self.viewModel.locationList.count;
      [self.tableView reloadData];
      
      CGPoint off = self.tableView.contentOffset;
      off.y = 0 - self.tableView.contentInset.top;
      [self.tableView setContentOffset:off animated:YES];
    }];
  }
  return self;
}

- (void)requestLocationList:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)regeocode
{
  NSDictionary *param = @{@"location":@"停车场",
                          @"latitude":[NSString stringWithFormat:@"%f",location.coordinate.latitude],
                          @"longitude":[NSString stringWithFormat:@"%f",location.coordinate.longitude]
                          };
  [self.viewModel.requestLocationListCommand execute:param];
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  self.tableView.frame = self.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

  return self.viewModel.locationList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  TCLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCLocationCell"];
  [cell bindModel:[self.viewModel.locationList objectAtIndex:indexPath.row]];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 100;
}

@end
