//
//  HouseMTLModel.m
//  JVReciprocity
//
//  Created by liu on 15-5-8.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import "HouseMTLModel.h"

@implementation HouseMTLModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"address": @"address",
             @"area": @"area",
             @"tags": @"tags",
             };
}

@end
