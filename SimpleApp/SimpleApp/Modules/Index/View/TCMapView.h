//
//  TCMapView.h
//  SimpleApp
//
//  Created by jearoc on 2017/7/17.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@class TCMapView;

@protocol TCMapViewDelegate <NSObject>

@optional

- (void)tcMapViewDidEndScrollow:(TCMapView *)mapview down:(BOOL)down;

- (void)tcMapViewLocationFinished:(TCMapView *)mapview location:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode;

@end

@interface TCMapView : UIView

@property (nonatomic, weak) id<TCMapViewDelegate> delegate;

@property (nonatomic, strong, readonly) MAMapView *map;

- (void)locationOnce;

@end
