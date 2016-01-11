//
//  TestObject.h
//  JsonReciprocity
//
//  Created by liu on 15/7/12.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonReciprocity.h"
#import "BaseObject.h"

@interface TestObject : BaseObject <JsonReciprocityDelegate>

@property (strong, nonatomic) NSDate *date1;
@property (strong, nonatomic) NSDate *date2;

@property (strong, nonatomic) NSString *test;

@end
