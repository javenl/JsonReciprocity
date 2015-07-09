//
//  HouseJsonModel.h
//  JVReciprocity
//
//  Created by liu on 15-5-8.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import "JSONModel.h"
#import <UIKit/UIKit.h>

@interface HouseJsonModel : JSONModel

@property (copy, nonatomic) NSString *address;
@property (assign, nonatomic) CGFloat area;
@property (strong, nonatomic) NSArray *tags;

@end
