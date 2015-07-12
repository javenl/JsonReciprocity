//
//  SimpleTypeTestModel.h
//  JVReciprocity
//
//  Created by liu on 15-5-7.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SimpleTypeTestModel : NSObject

@property (assign, nonatomic) short shortNumber;
@property (assign, nonatomic) int intNumber;
@property (assign, nonatomic) long longNumber;
@property (assign, nonatomic) NSInteger integerNumber;
@property (copy, nonatomic) NSNumber *numberInt;

@property (assign, nonatomic) float floatNumber;
@property (assign, nonatomic) double doubleNumber;
@property (assign, nonatomic) CGFloat cgfloatNumber;
@property (copy, nonatomic) NSNumber *numberFloat;

@property (assign, nonatomic) BOOL boolYES;
@property (assign, nonatomic) BOOL boolNum;
@property (copy, nonatomic) NSNumber *numberBool;

@property (assign, nonatomic) NSTimeInterval timestamp;

@property (strong, nonatomic) NSDate *date;

@property (copy, nonatomic) NSString *string;

@property (copy, nonatomic) NSURL *url;

@end
