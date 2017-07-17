//
//  UploadFileMIMETypeTools.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "UploadFileMIMETypeTools.h"

@implementation UploadFileMIMETypeTools

+ (NSString *)MIMETypeFromUploadFile:(NSString *)uploadFile {
  NSString *fileExtensionName = [[uploadFile pathExtension] lowercaseString];
  
  if ([fileExtensionName isEqualToString:@"jpg"]
      || [fileExtensionName isEqualToString:@"jpeg"]) {
    return @"image/jpeg";
  } else if ([fileExtensionName isEqualToString:@"gif"]) {
    return @"image/gif";
  } else if ([fileExtensionName isEqualToString:@"png"]) {
    return @"image/png";
  } else if ([fileExtensionName isEqualToString:@"mp3"]) {
    return @"audio/mp3";
  } else {
    return @"application/octet-stream";
  }
} 

@end
