//
//  Header.h
//  JVReciprocity
//
//  Created by liu on 15/7/8.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JsonDeserialization)

- (NSArray *)toJsonArray;

- (NSMutableArray *)toJsonMutableArray;

- (NSDictionary *)toJsonDictionary;

- (NSMutableDictionary *)toJsonMutableDictionary;

@end

@interface NSDictionary (JsonDeserialization)

+ (NSDictionary *)dictionaryFromJsonString:(NSString *)jsonString;

+ (NSMutableDictionary *)mutableDictionaryFromJsonString:(NSString *)jsonString;

@end

@interface NSArray (JsonDeserialization)

+ (NSArray *)arrayFromJsonString:(NSString *)jsonString;

+ (NSMutableArray *)mutableArrayFromJsonString:(NSString *)jsonString;

@end

