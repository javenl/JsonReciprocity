//
//  JVReciprocityTests.m
//  JVReciprocityTests
//
//  Created by liu on 15-3-5.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSObject+JsonReciprocity.h"
#import "JsonSerialization.h"
#import "PersonModel.h"

@interface ExchangeEachTests : XCTestCase

@end

@implementation ExchangeEachTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testExchange {
    PersonModel *jack = [PersonModel new];
    jack.id = 1420194;
    jack.name = @"jack";
    jack.score = 88.33;
    jack.registerDate = [NSDate dateWithTimeIntervalSince1970:1421647083];
    jack.lastLoginTime = 1430947083;
    
    PersonModel *tom = [PersonModel new];
    tom.id = 1420781;
    tom.name = @"Tom";
    tom.score = 67.24;
    tom.registerDate = [NSDate dateWithTimeIntervalSince1970:1421632461];
    tom.lastLoginTime = 1430945653;
    
    PersonModel *sam = [PersonModel new];
    sam.id = 1419853;
    sam.name = @"Sam";
    sam.score = 92.43;
    sam.registerDate = [NSDate dateWithTimeIntervalSince1970:1421659382];
    sam.lastLoginTime = 1430974902;
    
    NSArray *srcPersons = @[jack, tom, sam];
//    NSString *jsonString = [srcPersons toJsonString];
//    NSLog(@"%@", jsonString);
    
    NSArray *jsonArray = @[];
    for (PersonModel *person in srcPersons) {
        NSDictionary *personDict = [person toJsonDictionary];
        XCTAssertEqual(personDict[@"id"], @(person.id));
        XCTAssertEqual(personDict[@"name"], person.name);
//        NSLog(@"score %@, score %@", personDict[@"score"], @(person.score));
        XCTAssertEqual([personDict[@"score"] doubleValue], person.score);
        XCTAssertEqual([personDict[@"registerDate"] doubleValue], person.registerDate.timeIntervalSince1970);
        jsonArray = [jsonArray arrayByAddingObject:personDict];
    }
    
    NSLog(@"jsonString %@", [jsonArray toJsonString]);
    
    NSArray *desPersons = [PersonModel objectArrayFromJsonArray:jsonArray];
    XCTAssertEqual(desPersons.count, 3);
    for (int i = 0; i < desPersons.count; i++) {
        PersonModel *srcPerson = srcPersons[i];
        PersonModel *desPerson = desPersons[i];
        XCTAssertEqual(srcPerson.id, desPerson.id);
        XCTAssertEqual(srcPerson.name, desPerson.name);
        XCTAssertEqual(srcPerson.score, desPerson.score);
        XCTAssertEqual(srcPerson.registerDate, desPerson.registerDate);
        XCTAssertEqual(srcPerson.lastLoginTime, desPerson.lastLoginTime);
    }
    
}

@end