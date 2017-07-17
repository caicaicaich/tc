//
//  UrlConstantForThisProject.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "UrlConstantForThisProject.h"

/// 主URL
//NSString *const UrlConstant_MainUrl = @"http://hzt.idoool.com";// 外网正式地址
NSString *const UrlConstant_MainUrl = @"http://112.74.206.37:8080/parking/api";// 内网测试地址
//NSString *const UrlConstant_MainUrl = @"http://101.200.216.214:8091";// 外网测试地址

/// 主Path
NSString *const UrlConstant_MainPtah = @"";

// V0.1
// 1.第三方授权登录接口
NSString *const UrlConstant_SpecialPath_oauthlogin = @"user/oauthlogin";
// 2.登出接口
NSString *const UrlConstant_SpecialPath_logout = @"user/logout";
// 3.推荐日记接口
NSString *const UrlConstant_SpecialPath_recommend = @"diary/recommend";
// 4.请求日记详情接口
NSString *const UrlConstant_SpecialPath_detailbyid = @"diary/detailbyid";
// 5.请求某天日记列表接口
NSString *const UrlConstant_SpecialPath_diary_findbydate = @"diary/findbydate";
// 6.获取日历列表的接口
NSString *const UrlConstant_SpecialPath_calendar = @"calendar";
// 7.请求用户的有效数据接口(最近20条)
NSString *const UrlConstant_SpecialPath_findbylately = @"diary/findbylately";
// 8. 发表日记接口
NSString *const UrlConstant_SpecialPath_diary = @"diary";
// 9. 获取指定日期的事件
NSString *const UrlConstant_SpecialPath_event_findbydate = @"starevent/findbydate";
// 10. 上传图片
NSString *const UrlConstant_SpecialPath_uploadimage = @"image/uploadimage";

// 保留接口
// 登录接口
NSString *const UrlConstant_SpecialPath_login = @"account/login";

NSString *const UrlConstant_SpecialPath_search = @"parking-lot/search";

// 心跳检测接口
NSString *const UrlConstant_SpecialPath_heartbeat = @"heartbeat";
// 上传音频
NSString *const UrlConstant_SpecialPath_uploadaudio = @"uploadaudio";
// 发表新帖子接口
NSString *const UrlConstant_submit_posts = @"submitposts";

@implementation UrlConstantForThisProject

@end
