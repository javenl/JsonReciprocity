//
//  IrregularTest.m
//  JVReciprocity
//
//  Created by liu on 15-5-7.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IrregularTestModel.h"
#import "NSObject+JsonReciprocity.h"
#import "JsonReciprocity.h"

@interface IrregularTests : XCTestCase

@end

@implementation IrregularTests

- (void)testIrregular {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"irregular_key" ofType:@"json"];
    NSString *json = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    XCTAssertNotNil(json);
    
    NSDictionary *jsonDict = [json toJsonDictionary];
    IrregularTestModel *model = [IrregularTestModel objectFromJsonDict:jsonDict];
    
    XCTAssertEqual(model.id, 111);
    XCTAssertEqual(model.userId, 4096);
    XCTAssertEqual(model.carId, 1234);
    XCTAssertEqualObjects(model.exprideTime, [NSDate dateWithTimeIntervalSince1970:1430647083]);
    XCTAssertEqualObjects(model.lastDate, [NSDate dateWithTimeIntervalSince1970:1430647083]);
    XCTAssertEqualObjects(model.car, @"car");
    XCTAssertEqualObjects(model.camelCaseTest, @"this is string");
    XCTAssertEqualObjects(model.upper_case, @"upper");
}

@end
