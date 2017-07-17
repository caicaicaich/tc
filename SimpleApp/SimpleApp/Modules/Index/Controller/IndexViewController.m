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
#import "TCPointAnnotation.h"
#import "UserPointAnnotation.h"
#import "SearchViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "GDNavigationViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import "NearByViewController.h"

#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5
#define LocationListProportion 0.4

@interface IndexViewController ()<TCMapViewDelegate>

@property (nonatomic, strong) TCMapView *mapView;

@property (nonatomic, strong) TCIndexSearchBar *searchBar;

@property (nonatomic, strong) TCLocationListView *locationListView;

@property (nonatomic, strong) UIButton *locationButton;

@property (nonatomic, strong) UIButton *searchBottomBar;

@property (nonatomic, assign) double latitude;

@property (nonatomic, assign) double longitude;

@end

@implementation IndexViewController

- (void)viewDidLoad {
  
  [super viewDidLoad];
  self.longitude = 0.0;
  self.latitude = 0.0;
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
  
  self.searchBar.userInteractionEnabled = YES;
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchController)];
  [self.searchBar addGestureRecognizer:tap];
}

- (void)configLocationList
{
  self.locationListView = [[TCLocationListView alloc] initWithFrame:CGRectZero];
  [self.view addSubview:self.locationListView];
  
  @weakify(self);
  self.locationListView.click = ^(double longitude, double latitude) {
      @strongify(self)
      if (self.longitude == 0.0f && self.latitude == 0.0f) {
          return;
      }
      GDNavigationViewController *GDNavVC = [[GDNavigationViewController alloc] init];
      AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:self.latitude longitude:self.longitude];
      AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:latitude longitude:longitude];
      GDNavVC.startPoint = startPoint;
      GDNavVC.endPoint = endPoint;
      [self.navigationController  pushViewController:GDNavVC animated:YES];
  };
    
    
  [self.locationListView mas_makeConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.bottom.left.right.equalTo(self.view);
    make.height.mas_equalTo(0);
  }];
  
  [RACObserve(self.locationListView, locationCount) subscribeNext:^(id x) {
    @strongify(self);
    [UIView animateWithDuration:0.375 animations:^{
      @strongify(self);
      if (self.locationListView.locationCount == 0) {
        [self.locationListView mas_updateConstraints:^(MASConstraintMaker *make) {
          make.height.mas_equalTo(0);
        }];
        [self.locationButton mas_updateConstraints:^(MASConstraintMaker *make) {
          @strongify(self);
          make.bottom.equalTo(self.locationListView.mas_top).offset(-75);
        }];
      }else{
        if (self.locationListView.locationCount > 3) {
          [self.locationListView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(300);
          }];
          [self.locationButton mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.bottom.equalTo(self.locationListView.mas_top).offset(-20);
          }];
        }else{
          [self.locationListView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.locationListView.locationCount * 100);
          }];
          [self.locationButton mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.bottom.equalTo(self.locationListView.mas_top).offset(-20);
          }];
        }
      }
      [self.view layoutIfNeeded];
    }];
  }];
  
  [RACObserve(self.locationListView.viewModel, locationList) subscribeNext:^(id x) {
    @strongify(self);
    [self.mapView removeAllAnnotations];
    __block NSMutableArray *anns = [NSMutableArray arrayWithCapacity:0];
    
    [self.locationListView.viewModel.locationList enumerateObjectsUsingBlock:^(Search * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      TCPointAnnotation *pointAnnotation = [[TCPointAnnotation alloc] init];
      pointAnnotation.coordinate = CLLocationCoordinate2DMake(obj.latitude , obj.longitude);
      [anns addObject:pointAnnotation];
    }];
    
    [self.mapView addAnnotations:anns];
  }];
}

- (void)configLocationButton
{
  self.locationButton = [[UIButton alloc] init];
  self.locationButton.userInteractionEnabled = YES;
  [self.locationButton setImage:[UIImage imageNamed:@"shouye_dingwei"] forState:UIControlStateNormal];
  [self.locationButton setImage:[UIImage imageNamed:@"shouye_dingwei_selected"] forState:UIControlStateHighlighted];
  [self.view addSubview:self.locationButton];
  
  @weakify(self);
  [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
    @strongify(self);
    make.left.equalTo(self.view).offset(20);
    make.bottom.equalTo(self.locationListView.mas_top).offset(-75);
    make.height.mas_equalTo(30);
    make.width.mas_equalTo(30);
  }];
  
  [self.locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
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
  
  [self.searchBottomBar addTarget:self action:@selector(nearByController) forControlEvents:UIControlEventTouchUpInside];

}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.rt_navigationController.navigationBar.hidden = YES;
  self.navigationController.navigationBar.hidden = YES;
  self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
  self.fd_interactivePopDisabled = YES;
  self.rt_navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

#pragma mark - action

- (void)searchController
{
    if (self.longitude == 0.0f && self.latitude == 0.0f) {
        return;
    }
  SearchViewController *search = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
  search.latitude = self.latitude;
  search.longitude = self.longitude;
  [self.navigationController pushViewController:search animated:YES];
}

- (void)nearByController
{
    if (self.longitude == 0.0f && self.latitude == 0.0f) {
        return;
    }
    NearByViewController *nearByVC = [[NearByViewController alloc] initWithNibName:@"NearByViewController" bundle:nil];
    nearByVC.latitude = self.latitude;
    nearByVC.longitude = self.longitude;
    [self.navigationController pushViewController:nearByVC animated:YES];
}

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
  CLLocationCoordinate2D coordinate=location.coordinate;
  self.longitude = coordinate.longitude;
  self.latitude = coordinate.latitude;
  [self.locationListView requestLocationList:location reGeocode:reGeocode];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


@end
