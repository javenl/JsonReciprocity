//
//  PersonMTLModel.m
//  JVReciprocity
//
//  Created by liu on 15-5-8.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import "PersonMTLModel.h"

@implementation PersonMTLModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id": @"id",
             @"name": @"name",
             @"score": @"score",
             @"registerDate": @"register_date",
             @"lastLoginTime": @"last_login_time",
             @"cars": @"cars",
             @"house": @"house",
             };
}

+ (NSValueTransformer *)houseJSONTransformer {
//    return [MTLJSONAdapter dictionaryTransformerWithModelClass:HouseMTLModel.class];
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:HouseMTLModel.class];
}

+ (NSValueTransformer *)carsJSONTransformer {
//    return [MTLJSONAdapter dictionaryTransformerWithModelClass:CarMTLModel.class];
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:CarMTLModel.class];
}


@end
