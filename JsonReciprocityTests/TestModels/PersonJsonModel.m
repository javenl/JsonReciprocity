//
//  PersonJsonModel.m
//  JVReciprocity
//
//  Created by liu on 15-5-8.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import "PersonJsonModel.h"

@implementation PersonJsonModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper {
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end
