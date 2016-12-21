//
//  TestString.m
//  JsonReciprocity
//
//  Created by liu on 16/12/21.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "TestString.h"

@interface TestString ()

@property (nonatomic, strong) NSString *backingStore;

@end

@implementation TestString

- (id)initWithString:(NSString *)aString {
    self = [super init];
    if (self) {
        _backingStore = [NSString stringWithString:aString];
    }
    return self;
}

- (NSUInteger)length {
    return [_backingStore length];
}

- (unichar)characterAtIndex:(NSUInteger)index {
    return [_backingStore characterAtIndex:index];
}

- (void)testLog {
    NSLog(@"success");
}

@end
