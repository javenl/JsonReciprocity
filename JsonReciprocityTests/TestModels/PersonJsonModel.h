//
//  PersonJsonModel.h
//  JVReciprocity
//
//  Created by liu on 15-5-8.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONModel.h"
#import "HouseJsonModel.h"
#import "CarJsonModel.h"

@protocol CarJsonModel;

@interface PersonJsonModel : JSONModel

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, strong) NSDate *registerDate;
@property (nonatomic, assign) NSTimeInterval lastLoginTime;
@property (nonatomic, strong) NSArray<CarJsonModel> *cars;
@property (nonatomic, strong) HouseJsonModel *house;

@end
