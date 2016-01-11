//
//  TestObject.m
//  JsonReciprocity
//
//  Created by liu on 15/7/12.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import "TestObject.h"

@implementation TestObject

+ (NSDictionary *)customReferenceDict {
    return @{@"content_detail" : @"str"};
}

+ (BOOL)isIgnorePropertyKey:(NSString *)key {
    if ([key isEqualToString:@"test"]) {
        return YES;
    }
    return NO;
}

- (id)customFormat:(NSString *)keyPath value:(id)value {
    if ([keyPath isEqualToString:@"date1"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy/MM/dd";
        NSDate *date = [formatter dateFromString:value];
        return date;
    } else if ([keyPath isEqualToString:@"date2"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy.MM.dd";
        NSDate *date = [formatter dateFromString:value];
        return date;
    }
    return value;
}

- (NSString *)description {
    return [self toJsonString];
}

@end
