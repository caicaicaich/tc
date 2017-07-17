//
//  SimpleObjectSerialization.h
//  SimpleApp
//
//  Created by idoplay_cch on 2017/7/11.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import <Foundation/Foundation.h>


extern void SimpleSerializeObject(id object, NSString *key, NSString *filePath);

extern id SimpleDeserializeObject(NSString *key, NSString *filePath);

@interface SimpleObjectSerialization : NSObject

@end
