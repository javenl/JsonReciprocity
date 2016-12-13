//
//  BaseObject.h
//  JsonReciprocity
//
//  Created by liu on 15/11/17.
//  Copyright © 2015年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseObject : NSObject

@property (strong, nonatomic) NSDate *date1;
@property (strong, nonatomic) NSDate *date2;
@property (strong, nonatomic) NSDate *date3;

@property (strong, nonatomic) NSString *str;
@property (assign, nonatomic) int x;
@property (copy, nonatomic) NSString *tt;

@end
