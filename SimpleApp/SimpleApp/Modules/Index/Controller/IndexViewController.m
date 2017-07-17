//
//  IndexViewController.m
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/16.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "IndexViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <RTRootNavigationController.h>
#import "SearchViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AMapLocationKit/AMapLocationKit.h>


#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5

@interface IndexViewController ()<AMapLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *mapParentView;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (strong, nonatomic) AMapLocationManager *locationManager;

@property (copy, nonatomic) AMapLocatingCompletionBlock completionBlock;

@property (nonatomic, assign) NSInteger locateCount;

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
  
  self.locateCount = 0;
  
  [self initCompleteBlock];
  
  [self configLocationManager];
  
    //初始化地图
    MAMapView *_mapView = [[MAMapView alloc] initWithFrame:self.mapParentView.bounds];
    [self.mapParentView addSubview:_mapView];
    
    [[self.searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        SearchViewController *searchVC = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
        [self.navigationController pushViewController:searchVC animated:YES];
        
    }];
  
  //定位
  [self.locationManager stopUpdatingLocation];
  
  self.locateCount = 0;
  
  //进行单次定位
  [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
  
}

#pragma mark - Initialization

- (void)initCompleteBlock
{
  @weakify(self)
  self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
  {
    @strongify(self)
    if (error)
    {
      NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
      return;
    }
    
    //得到定位信息
    if (location)
    {
      [self updateLocation:location regeocode:regeocode serial:NO];
    }
  };
}

#pragma mark - Action Handle

- (void)configLocationManager
{
  self.locationManager = [[AMapLocationManager alloc] init];
  
  [self.locationManager setDelegate:self];
  
  //设置期望定位精度
  [self.locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
  
  //设置不允许系统暂停定位
  [self.locationManager setPausesLocationUpdatesAutomatically:NO];
  
  //设置允许在后台定位
  //[self.locationManager setAllowsBackgroundLocationUpdates:YES];
  
  //开启带逆地理连续定位
  [self.locationManager setLocatingWithReGeocode:YES];
  
  //设置定位超时时间
  [self.locationManager setLocationTimeout:DefaultLocationTimeout];
  
  //设置逆地理超时时间
  [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
}


-(void)createUI {
  
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

-(void)updateLocation:(CLLocation *)location regeocode:(AMapLocationReGeocode *)regeocode serial:(BOOL)isSerial {
  NSString *locType = isSerial ? [NSString stringWithFormat:@"连续定位完成:%d", (int)self.locateCount] : @"单次定位完成";
  
  NSMutableString *infoString = [NSMutableString stringWithFormat:@"%@\n\n回调时间:%@\n经 度:%f\n纬 度\t:%f\n精 度:%f米\n海 拔:%f米\n速 度:%f\n角 度:%f\n", locType, location.timestamp, location.coordinate.longitude, location.coordinate.latitude, location.horizontalAccuracy, location.altitude, location.speed, location.course];
  
  if (regeocode)
  {
    NSString *regeoString = [NSString stringWithFormat:@"国 家:%@\n省:%@\n市:%@\n城市编码:%@\n区:%@\n区 域:%@\n地 址:%@\n兴趣点:%@\n", regeocode.country, regeocode.province, regeocode.city, regeocode.citycode, regeocode.district, regeocode.adcode, regeocode.formattedAddress, regeocode.POIName];
    [infoString appendString:regeoString];
  }
  
  
}


#pragma mark - AMapLocationManager Delegate
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
  NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
  NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
  
  self.locateCount += 1;
  
  [self updateLocation:location regeocode:reGeocode serial:YES];
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
