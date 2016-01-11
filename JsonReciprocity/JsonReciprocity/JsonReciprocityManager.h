//
//  JsonReciprocityManager.h
//  DDBaseLib
//
//  Created by liu on 15/11/18.
//  Copyright © 2015年 dingdone. All rights reserved.
//

#import <Foundation/Foundation.h>

#if DEBUG
#define JRLog(format,...) if ([JsonReciprocityManager logEnable]) NSLog(format, ##__VA_ARGS__)
#else
#define JRLog(format,...)
#endif

@interface JsonReciprocityManager : NSObject

+ (void)setLogEnable:(BOOL)enable;
+ (BOOL)logEnable;

@end
