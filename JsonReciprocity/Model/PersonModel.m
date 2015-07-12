//
//  Person.m
//  JVReciprocity
//
//  Created by liu on 15-5-7.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import "PersonModel.h"
#import "CarModel.h"

@implementation PersonModel

+ (NSDictionary *)classReferenceDictForArray {
    return @{@"cars": [CarModel class]};
}

+ (NSDictionary *)customReferenceDict {
    return @{
             @"id": @"id",
             @"name": @"name",
             @"score": @"score",
             @"register_date": @"registerDate",
             @"last_login_time": @"lastLoginTime",
             @"cars": @"cars",
             @"house": @"house",
             };
}

- (NSString *)description {
    return [NSString jsonStringFromObject:self isPretty:YES];
}

@end
