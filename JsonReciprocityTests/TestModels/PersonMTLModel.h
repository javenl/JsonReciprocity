//
//  PersonMTLModel.h
//  JVReciprocity
//
//  Created by liu on 15-5-8.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <Mantle.h>
#import <UIKit/UIKit.h>
#import "CarMTLModel.h"
#import "HouseMTLModel.h"

//@protocol CarMTLModel;

@interface PersonMTLModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, strong) NSDate *registerDate;
@property (nonatomic, assign) NSTimeInterval lastLoginTime;
@property (nonatomic, strong) NSArray *cars;
@property (nonatomic, strong) HouseMTLModel *house;

@end
