//
//  Person.h
//  JVReciprocity
//
//  Created by liu on 15-5-7.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseModel.h"
#import "JsonReciprocity.h"

@interface PersonModel : NSObject <JsonReciprocityDelegate>

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, strong) NSDate *registerDate;
@property (nonatomic, assign) NSTimeInterval lastLoginTime;
@property (nonatomic, strong) NSArray *cars;
@property (nonatomic, strong) HouseModel *house;

@end
