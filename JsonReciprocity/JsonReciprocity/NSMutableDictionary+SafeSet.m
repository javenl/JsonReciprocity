//
//  NSMutableDictionary+SafeSet.m
//  CompositeTest
//
//  Created by liu on 14-12-30.
//
//

#import "NSMutableDictionary+SafeSet.h"

@implementation NSMutableDictionary (SafeSet)

- (void)safeSetObject:(id)object forKey:(NSString *)key placeHolderObject:(id)placeHolder {
    if (object) {
        self[key] = object;
    } else if (placeHolder) {
        self[key] = placeHolder;
    }
}

- (void)safeSetObject:(id)object forKey:(NSString *)key {
    [self safeSetObject:object forKey:key placeHolderObject:nil];
}

@end
