//
//  NSObject+Exchange.m
//  CompositeTest
//
//  Created by liu on 14-12-30.
//
//

#import "NSObject+JsonReciprocity.h"
#import "NSMutableDictionary+SafeSet.h"
#import "JsonSerialization.h"
#import <objc/runtime.h>

#if DEBUG
#define JRLog(format,...) NSLog(format, ##__VA_ARGS__)
#else
#define JRLog(format,...)
#endif

@implementation NSObject (JsonReciprocity)

- (NSDictionary *)propertysWithTypes {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int propertyCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &propertyCount);
    for (unsigned int i = 0; i < propertyCount; ++i) {
        Ivar var = ivars[i];
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(var)];
        NSString *name = [NSString stringWithUTF8String:ivar_getName(var)];
        if ([name hasPrefix:@"_"]) {
//            name = [name stringByReplacingOccurrencesOfString:@"_" withString:@""];
            name = [name substringFromIndex:1];
        }
        if ([type hasPrefix:@"@"]) {
            type = [type stringByReplacingOccurrencesOfString:@"@" withString:@""];
            type = [type stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        } else {
            type = @"";
        }
        [dict safeSetObject:type forKey:name];
	}
    free(ivars);
    return dict;
}

- (NSArray *)propertys {
    NSMutableArray *propertyNamesArray = [NSMutableArray array];
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    for (unsigned int i = 0; i < propertyCount; ++i) {
		objc_property_t property = properties[i];
		const char * name = property_getName(property);
		[propertyNamesArray addObject:[NSString stringWithUTF8String:name]];
	}
	free(properties);
    return propertyNamesArray;
}

- (NSDictionary *)propertyDict {
    NSArray *propertys = [self propertys];
    NSMutableDictionary *propertyDict = [[NSMutableDictionary alloc] init];
    for (NSString *property in propertys) {
        propertyDict[property] = @(YES);
    }
    return propertyDict;
}

#pragma mark - Object -> NSDictionary

- (NSDictionary *)toJsonDictionary {
    NSMutableDictionary *propertyDict = [NSMutableDictionary dictionary];
    NSArray *propertys = [self propertys];
    for (NSString *property in propertys) {
        if (![property isEqualToString:@"superclass"] &&
            ![property isEqualToString:@"hash"] &&
            ![property isEqualToString:@"description"] &&
            ![property isEqualToString:@"debugDescription"]) {//忽略一些关键字
            id value = [NSObject getObjectInternal:[self valueForKey:property]];
            [propertyDict safeSetObject:value forKey:property placeHolderObject:[NSNull null]];
        }
    }
    return propertyDict;
}

