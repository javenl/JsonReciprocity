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
    if ([key isEqualToString:@"test2"]) {
        return YES;
    }
    return NO;
}

+ (id)customFormat:(NSString *)keyPath value:(id)value objectClassName:(NSString *)objectClassName {
    if ([keyPath isEqualToString:@"date1"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy/MM/dd";
        NSDate *date = [formatter dateFromString:value];
        return date;
    } else if ([objectClassName isEqualToString:@"NSDate"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy.MM.dd";
        NSDate *date = [formatter dateFromString:value];
        return date;
    }
    return nil;
}
/*
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
*/
+ (NSDictionary *)convertDictFromSourceDict:(NSDictionary *)dict {
    NSMutableDictionary *convertDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [convertDict setObject:@"I change the converDict before convert" forKey:@"test"];
    return [convertDict copy];
}

+ (id)finalObjectFromConvertedObject:(TestObject *)object {
    object.test2 = @"I change the value after convert";
    return object;
}

- (NSString *)description {
    return [self toJsonString];
}

@end
