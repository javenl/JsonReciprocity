//
//  CarMTLModel.h
//  JVReciprocity
//
//  Created by liu on 15-5-8.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>

@interface CarMTLModel : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic) NSString *num;
@property (copy, nonatomic) NSString *brand;

@end