+ (id)getObjectInternal:(id)obj {
    if(!obj || [obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSNull class]]) {
        return obj;
    }
    
    if([obj isKindOfClass:[NSDate class]]) {
        return @([obj timeIntervalSince1970]);
    }
    
    if([obj isKindOfClass:[NSURL class]]) {
        return [obj absoluteString];
    }

    if([obj isKindOfClass:[NSArray class]]) {
        NSArray *objArray = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objArray.count];
        for(int i = 0;i < objArray.count; i++) {
            [arr setObject:[self getObjectInternal:[objArray objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }

    if([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *objDict = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objDict count]];
        for(NSString *key in objDict.allKeys) {
            [dic setObject:[self getObjectInternal:[objDict objectForKey:key]] forKey:key];
        }
        return dic;
    }
    
    return [obj toJsonDictionary];
}

#pragma mark - NSDictionary -> Object

+ (id)objectFromJsonDict:(NSDictionary *)dataDict {
    return [self objectFromJsonDict:dataDict dataDictKeys:nil object:nil objectPropertyTypes:nil];
}

+ (id)objectFromJsonDict:(NSDictionary *)jsonDict dataDictKeys:(NSArray *)dataDictKeys object:(id)object objectPropertyTypes:(NSDictionary *)objectPropertyTypes {
    NSAssert([jsonDict isKindOfClass:[NSDictionary class]], @"JsonDict Is Not Type Of NSDictionary");

    object = object ? object : [[self alloc] init];

    dataDictKeys = dataDictKeys ? dataDictKeys : [jsonDict allKeys];

    NSDictionary *referDict = [self globalReferDict];

    objectPropertyTypes = objectPropertyTypes ? objectPropertyTypes : [object propertysWithTypes];
    
    for (NSString *key in dataDictKeys) {
        
        //source
        id value = jsonDict[key];
        if ([value isKindOfClass:[NSNull class]]) {
            continue;
        }
        
        //target
        NSString *propertyKey = nil;
        if (referDict[key]) {
            propertyKey = referDict[key];
        } else if([self autoUpperCaseToCamelCase]) {
            //下划线转驼峰
            propertyKey = [self camelCaseFromUnderscoreCase:key];
        } else {
            propertyKey = key;
        }
        
        if ([object respondsToSelector:@selector(isIgnorePropertyKey:)]) {
            if ([object isIgnorePropertyKey:propertyKey]) {
                continue;
            }
        }
        
        NSString *className = objectPropertyTypes[propertyKey];
        if (className == nil) {
            JRLog(@"No Propertykey %@ In %@", propertyKey, NSStringFromClass(self));
            continue;
        }
        
        if ([object respondsToSelector:@selector(customFormat:value:)]) {
            value = [object customFormat:propertyKey value:value];
        }
        
        if (className.length > 0) {
            //特殊基础类型
            if ([className isEqualToString:@"NSDate"]) {//NSDate 用dateWithTimeIntervalSince1970初始化
                if ([value isKindOfClass:[NSNumber class]]) {
                    value = [NSDate dateWithTimeIntervalSince1970:[value integerValue]];
                }
                [object setValue:value forKey:propertyKey];
                continue;
            } else if ([className isEqualToString:@"NSURL"]) {//NSURL 用URLWithString初始化
                value = [NSURL URLWithString:value];
                [object setValue:value forKey:propertyKey];
                continue;
            } else if ([className isEqualToString:@"NSNumber"]) {
                [object setValue:value forKey:propertyKey];
                continue;
            }
            
            Class propertyClass = NSClassFromString(className);
            id property = [[propertyClass alloc] init];
            
            if ([property isSupportedClasses] || [property isKindOfClass:[NSDictionary class]]) { //基础类型和字典直接设值
                
//                if ([property isKindOfClass:[NSDate class]]) {
//                    value = [NSDate dateWithTimeIntervalSince1970:[value integerValue]];
//                }
//                if ([property isKindOfClass:[NSURL class]]) {
//                    value = [NSURL URLWithString:value];
//                }
                
                [object setValue:value forKey:propertyKey];
                
            } else if ([property isKindOfClass:[NSArray class]]) { //数组需要递归
                
                NSDictionary *classDict = [self classReferenceDictForArray];
                if (classDict[propertyKey]) {
                    value = [classDict[propertyKey] objectArrayFromJsonArray:value];
                    [object setValue:value forKey:propertyKey];
                } else {
                    [object setValue:value forKey:propertyKey];
                }
                
            } else { //对象类型尝试映射
                
                Class propertyClass = NSClassFromString(className);
                NSAssert([value isKindOfClass:[NSDictionary class]], @"Can not exchange %@ to %@",NSStringFromClass(propertyClass), NSStringFromClass([value class]));
                NSArray *dataDictKeys = [propertyClass globalKeysWithDict:value];
                NSDictionary *objectPropertyTypes =  [propertyClass globalObjectPropertyTypes];
                id realValue = [propertyClass objectFromJsonDict:value dataDictKeys:dataDictKeys object:nil objectPropertyTypes:objectPropertyTypes];
                [object setValue:realValue forKey:propertyKey];

            }
        } else { // 无类型的
            [object setValue:value forKey:propertyKey];
        }
    }
    return object;
}

#pragma mark - JsonArray -> ObjectArray

+ (NSMutableArray *)objectArrayFromJsonArray:(NSArray *)jsonArray {
    NSAssert([jsonArray isKindOfClass:[NSArray class]], @"JsonArray Is Not Kind Of NSArray");
    NSMutableArray *array = [NSMutableArray array];
    for (id data in jsonArray) {
        id result = nil;
        if ([data isKindOfClass:[NSArray class]]) {
            result = [self objectArrayFromJsonArray:data];
        } else if ([data isKindOfClass:[NSDictionary class]]) {
            NSArray *dataDictKeys = [self globalKeysWithDict:data];
            NSDictionary *objectPropertyTypes =  [self globalObjectPropertyTypes];
            result = [self objectFromJsonDict:data dataDictKeys:dataDictKeys object:nil objectPropertyTypes:objectPropertyTypes];
        } else {
            result = data;
        }
        [array addObject:result];
    }
    return array;
}

- (BOOL)isSupportedClasses {
    if ([self isKindOfClass:[NSString class]] || [self isKindOfClass:[NSNumber class]] //|| [self isKindOfClass:[NSDate class]] || [self isKindOfClass:[NSURL class]]
        ) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - Helper

+ (NSString *)camelCaseFromUnderscoreCase:(NSString *)underscoreCase {
    if ([underscoreCase rangeOfString:@"_"].location == NSNotFound) {
        return underscoreCase;
    }
    NSArray *keys = [underscoreCase componentsSeparatedByString:@"_"];
    NSAssert(keys.count > 0, @"keys must > 0");
    
    NSMutableArray *uperscoreCases = [NSMutableArray arrayWithArray:keys];
    NSString *lastString = nil;
    NSString *camelCase = @"";
    
    [uperscoreCases enumerateObjectsUsingBlock:^(NSString *uperscoreCase, NSUInteger idx, BOOL *stop) {
        if (uperscoreCase.length == 0) {
            [uperscoreCases removeObject:uperscoreCase];
        }
    }];
    
    for (NSString *uperscoreCase in uperscoreCases) {
        if (lastString == nil) {
            camelCase = [camelCase stringByAppendingString:uperscoreCase];
        } else {
            NSString *firstChar = [[uperscoreCase substringToIndex:1] uppercaseString];
            NSString *otherChars = [[uperscoreCase substringFromIndex:1] lowercaseString];
            camelCase = [camelCase stringByAppendingString:[NSString stringWithFormat:@"%@%@", firstChar, otherChars]];
        }
        lastString = uperscoreCase;
    }
    return camelCase;
}

#pragma mark - Override

+ (BOOL)autoUpperCaseToCamelCase {
    return YES;
}

+ (NSDictionary *)classReferenceDictForArray {
    return nil;
}

//#pragma mark - single
#pragma mark - Memory Cache To Accelerate

+ (NSArray *)globalKeysWithDict:(NSDictionary *)dict {
    static NSMutableDictionary *globalKeyDict = nil;
    @synchronized (self) {
        if (globalKeyDict == nil) {
            globalKeyDict = [NSMutableDictionary dictionary];
        }
    }
    NSString *className = NSStringFromClass([self class]);
    if (!globalKeyDict[className]) {
        NSArray *dataDictKeys = [dict allKeys];
        globalKeyDict[className] = dataDictKeys;
        return globalKeyDict[className];
    } else {
        return globalKeyDict[className];
    }
}

+ (NSDictionary *)globalObjectPropertyTypes {
    static NSMutableDictionary *globalPropertyDict = nil;
    @synchronized (self) {
        if (globalPropertyDict == nil) {
            globalPropertyDict = [NSMutableDictionary dictionary];
        }
    }
    NSString *className = NSStringFromClass([self class]);
    if (!globalPropertyDict[className]) {
        id object = [[self alloc] init];
        globalPropertyDict[className] = [object propertysWithTypes];
        return globalPropertyDict[className];
    } else {
        return globalPropertyDict[className];
    }
}

+ (NSDictionary *)globalReferDict {
    static NSMutableDictionary *globalReferDict = nil;
    @synchronized (self) {
        if (globalReferDict == nil) {
            globalReferDict = [NSMutableDictionary dictionary];
        }
    }
    NSString *className = NSStringFromClass([self class]);
    if (!globalReferDict[className]) {
        if ([self respondsToSelector:@selector(customReferenceDict)]) {
            NSDictionary *referDict = [self customReferenceDict];
            globalReferDict[className] = referDict;
            return globalReferDict[className];
        } else {
            return nil;
        }
    } else {
        return globalReferDict[className];
    }
}

@end
