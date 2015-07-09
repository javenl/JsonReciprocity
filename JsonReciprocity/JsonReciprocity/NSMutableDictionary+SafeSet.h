//
//  NSMutableDictionary+SafeSet.h
//  CompositeTest
//
//  Created by liu on 14-12-30.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (SafeSet)

- (void)safeSetObject:(id)object forKey:(NSString *)key placeHolderObject:(id)placeHolder;

- (void)safeSetObject:(id)object forKey:(NSString *)key;

@end
