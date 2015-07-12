//
//  JsonSerialization.m
//
//  Created by liu on 15-2-11.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import "NSObject+JsonReciprocity.h"
#import "JsonSerialization.h"
#import "JsonDeserialization.h"


@implementation NSObject (JsonSerialization)

- (NSString *)toJsonString {
    return [NSString jsonStringFromObject:self isPretty:NO];
}

- (NSString *)toPrettyJsonString {
    return [NSString jsonStringFromObject:self isPretty:YES];
}

@end

@implementation NSString (JsonSerialization)

+ (NSString *)jsonStringFromObject:(id)object {
    return [self jsonStringFromObject:object isPretty:NO];
}

+ (NSString *)jsonStringFromObject:(id)object isPretty:(BOOL)isPretty {
    id obj = object;
    if (![obj isKindOfClass:[NSArray class]] && ![obj isKindOfClass:[NSDictionary class]]) {
        obj = [obj toJsonDictionary];
    }
    if (![NSJSONSerialization isValidJSONObject:obj]) {
        return nil;
    }
    NSError *error = nil;
    NSJSONWritingOptions opt = isPretty ? NSJSONWritingPrettyPrinted : 0;
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:opt error:&error];
    if (error) {
        return nil;
    } else {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
}

@end