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
 * 转换之前可以修改源字典的数据
 */
+ (NSDictionary *)convertDictFromSourceDict:(NSDictionary *)dict;

/**
 * 转换成对象之后可以修改对象某些值
 */
+ (id)finalObjectFromConvertedObject:(id)object;

/**
 * 自定义映射值
 */
+ (id)customFormat:(NSString *)keyPath value:(id)value;

+ (id)customFormat:(NSString *)keyPath value:(id)value objectClassName:(NSString *)objectClassName;

/**
 * 是否需要忽略某些字段，默认为 NO
 */
+ (BOOL)isIgnorePropertyKey:(NSString *)key;

+ (BOOL)isIgnorePropertyKey:(NSString *)key objectClassName:(NSString *)objectClassName;

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

- (NSDictionary *)toJsonDictionaryIgnoreNullKey:(BOOL)isIgnoreNullKey;

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
+ (NSDictionary *)propertysWithTypes;

/**
 *  NSArray With All Property Name
 */
+ (NSArray *)propertys;

@end
