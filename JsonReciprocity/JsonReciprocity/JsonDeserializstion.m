//
//  JsonDeserializstion.m
//  JVReciprocity
//
//  Created by liu on 15/7/8.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import "JsonDeserialization.h"

@implementation NSString (JsonDeserialization)

-(id)toJsonMutableObject {
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        return nil;
    } else {
        return result;
    }
}

-(id)toJsonObject {
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        return nil;
    } else {
        return result;
    }
}

- (NSMutableArray *)toJsonMutableArray {
    id result = [self toJsonMutableObject];
    return [result isKindOfClass:[NSMutableArray class]] ? result : nil;
}

- (NSArray *)toJsonArray {
    id result = [self toJsonObject];
    return [result isKindOfClass:[NSArray class]] ? result : nil;
}

- (NSDictionary *)toJsonMutableDictionary {
    id result = [self toJsonMutableObject];
    return [result isKindOfClass:[NSMutableDictionary class]] ? result : nil;
}

- (NSDictionary *)toJsonDictionary {
    id result = [self toJsonObject];
    return [result isKindOfClass:[NSDictionary class]] ? result : nil;
}

@end

@implementation NSDictionary(JsonDeserialization)

+ (NSDictionary *)dictionaryFromJsonString:(NSString *)jsonString {
    return [jsonString toJsonDictionary];
}

+ (NSMutableDictionary *)mutableDictionaryFromJsonString:(NSString *)jsonString {
    return [jsonString toJsonMutableDictionary];
}

@end

@implementation NSArray(JsonDeserialization)

+ (NSArray *)arrayFromJsonString:(NSString *)jsonString {
    return [jsonString toJsonArray];
}

+ (NSMutableArray *)mutableArrayFromJsonString:(NSString *)jsonString {
    return [jsonString toJsonMutableArray];
}

@end

