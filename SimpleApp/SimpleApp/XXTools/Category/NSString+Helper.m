//
//  NSString+Helper.m
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/10.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "NSString+Helper.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (Helper)

- (NSString*)substringFrom:(NSInteger)a to:(NSInteger)b {
  NSRange r;
  r.location = a;
  r.length = b - a;
  return [self substringWithRange:r];
}

- (NSInteger)indexOf:(NSString*)substring from:(NSInteger)starts {
  NSRange r;
  r.location = starts;
  r.length = [self length] - r.location;
  
  NSRange index = [self rangeOfString:substring options:NSLiteralSearch range:r];
  if (index.location == NSNotFound) {
    return -1;
  }
  return index.location + index.length;
}

- (NSString*)trim {
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimSpaceAndEnter{
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)startsWith:(NSString*)s {
  if([self length] < [s length]) return NO;
  return [s isEqualToString:[self substringFrom:0 to:[s length]]];
}

- (BOOL)containsString:(NSString *)aString
{
  NSRange range = [[self lowercaseString] rangeOfString:[aString lowercaseString]];
  return range.location != NSNotFound;
}

- (NSString *) md5
{
  const char *cStr = [self UTF8String];
  unsigned char result[16];
  CC_MD5( cStr, (unsigned int) strlen(cStr), result);
  return [NSString stringWithFormat:
          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
          result[0], result[1], result[2], result[3],
          result[4], result[5], result[6], result[7],
          result[8], result[9], result[10], result[11],
          result[12], result[13], result[14], result[15]
          ];
}

+ (NSString*) uniqueString
{
  CFUUIDRef	uuidObj = CFUUIDCreate(nil);
  NSString	*uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
  CFRelease(uuidObj);
  return uuidString;
}

- (NSString*) urlEncodedString { // mk_ prefix prevents a clash with a private api
  
  CFStringRef encodedCFString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                        (__bridge CFStringRef) self,
                                                                        nil,
                                                                        CFSTR("?!@#$^&%*+,:;='\"`<>()[]{}/\\| "),
                                                                        kCFStringEncodingUTF8);
  
  NSString *encodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString*) encodedCFString];
  
  if(!encodedString)
    encodedString = @"";
  
  return encodedString;
}

- (NSString*) urlDecodedString {
  
  CFStringRef decodedCFString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                        (__bridge CFStringRef) self,
                                                                                        CFSTR(""),
                                                                                        kCFStringEncodingUTF8);
  
  // We need to replace "+" with " " because the CF method above doesn't do it
  NSString *decodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString*) decodedCFString];
  return (!decodedString) ? @"" : [decodedString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
}

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
  CGSize result;
  if (!font) font = [UIFont systemFontOfSize:12];
  if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
    NSMutableDictionary *attr = [NSMutableDictionary new];
    attr[NSFontAttributeName] = font;
    if (lineBreakMode != NSLineBreakByWordWrapping) {
      NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
      paragraphStyle.lineBreakMode = lineBreakMode;
      attr[NSParagraphStyleAttributeName] = paragraphStyle;
    }
    CGRect rect = [self boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attr context:nil];
    result = rect.size;
  } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
  }
  return result;
}

- (CGFloat)widthForFont:(UIFont *)font {
  CGSize size = [self sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
  return size.width;
}

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width {
  CGSize size = [self sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
  return size.height;
}

/**
 十六进制 NSData 转 NSString
 
 @param data 十六进制 NSData
 @return NSString
 */
+ (NSString *)convertDataToHexStr:(NSData *)data {
  if (!data || [data length] == 0) {
    return @"";
  }
  NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
  
  [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
    unsigned char *dataBytes = (unsigned char*)bytes;
    for (NSInteger i = 0; i < byteRange.length; i++) {
      NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
      if ([hexStr length] == 2) {
        [string appendString:hexStr];
      } else {
        [string appendFormat:@"0%@", hexStr];
      }
    }
  }];
  
  //字符串大小写转换
  string = [NSMutableString stringWithString:[string uppercaseString]];
  
  if (string.length < 12) {
    return @"";
  }
  //拼接字符串冒号
  NSString *disposeString = @"";
  
  for (NSInteger i = 0; i< string.length/2; i++) {
    if (i != 0) {
      disposeString = [disposeString stringByAppendingString:@":"];
    }
    disposeString = [disposeString stringByAppendingString:[string substringWithRange:NSMakeRange(i*2,2)]];
  }
  
  return disposeString;
}

- (void)trimSpaceAndEnterAtTheEnd:(NSMutableString *)text {
  
  NSString *temp = nil;
  
  if (self.length == 0) {
    return;
  }
  
  NSInteger index = text.length - 1;
  NSRange range = NSMakeRange(index,1);
  temp = [text substringWithRange:range];
  if ([temp isEqualToString:@""] || [temp isEqualToString:@" "] || [temp isEqualToString:@"\r"] || [temp isEqualToString:@"\n"]) {
    [text deleteCharactersInRange:range];
    [self trimSpaceAndEnterAtTheEnd:text];
  }
}


@end
