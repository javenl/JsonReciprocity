//
//  IrregularTestModel.h
//  JVReciprocity
//
//  Created by liu on 15-5-7.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JsonReciprocity.h"

@interface IrregularTestModel : NSObject <JsonReciprocityDelegate>

@property (assign, nonatomic) NSInteger id;
@property (assign, nonatomic) NSInteger userId;
@property (assign, nonatomic) NSInteger carId;
@property (strong, nonatomic) NSDate *exprideTime;
@property (strong, nonatomic) NSDate *lastDate;
@property (copy, nonatomic) NSString *car;
@property (copy, nonatomic) NSString *camelCaseTest;

@end