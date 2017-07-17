//
//  GDNavigationViewController.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/17.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "GDNavigationViewController.h"
#import "SpeechSynthesizer.h"
#import <RTRootNavigationController.h>
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface GDNavigationViewController ()<AMapNaviDriveManagerDelegate, AMapNaviDriveViewDelegate>

@property (nonatomic, strong) AMapNaviDriveManager *driveManager;

@property (nonatomic, strong) AMapNaviDriveView *driveView;

@end

@implementation GDNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
  //初始化AMapNaviDriveManager
  if (self.driveManager == nil)
  {
    self.driveManager = [[AMapNaviDriveManager alloc] init];
    [self.driveManager setDelegate:self];
  }
  
  //初始化AMapNaviDriveView
  if (self.driveView == nil)
  {
    self.driveView = [[AMapNaviDriveView alloc] initWithFrame:self.view.bounds];
    [self.driveView setDelegate:self];
  }
  
  //将AMapNaviManager与AMapNaviDriveView关联起来
  [self.driveManager addDataRepresentative:self.driveView];
  //将AManNaviDriveView显示出来
  [self.view addSubview:self.driveView];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.rt_navigationController.navigationBar.hidden = YES;
  self.navigationController.navigationBar.hidden = YES;
  self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
  self.fd_interactivePopDisabled = YES;
  self.rt_navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  //路径规划
  [self.driveManager calculateDriveRouteWithStartPoints:@[self.startPoint]
                                              endPoints:@[self.endPoint]
                                              wayPoints:nil
                                        drivingStrategy:AMapNaviDrivingStrategySingleDefault];
}

//路径规划成功后，开始模拟导航
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
  [self.driveManager startGPSNavi];
}

-(BOOL)driveManagerIsNaviSoundPlaying:(AMapNaviDriveManager *)driveManager
{
  return [[SpeechSynthesizer sharedSpeechSynthesizer] isSpeaking];
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
  NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
  
  [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}



#pragma mark

- (void) driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView {
  [self.driveManager stopNavi];
  if([[SpeechSynthesizer sharedSpeechSynthesizer] isSpeaking])
  [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
  [self.navigationController popViewControllerAnimated:YES];
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
