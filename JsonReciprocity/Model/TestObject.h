//
//  TestObject.h
//  JsonReciprocity
//
//  Created by liu on 15/7/12.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonReciprocity.h"

@interface TestObject : NSObject <JsonReciprocityDelegate>

@property (strong, nonatomic) NSDate *date1;
@property (strong, nonatomic) NSDate *date2;
@property (strong, nonatomic) NSString *str;
@property (strong, nonatomic) NSString *test;

@end
