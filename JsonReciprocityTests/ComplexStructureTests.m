//
//  ComplexStructure Test.m
//  JVReciprocity
//
//  Created by liu on 15-5-7.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+JsonReciprocity.h"
#import "JsonReciprocity.h"
#import "PersonModel.h"
#import "HouseModel.h"
#import "CarModel.h"

@interface ComplexStructureTests : XCTestCase

@end

@implementation ComplexStructureTests

- (void)testExchange {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"complex" ofType:@"json"];
    NSString *json = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    XCTAssertNotNil(json);
    
    NSDictionary *jsonDict = [json toJsonDictionary];
    XCTAssertEqual([jsonDict[@"page"] integerValue], 1);
    XCTAssertEqual([jsonDict[@"total"] integerValue], 1);
    XCTAssertEqual([jsonDict[@"code"] integerValue], 200);
    XCTAssertEqualObjects(jsonDict[@"msg"], @"success");
    
    NSArray *persons = [PersonModel objectArrayFromJsonArray:jsonDict[@"data"]];
    XCTAssertEqual(persons.count, 3);
    
    PersonModel *jack = persons[0];
    XCTAssertEqual(jack.id, 1420194);
    XCTAssertEqualObjects(jack.name, @"Jack");
    XCTAssertEqual(jack.score, 88.33);
    XCTAssertEqualObjects(jack.registerDate, [NSDate dateWithTimeIntervalSince1970:1428647083]);
    XCTAssertEqual(jack.lastLoginTime, 1430642742);
    
    XCTAssertEqual(jack.cars.count, 2);
    CarModel *jackCar0 = jack.cars[0];
    XCTAssertEqualObjects(jackCar0.brand, @"benz");
    XCTAssertEqualObjects(jackCar0.num, @"A14212");
    
    CarModel *jackCar1 = jack.cars[1];
    XCTAssertEqualObjects(jackCar1.brand, @"audi");
    XCTAssertEqualObjects(jackCar1.num, @"B83143");
    
    XCTAssertEqualObjects(jack.house.address, @"China GuangZhou");
    XCTAssertEqual(jack.house.area, 95.6);
    
    XCTAssertEqual(jack.house.tags.count, 2);
    XCTAssertEqualObjects(jack.house.tags[0], @"nice");
    XCTAssertEqualObjects(jack.house.tags[1], @"comfort");
    
    
    PersonModel *tom = persons[1];
    XCTAssertEqual(tom.id, 1230794);
    XCTAssertEqualObjects(tom.name, @"Tom");
    XCTAssertEqual(tom.score, 67.24);
    XCTAssertEqualObjects(tom.registerDate, [NSDate dateWithTimeIntervalSince1970:1421647083]);
    XCTAssertEqual(tom.lastLoginTime, 1430847083);
    
    XCTAssertEqual(tom.cars.count, 2);
    CarModel *tomCar0 = tom.cars[0];
    XCTAssertEqualObjects(tomCar0.brand, @"toyota");
    XCTAssertEqualObjects(tomCar0.num, @"C03914");
    
    CarModel *tomCar1 = tom.cars[1];
    XCTAssertEqualObjects(tomCar1.brand, @"honda");
    XCTAssertEqualObjects(tomCar1.num, @"D35813");
    
    XCTAssertEqualObjects(tom.house.address, @"China Hangzhou");
    XCTAssertEqual(tom.house.area, 88.2);
    
    XCTAssertEqual(tom.house.tags.count, 2);
    XCTAssertEqualObjects(tom.house.tags[0], @"quiet");
    XCTAssertEqualObjects(tom.house.tags[1], @"good");
    
    
    PersonModel *sammi = persons[2];
    XCTAssertEqual(sammi.id, 2914834);
    XCTAssertEqualObjects(sammi.name, @"Sammi");
    XCTAssertEqual(sammi.score, 92.43);
    XCTAssertEqualObjects(sammi.registerDate, [NSDate dateWithTimeIntervalSince1970:1430647083]);
    XCTAssertEqual(sammi.lastLoginTime, 1430947083);
    
    XCTAssertEqual(sammi.cars.count, 2);
    CarModel *sammiCar0 = sammi.cars[0];
    XCTAssertEqualObjects(sammiCar0.brand, @"porsche");
    XCTAssertEqualObjects(sammiCar0.num, @"E59832");
    
    CarModel *sammiCar1 = sammi.cars[1];
    XCTAssertEqualObjects(sammiCar1.brand, @"BMW");
    XCTAssertEqualObjects(sammiCar1.num, @"F93057");
    
    XCTAssertEqualObjects(sammi.house.address, @"China Shenzhen");
    XCTAssertEqual(sammi.house.area, 103.3);
    
    XCTAssertEqual(sammi.house.tags.count, 2);
    XCTAssertEqualObjects(sammi.house.tags[0], @"convenience");
    XCTAssertEqualObjects(sammi.house.tags[1], @"luxury");

}

@end
