//
//  JsonReciprocityManager.m
//  DDBaseLib
//
//  Created by liu on 15/11/18.
//  Copyright © 2015年 dingdone. All rights reserved.
//

#import "JsonReciprocityManager.h"

@interface JsonReciprocityManager ()

@property (assign, nonatomic, readwrite) BOOL logEnable;

@end

@implementation JsonReciprocityManager

+ (void)setLogEnable:(BOOL)enable {
    [self instance].logEnable = enable;
}

+ (BOOL)logEnable {
    return [self instance].logEnable;
}

+ (JsonReciprocityManager *)instance {
    static JsonReciprocityManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JsonReciprocityManager alloc] init];
    });
    return manager;
}

@end
