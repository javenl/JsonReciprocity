//
//  ViewController.m
//  JsonReciprocity
//
//  Created by liu on 15/7/9.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import "ViewController.h"
#import "JsonReciprocity.h"
#import "PersonModel.h"
#import "CarModel.h"
#import "TestObject.h"
#import "HouseModel.h"

@interface ViewController ()

@property (strong, nonatomic) UIButton *btn1;
@property (strong, nonatomic) UIButton *btn2;
@property (strong, nonatomic) UIButton *btn3;
@property (strong, nonatomic) UIButton *btn4;
@property (strong, nonatomic) UIButton *btn5;
@property (strong, nonatomic) UIButton *btn6;
@property (strong, nonatomic) UIButton *btn7;
@property (strong, nonatomic) UIButton *btn8;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.btn1 = [self btnWithTitle:@"JsonString -> JsonDictionary" target:self action:@selector(jsonStringToJsonDictionary)];
    self.btn1.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 40);
    [self.view addSubview:self.btn1];
    
    self.btn2 = [self btnWithTitle:@"JsonDictionary -> JsonObject" target:self action:@selector(jsonDictionaryToJsonObject)];
    self.btn2.frame = CGRectMake(0, 64+60*1, CGRectGetWidth(self.view.frame), 40);
    [self.view addSubview:self.btn2];
    
    self.btn3 = [self btnWithTitle:@"JsonString -> JsonObject" target:self action:@selector(jsonStringToJsonObject)];
    self.btn3.frame = CGRectMake(0, 64+60*2, CGRectGetWidth(self.view.frame), 40);
    [self.view addSubview:self.btn3];
    
    self.btn4 = [self btnWithTitle:@"JsonOject -> JsonDictionary" target:self action:@selector(jsonOjectToJsonDictionary)];
    self.btn4.frame = CGRectMake(0, 64+60*3, CGRectGetWidth(self.view.frame), 40);
    [self.view addSubview:self.btn4];
    
    self.btn5 = [self btnWithTitle:@"JsonDictionary -> JsonString" target:self action:@selector(jsonDictionaryToJsonString)];
    self.btn5.frame = CGRectMake(0, 64+60*4, CGRectGetWidth(self.view.frame), 40);
    [self.view addSubview:self.btn5];
    
    self.btn6 = [self btnWithTitle:@"JsonObject -> JsonString" target:self action:@selector(jsonObjectToJsonString)];
    self.btn6.frame = CGRectMake(0, 64+60*5, CGRectGetWidth(self.view.frame), 40);
    [self.view addSubview:self.btn6];
    
    self.btn7 = [self btnWithTitle:@"JsonString -> JsonObjectArray" target:self action:@selector(jsonStringToJsonObjectArray)];
    self.btn7.frame = CGRectMake(0, 64+60*6, CGRectGetWidth(self.view.frame), 40);
    [self.view addSubview:self.btn7];
    
    self.btn8 = [self btnWithTitle:@"JsonReciprocityDelegateTest" target:self action:@selector(jsonReciprocityDelegateDemo)];
    self.btn8.frame = CGRectMake(0, 64+60*7, CGRectGetWidth(self.view.frame), 40);
    [self.view addSubview:self.btn8];
    
    
}

- (UIButton *)btnWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
} 

#pragma mark - JsonString -> JsonDictionary

- (void)jsonStringToJsonDictionary {
    NSString *jsonString = @"\
    {\
        \"id\": 1420194,\
        \"name\" : \"Jack\",\
        \"score\" : 88.33,\
        \"register_date\" : 1428647083,\
        \"last_login_time\" : 1430642742,\
        \"house\": {\
            \"address\": \"GuangZhou China\",\
            \"area\": 95.6,\
            \"tags\":[\
                \"nice\",\
                \"comfort\"\
            ]}\
        },\
        \"cars\":[{\
            \"brand\":\"benz\",\
            \"num\":\"A14212\"\
        }]\
    }";
    NSDictionary *jsonDictionary = [jsonString toJsonDictionary];
    
    NSLog(@"jsonString: %@", jsonString);
    NSLog(@"jsonDictionary: %@", jsonDictionary);
}

#pragma mark - JsonDictionary -> JsonObject

- (void)jsonDictionaryToJsonObject {
    NSDictionary *jsonDictionary = @{
                                     @"id":@"1420194",
                                     @"name"  :@"Jack",
                                     @"score" : @"88.33",
                                     @"register_date": @"1428647083",
                                     @"last_login_time" : @"1430642742",
                                     @"house" : @{
                                             @"address" : @"GuangZhou China",
                                             @"area" : @(95.6),
                                             @"tags" : @[@"nice",
                                                         @"comfort"]
                                             },
                                     @"cars" : @[@{
                                                  @"brand":@"benz",
                                                  @"num":@"A14212"
                                                  }]
                                     };
    PersonModel *personModel = [PersonModel objectFromJsonDict:jsonDictionary];
    
    NSLog(@"jsonDictionary: %@", jsonDictionary);
    NSLog(@"jsonObject: %@", personModel);
}


#pragma mark - JsonString -> JsonObject

