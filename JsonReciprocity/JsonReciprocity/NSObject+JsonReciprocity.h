//
//  NSObject+Exchange.h
//
//  Created by liu on 14-12-30.
//
//

#import <Foundation/Foundation.h>

@protocol JsonReciprocityDelegate <NSObject>

@optional

/**
 * 自定义映射值
 */
- (id)customFormat:(NSString *)keyPath value:(id)value;

/**
 * 是否需要忽略某些字段，默认为 NO
 */
- (BOOL)isIgnorePropertyKey:(NSString *)key;

/**
 * 自定义映射字典
 */
+ (NSDictionary *)customReferenceDict;

/**
 * 如果映射的类里面包含了数组，则可以指定该数组里元素继续被映射成什么类的对象
 */
+ (NSDictionary *)classReferenceDictForArray;

/**
 * 自动把下划线转驼峰，默认为 YES
 */
+ (BOOL)autoUpperCaseToCamelCase;

@end

@interface NSObject (JsonReciprocity) <JsonReciprocityDelegate>

/**
 *  Object -> NSDictionary
 */
- (NSDictionary *)toJsonDictionary;

/**
 *  NSDictionary -> Object
 */
+ (id)objectFromJsonDict:(NSDictionary *)dict;

/**
 *  JsonArray -> ObjectArray
 */
+ (NSMutableArray *)objectArrayFromJsonArray:(NSArray *)jsonArray;

/**
 *  Dictionary With Key->Property Name, Value->Class Name
 */
- (NSDictionary *)propertysWithTypes;

/**
 *  NSArray With All Property Name
 */
- (NSArray *)propertys;

@end
