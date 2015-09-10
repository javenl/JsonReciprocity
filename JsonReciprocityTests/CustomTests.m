//
//  CustomTests.m
//  JsonReciprocity
//
//  Created by liu on 15/8/26.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "JsonReciprocity.h"
#import "CustomObject.h"


@interface CustomTests : XCTestCase

@end

@implementation CustomTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
//    XCTAssert(YES, @"Pass");
    
    NSString *str = @"{\"code\":0,\"message\":\"\",\"data\":null}";
    
    CustomObject *object = [CustomObject objectFromJsonDict:[str toJsonDictionary]];
    NSLog(@"object %@", [object toPrettyJsonString]);
    NSLog(@"properties %@", object.propertys);
    [object setValue:@"adsf" forKey:@"test"];
//    object.test = @"ser";
    NSLog(@"object %@", [object toPrettyJsonString]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
