//
//  IndexViewController.m
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/16.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "IndexViewController.h"
#import <RTRootNavigationController.h>
#import "SearchViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import "TCMapView.h"
#import "TCLocationListView.h"
#import "TCIndexSearchBar.h"

#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5
#define LocationListProportion 0.4

@interface IndexViewController ()<TCMapViewDelegate>

@property (nonatomic, strong) TCMapView *mapView;

@property (nonatomic, strong) TCIndexSearchBar *searchBar;

@property (nonatomic, strong) TCLocationListView *locationListView;

@property (nonatomic, strong) UIImageView *locationButton;

@property (nonatomic, strong) UIButton *searchBottomBar;

@end

@implementation IndexViewController

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  [self configMapView];
  [self configSearchButton];
  [self configSearchBottomBar];
  [self configLocationList];
  [self configLocationButton];
  
}

#pragma mark - config ui

- (void)configMapView
{
  self.mapView = [[TCMapView alloc] initWithFrame:CGRectZero];
  self.mapView.delegate = self;
  self.mapView.frame = [UIScreen mainScreen].bounds;
  [self.view addSubview:self.mapView];
}

- (void)configSearchButton
{
  self.searchBar = [[TCIndexSearchBar alloc] initWithFrame:CGRectZero];
  self.searchBar.frame = CGRectMake(15, 30, [UIScreen mainScreen].bounds.size.width - 30, 50);
  [self.view addSubview:self.searchBar];
}

- (void)configLocationList
{
  self.locationListView = [[TCLocationListView alloc] initWithFrame:CGRectZero];
  [self.view addSubview:self.locationListView];
  
  @weakify(self);
  [self.locationListView mas_makeConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.bottom.left.right.equalTo(self.view);
    make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height * LocationListProportion);
  }];
}

- (void)configLocationButton
{
  self.locationButton = [[UIImageView alloc] init];
  self.locationButton.backgroundColor = [UIColor redColor];
  self.locationButton.userInteractionEnabled = YES;
  [self.view addSubview:self.locationButton];
  
  @weakify(self);
  [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.left.equalTo(self.view).offset(20);
    make.bottom.equalTo(self.locationListView.mas_top).offset(-20);
    make.height.mas_equalTo(30);
    make.width.mas_equalTo(30);
  }];
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationAction)];
  [self.locationButton addGestureRecognizer:tap];
}

- (void)configSearchBottomBar
{
  self.searchBottomBar = [[UIButton alloc] init];
  [self.view addSubview:self.searchBottomBar];
  self.searchBottomBar.backgroundColor = [UIColor whiteColor];
  [self.searchBottomBar setTitle:@"周边停车场" forState:UIControlStateNormal];
  [self.searchBottomBar setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
  
  @weakify(self);
  [self.searchBottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.left.right.bottom.equalTo(self.view).offset(0);
    make.height.mas_equalTo(55);
  }];
}

#pragma mark - action

- (void)locationAction
{
  [self.mapView locationOnce];
}

#pragma mark - TCMapViewDelegate

- (void)tcMapViewDidEndScrollow:(TCMapView *)mapview down:(BOOL)down
{
  if (down) {
    @weakify(self);
    [UIView animateWithDuration:0.375 animations:^{
      @strongify(self);
      [self.locationListView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
      }];
      [self.locationButton mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.locationListView.mas_top).offset(-75);
      }];
      [self.view layoutIfNeeded];
    }];
  }
}

- (void)tcMapViewLocationFinished:(TCMapView *)mapview location:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
  [self.locationListView requestLocationList:location reGeocode:reGeocode];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.rt_navigationController.navigationBar.hidden = YES;
  self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


@end