- (void)jsonStringToJsonObject {
    NSString *jsonString = @"\
    {\
    \"id\": 1420194,\
    \"name\" : \"Jack\",\
    \"score\" : 88.33,\
    \"register_date\" : 1428647083,\
    \"last_login_time\" : 1430642742,\
    \"house\": {\
        \"address\": \"GuangZhou China\",\
        \"area\": 95.6,\
        \"tags\":[\
            \"nice\",\
            \"comfort\"\
        ]\
    },\
    \"cars\":[{\
        \"brand\":\"benz\",\
        \"num\":\"A14212\"\
    }]\
    }";
    PersonModel *personModel = [PersonModel objectFromJsonDict:[jsonString toJsonDictionary]];
    NSLog(@"jsonString: %@", jsonString);
    NSLog(@"jsonModel: %@", personModel);
}

#pragma mark - JsonObject -> JsonDictionary

- (void)jsonOjectToJsonDictionary {
    PersonModel *personModel = [[PersonModel alloc] init];
    personModel.id = 1420194;
    personModel.name = @"Jack";
    personModel.score = 88.33;
    personModel.registerDate = [NSDate dateWithTimeIntervalSince1970:1428647083];
    HouseModel *house = [[HouseModel alloc] init];
    house.address = @"GuangZhou China";
    house.area = 95.6;
    house.tags = @[@"nice", @"comfort"];
    personModel.house = house;
    CarModel *car = [[CarModel alloc] init];
    car.brand = @"benz";
    car.num = @"A14212";
    personModel.cars = @[car];
    
    NSDictionary *jsonDictionary = [personModel toJsonDictionary];
    
    NSLog(@"jsonObject: %@", personModel);
    NSLog(@"jsonDictionary: %@", jsonDictionary);
}



#pragma mark - JsonDictionary -> JsonString

- (void)jsonDictionaryToJsonString {
    NSDictionary *jsonDictionary = @{
                                     @"id":@"1420194",
                                     @"name"  :@"Jack",
                                     @"score" : @"88.33",
                                     @"register_date": @"1428647083",
                                     @"last_login_time" : @"1430642742",
                                     @"house" : @{
                                             @"address" : @"GuangZhou China",
                                             @"area" : @(95.6),
                                             @"tags" : @[@"nice",
                                                         @"comfort"]
                                             },
                                     @"cars" : @[@{
                                                     @"brand":@"benz",
                                                     @"num":@"A14212"
                                                     }]
                                     };
    NSString *jsonString = [jsonDictionary toJsonString];
    
    NSLog(@"jsonDictionary: %@", jsonDictionary);
    NSLog(@"jsonString: %@", jsonString);
}

#pragma mark - JsonObject -> JsonString

- (void)jsonObjectToJsonString {
    PersonModel *personModel = [[PersonModel alloc] init];
    personModel.id = 1420194;
    personModel.name = @"Jack";
    personModel.score = 88.33;
    personModel.registerDate = [NSDate dateWithTimeIntervalSince1970:1428647083];
    HouseModel *house = [[HouseModel alloc] init];
    house.address = @"GuangZhou China";
    house.area = 95.6;
    house.tags = @[@"nice", @"comfort"];
    personModel.house = house;
    CarModel *car = [[CarModel alloc] init];
    car.brand = @"benz";
    car.num = @"A14212";
    personModel.cars = @[car];
    
    NSString *jsonString = [personModel toJsonString];
    
    NSLog(@"jsonObject: %@", personModel);
    NSLog(@"jsonString: %@", jsonString);
}

#pragma mark - JsonString -> JsonObjectArray

- (void)jsonStringToJsonObjectArray {
    NSString *jsonString = @"\
    [\
      {\
        \"id\": 1420194,\
        \"name\": \"Jack\",\
        \"score\": 88.33,\
        \"register_date\": 1428647083,\
        \"last_login_time\": 1430642742,\
        \"house\": {\
          \"address\": \"GuangZhou China\",\
          \"area\": 95.6,\
          \"tags\": [\
            \"nice\",\
            \"comfort\"\
          ]\
      },\
      \"cars\": [\
        {\
          \"brand\": \"benz\",\
          \"num\": \"A14212\"\
        }\
      ]\
    },\
    {\
      \"id\": 1420194,\
      \"name\": \"Jack\",\
      \"score\": 88.33,\
      \"register_date\": 1428647083,\
      \"last_login_time\": 1430642742,\
      \"house\": {\
        \"address\": \"GuangZhou China\",\
        \"area\": 95.6,\
        \"tags\": [\
          \"nice\",\
          \"comfort\"\
        ]\
      },\
      \"cars\": [\
        {\
          \"brand\": \"benz\",\
          \"num\": \"A14212\"\
        }\
      ]\
    }\
    ]\
    ";
    NSArray *personModels = [PersonModel objectArrayFromJsonArray:[jsonString toJsonArray]];
    NSLog(@"jsonString: %@", jsonString);
    NSLog(@"jsonObjects: %@", personModels);
}

#pragma mark - JsonReciprocityDelegateDemo

- (void)jsonReciprocityDelegateDemo {
    NSString *jsonString = @"{\
        \"date1\" : \"2015/07/11\",\
        \"date2\" : \"2015.05.29\",\
        \"date3\" : \"2016.12.13\",\
        \"content_detail\" : \"this is a detail\",\
        \"test\" : \"Hello world\",\
        \"test2\" : \"Good Byt world\"\
    }";
    TestObject *object = [TestObject objectFromJsonDict:[jsonString toJsonDictionary]];
    NSLog(@"jsonString: %@", jsonString);
    NSLog(@"jsonObject: %@", object);
}


@end
