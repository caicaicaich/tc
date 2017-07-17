//
//  TCMapView.m
//  SimpleApp
//
//  Created by jearoc on 2017/7/17.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "TCMapView.h"

#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5

@interface TCMapView ()<AMapLocationManagerDelegate,MAMapViewDelegate>

@property (nonatomic, strong, readwrite) MAMapView *map;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, assign) NSInteger locateCount;

@property (nonatomic) CLLocationCoordinate2D centerCoordinate;

@end

@implementation TCMapView

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    
    [AMapServices sharedServices].enableHTTPS = YES;
    
    self.map = [[MAMapView alloc] initWithFrame:CGRectMake(0,
                                                           0,
                                                           frame.size.width,
                                                           frame.size.height)];
    self.map.delegate = self;
    self.map.zoomLevel = 15.1;
    self.map.showsCompass = NO;
    self.map.showsUserLocation = YES;
    self.map.userTrackingMode = MAUserTrackingModeFollow;
    [self addSubview:self.map];
    
    self.locateCount = 0;
  }
  return self;
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction
{
  if (wasUserAction) {
    self.centerCoordinate = mapView.centerCoordinate;
  }
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction
{
  if (wasUserAction) {
    CGFloat oldlatitude  = self.centerCoordinate.latitude;
    CGFloat oldlongitude = self.centerCoordinate.longitude;
    
    CGFloat newlatitude  = mapView.centerCoordinate.latitude;
    CGFloat newlongitude = mapView.centerCoordinate.longitude;
    
    CGFloat xlat = newlatitude - oldlatitude;
    CGFloat xlon = fabs(newlongitude - oldlongitude);
    
    if (xlat > 0 && (fabs(xlat)/xlon)>0.7) {
      if (self.delegate && [self.delegate respondsToSelector:@selector(tcMapViewDidEndScrollow:down:)]) {
        [self.delegate tcMapViewDidEndScrollow:self down:YES];
      }
    }else{
      if (self.delegate && [self.delegate respondsToSelector:@selector(tcMapViewDidEndScrollow:down:)]) {
        [self.delegate tcMapViewDidEndScrollow:self down:NO];
      }
    }
  }
}

#pragma mark - LocationManager

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

- (BOOL)requestLocationWithReGeocode:(BOOL)withReGeocode completionBlock:(AMapLocatingCompletionBlock)completionBlock
{
  [self stopUpdatingLocation];
  return [self.locationManager requestLocationWithReGeocode:withReGeocode
                                            completionBlock:completionBlock];
}

- (void)startUpdatingLocation
{
  [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
  [self.locationManager stopUpdatingLocation];
}

#pragma mark - AMapLocationManagerDelegate

/**
 *  @brief 当定位发生错误时，会调用代理的此方法。
 *  @param manager 定位 AMapLocationManager 类。
 *  @param error 返回的错误，参考 CLError 。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
  
}

/**
 *  @brief 连续定位回调函数.注意：如果实现了本方法，则定位信息不会通过amapLocationManager:didUpdateLocation:方法回调。
 *  @param manager 定位 AMapLocationManager 类。
 *  @param location 定位结果。
 *  @param reGeocode 逆地理信息。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
  self.locateCount += 1;
  [self updateLocation:location regeocode:reGeocode serial:YES];
  [self.map setCenterCoordinate:location.coordinate animated:YES];
  [self.map setZoomLevel:15.1 animated:YES];
  if (self.delegate && [self.delegate respondsToSelector:@selector(tcMapViewLocationFinished:location:reGeocode:)]) {
    [self.delegate tcMapViewLocationFinished:self location:location reGeocode:reGeocode];
  }
}

/**
 *  @brief 定位权限状态改变时回调函数
 *  @param manager 定位 AMapLocationManager 类。
 *  @param status 定位权限状态。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
  
}

/**
 *  @brief 开始监控region回调函数
 *  @param manager 定位 AMapLocationManager 类。
 *  @param region 开始监控的region。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didStartMonitoringForRegion:(AMapLocationRegion *)region
{
  
}

/**
 *  @brief 进入region回调函数
 *  @param manager 定位 AMapLocationManager 类。
 *  @param region 进入的region。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didEnterRegion:(AMapLocationRegion *)region
{
  
}

/**
 *  @brief 离开region回调函数
 *  @param manager 定位 AMapLocationManager 类。
 *  @param region 离开的region。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didExitRegion:(AMapLocationRegion *)region
{
  
}

/**
 *  @brief 查询region状态回调函数
 *  @param manager 定位 AMapLocationManager 类。
 *  @param state 查询的region的状态。
 *  @param region 查询的region。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didDetermineState:(AMapLocationRegionState)state forRegion:(AMapLocationRegion *)region
{
  
}

/**
 *  @brief 监控region失败回调函数
 *  @param manager 定位 AMapLocationManager 类。
 *  @param region 失败的region。
 *  @param error 错误信息，参考 AMapLocationErrorCode 。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager monitoringDidFailForRegion:(AMapLocationRegion *)region withError:(NSError *)error
{
  
}

-(void)updateLocation:(CLLocation *)location regeocode:(AMapLocationReGeocode *)regeocode serial:(BOOL)isSerial {
  NSString *locType = isSerial ? [NSString stringWithFormat:@"连续定位完成:%d", (int)self.locateCount] : @"单次定位完成";
  
  NSMutableString *infoString = [NSMutableString stringWithFormat:@"%@\n\n回调时间:%@\n经 度:%f\n纬 度\t:%f\n精 度:%f米\n海 拔:%f米\n速 度:%f\n角 度:%f\n", locType, location.timestamp, location.coordinate.longitude, location.coordinate.latitude, location.horizontalAccuracy, location.altitude, location.speed, location.course];
  
  if (regeocode)
  {
    NSString *regeoString = [NSString stringWithFormat:@"国 家:%@\n省:%@\n市:%@\n城市编码:%@\n区:%@\n区 域:%@\n地 址:%@\n兴趣点:%@\n", regeocode.country, regeocode.province, regeocode.city, regeocode.citycode, regeocode.district, regeocode.adcode, regeocode.formattedAddress, regeocode.POIName];
    [infoString appendString:regeoString];
  }
  NSLog(@"%@",infoString);
  
}

#pragma mark - 

- (void)didMoveToSuperview
{
  [super didMoveToSuperview];
  [self configLocationManager];
  __weak typeof(self) ws = self;
  [self requestLocationWithReGeocode:YES
                     completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
                       if (error) return;
                       
                       [ws updateLocation:location regeocode:regeocode serial:YES];
                       [ws.map setCenterCoordinate:location.coordinate animated:YES];
                       [ws.map setZoomLevel:15.1 animated:YES];
                       if (ws.delegate && [ws.delegate respondsToSelector:@selector(tcMapViewLocationFinished:location:reGeocode:)]) {
                         [ws.delegate tcMapViewLocationFinished:ws location:location reGeocode:regeocode];
                       }
                     }];
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  self.map.frame = self.bounds;
}

#pragma mark - 

- (void)locationOnce
{
  __weak typeof(self) ws = self;
  [self requestLocationWithReGeocode:YES
                     completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
                       if (error) return;
                       
                       [ws updateLocation:location regeocode:regeocode serial:YES];
                       [ws.map setCenterCoordinate:location.coordinate animated:YES];
                       [ws.map setZoomLevel:15.1 animated:YES];
                       if (ws.delegate && [ws.delegate respondsToSelector:@selector(tcMapViewLocationFinished:location:reGeocode:)]) {
                         [ws.delegate tcMapViewLocationFinished:ws location:location reGeocode:regeocode];
                       }
                     }];
}

@end
