//
//  ObjectSerialization.m
//  JVReciprocity
//
//  Created by liu on 15-5-8.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "JsonReciprocity.h"
#import "PersonModel.h"
#import <MGBenchmarkSession.h>
#import <MGBenchmark.h>
#import "PersonJsonModel.h"
#import "NSObject+JsonReciprocity.h"
#import "PersonMTLModel.h"
#import <Mantle/Mantle.h>
#import <NSObject+MJKeyValue.h>
#import <NSObject+MJProperty.h>

@interface ObjectSerializationTests : XCTestCase

@end

@implementation ObjectSerializationTests

- (void)testPerformanceExample {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"multi_complex" ofType:@"json"];
    NSString *json = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    XCTAssertNotNil(json);
    
    NSDictionary *jsonDict = [json toJsonDictionary];
    
    MGBenchmarkSession *session = [MGBenchmark start:@"demo"];
    
    NSInteger testTimes = 50;
    
    //JSONModel
    for (int i = 0; i < testTimes; i++) {
        NSArray *personJsonModels = [PersonJsonModel arrayOfModelsFromDictionaries:jsonDict[@"data"]];
    }
    
    [session step:@"JsonModel"];
    
    //Mantel
    for (int i = 0; i < testTimes; i++) {
        NSArray *personMTLModels = [MTLJSONAdapter modelsOfClass:[PersonMTLModel class] fromJSONArray:jsonDict[@"data"] error:nil];
//        PersonMTLModel *person = personMTLModels[0];
//        NSLog(@"person.house.address %@", person.house.address);
//        CarMTLModel *car = person.cars[0];
//        NSLog(@"car %@", car.brand);
    }
    [session step:@"Mantel"];
    
    //MJExtension
    [PersonModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"cars" : @"CarModel",
                 };
    }];
    
    [PersonModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"id": @"id",
                 @"name": @"name",
                 @"score": @"score",
                 @"registerDate": @"register_date",
                 @"lastLoginTime": @"last_login_time",
                 @"cars": @"cars",
                 @"house": @"house",
                 };
    }];
    
//    [session step:@"MJ"];
    
    for (int i = 0; i < testTimes; i++) {
        NSArray *personModels = [PersonModel objectArrayWithKeyValuesArray:jsonDict[@"data"]];
    }
    
    [session step:@"MJExtension"];
    
    for (int i = 0; i < testTimes; i++) {
        NSArray *personModels = [PersonModel objectArrayFromJsonArray:jsonDict[@"data"]];
    }
    
    [session step:@"JsonReciprocity"];
    
    [session total];
    [MGBenchmark finish:@"demo"];
    
}

@end
