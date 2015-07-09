//
//  HouseModel.h
//  JVReciprocity
//
//  Created by liu on 15-5-7.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HouseModel : NSObject

@property (copy, nonatomic) NSString *address;
@property (assign, nonatomic) CGFloat area;
@property (strong, nonatomic) NSArray *tags;

@end
