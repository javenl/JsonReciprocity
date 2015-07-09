//
//  JsonSerialization.h
//
//  Created by liu on 15-2-11.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JsonSerialization)

- (NSString *)toJsonString;
    
- (NSString *)toPrettyJsonString;

@end

@interface NSString (JsonSerialization)

+ (NSString *)jsonStringFromObject:(id)object;

+ (NSString *)jsonStringFromObject:(id)object isPretty:(BOOL)isPretty;

@end