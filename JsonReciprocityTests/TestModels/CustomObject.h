//
//  CustomObject.h
//  JsonReciprocity
//
//  Created by liu on 15/8/26.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomObject : NSObject

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *data;
@property (strong, nonatomic, readonly) NSString *test;

@end
