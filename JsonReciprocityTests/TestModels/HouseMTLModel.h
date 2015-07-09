//
//  HouseMTLModel.h
//  JVReciprocity
//
//  Created by liu on 15-5-8.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import "MTLModel.h"
#import <UIKit/UIKit.h>
#import <Mantle.h>

@interface HouseMTLModel : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic) NSString *address;
@property (assign, nonatomic) CGFloat area;
@property (strong, nonatomic) NSArray *tags;

@end
