//
//  SimpleTypeTest.m
//  JVReciprocity
//
//  Created by liu on 15-5-7.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SimpleTypeTestModel.h"
#import "NSObject+JsonReciprocity.h"
#import "JsonReciprocity.h"

@interface SimpleTypeTests : XCTestCase

@end

@implementation SimpleTypeTests

- (void)testSimpleType {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"simple_type" ofType:@"json"];
    NSString *json = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    XCTAssertNotNil(json);
    
    
    NSDictionary *jsonDict = [json toJsonDictionary];
    SimpleTypeTestModel *model = [SimpleTypeTestModel objectFromJsonDict:jsonDict];
    
    XCTAssertEqual(model.shortNumber, 121);
    XCTAssertEqual(model.intNumber,12);
    XCTAssertEqual(model.longNumber, 12124);
    XCTAssertEqual(model.integerNumber, 12124);
    XCTAssertEqual([model.numberInt integerValue], 12124);
    
    XCTAssertEqual(model.floatNumber, 12.12f);
    XCTAssertEqual(model.doubleNumber, 121231312.124);
    XCTAssertEqual(model.cgfloatNumber, 121231312.124);
    XCTAssertEqual([model.numberFloat doubleValue], 121231312.124);
    
    XCTAssertEqual(model.boolYES, true);
    XCTAssertEqual(model.boolNum, true);
    XCTAssertEqual([model.numberBool boolValue], false);
    
    XCTAssertEqual(model.timestamp, 1430647083);
    
    XCTAssertEqualObjects(model.date, [NSDate dateWithTimeIntervalSince1970:1430647083]);
    
    XCTAssertEqualObjects(model.string, @"this is string.");
    XCTAssertEqualObjects(model.url.absoluteString, @"http://www.baidu.com");
}

@end
