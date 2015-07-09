//
//  JsonSerializationTest.m
//  JVReciprocity
//
//  Created by liu on 15-5-8.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <JSONKit.h>
#import <MGBenchmark.h>
#import <MGBenchmarkSession.h>
#import "JsonReciprocity.h"

@interface JsonSerializationTest : XCTestCase

@end

@implementation JsonSerializationTest


- (void)testPerformanceExample {

    NSString *path = [[NSBundle mainBundle] pathForResource:@"multi_complex" ofType:@"json"];
    NSString *json = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    XCTAssertNotNil(json);

    
    MGBenchmarkSession *session = [MGBenchmark start:@"demo"];
    
    NSInteger times = 100;
    
    [session step:@"start"];
    for (int i = 0; i < times; i++) {
        NSDictionary *dict1 = [json toJsonDictionary];
    }
    
    [session step:@"JsonReciprocity"];

    for (int i = 0; i < times; i++) {
        NSDictionary *dict2 = [json objectFromJSONString];
    }
    [session step:@"JsonKit"];
    [session total];
    [MGBenchmark finish:@"demo"];

    

}

@end
