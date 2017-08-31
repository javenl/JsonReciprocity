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
#import "JsonReciprocityManager.h"

@implementation NSObject (JsonReciprocity)

+ (NSDictionary *)propertysWithTypes {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    Class cls = [self class];
    while (cls && ![cls isEqual:[NSObject class]]) {
        unsigned int propertyCount = 0;
        Ivar *ivars = class_copyIvarList(cls, &propertyCount);
        for (unsigned int i = 0; i < propertyCount; ++i) {
            Ivar var = ivars[i];
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(var)];
            NSString *name = [NSString stringWithUTF8String:ivar_getName(var)];
            if ([name hasPrefix:@"_"]) {
                name = [name substringFromIndex:1];
            }
            if ([type hasPrefix:@"@"]) {
                type = [type stringByReplacingOccurrencesOfString:@"@" withString:@""];
                type = [type stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            } else { // not an object
                type = @"";
            }
            [dict safeSetObject:type forKey:name];
        }
        free(ivars);
        cls = [cls superclass];
    }
    return dict;
}

+ (NSArray *)propertys {
    return [self propertysIgnoreDefault:YES];
}

+ (NSArray *)propertysIgnoreDefault:(BOOL)ignore {
    NSMutableSet *propertySet = [NSMutableSet set];
    Class cls = [self class];
    while (cls && ![cls isEqual:[NSObject class]]) {
        unsigned int propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
        for (unsigned int i = 0; i < propertyCount; ++i) {
            objc_property_t property = properties[i];
            const char *cname = property_getName(property);
            NSString *name = [NSString stringWithUTF8String:cname];
            if (ignore) { // ignore default propertys
                if ([name isEqualToString:@"description"] || [name isEqualToString:@"debugDescription"] ||
                    [name isEqualToString:@"hash"] || [name isEqualToString:@"superclass"]) {
                    continue;
                }
            }
            [propertySet addObject:name];
        }
        free(properties);
        cls = [cls superclass];
    }
    return propertySet.allObjects;
}

+ (NSDictionary *)propertyDict {
    NSArray *propertys = [self propertys];
    NSMutableDictionary *propertyDict = [[NSMutableDictionary alloc] init];
    for (NSString *property in propertys) {
        propertyDict[property] = @(YES);
    }
    return propertyDict;
}

#pragma mark - Object -> NSDictionary

- (NSDictionary *)toJsonDictionary {
    return [self toJsonDictionaryIgnoreNullKey:YES];
}

- (NSDictionary *)toJsonDictionaryIgnoreNullKey:(BOOL)isIgnoreNullKey {
    NSMutableDictionary *propertyDict = [NSMutableDictionary dictionary];
    NSArray *propertys = [[self class] propertys];
    for (NSString *property in propertys) {
        id value = [NSObject getObjectInternal:[self valueForKey:property]];
        if (value) {
            [propertyDict setObject:value forKey:property];
        } else {
            if (!isIgnoreNullKey) {
                [propertyDict setObject:[NSNull null] forKey:property];
            }
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
    id object = [self objectFromJsonDict:dataDict dataDictKeys:nil object:nil objectPropertyTypes:nil];
    return object;
}

+ (id)objectFromJsonDict:(NSDictionary *)jsonDict dataDictKeys:(NSArray *)dataDictKeys object:(id)object objectPropertyTypes:(NSDictionary *)objectPropertyTypes {
    NSAssert([jsonDict isKindOfClass:[NSDictionary class]], @"JsonDict Is Not Type Of NSDictionary");
    
    object = object ? object : [[self alloc] init];
    
    NSDictionary *converDict = nil;
    
    if ([self respondsToSelector:@selector(convertDictFromSourceDict:)]) {
        converDict = [self convertDictFromSourceDict:jsonDict];
    } else {
        converDict = jsonDict;
    }
    
    dataDictKeys = dataDictKeys ? dataDictKeys : [converDict allKeys];
    
    NSDictionary *referDict = [self globalReferDict];
    
    objectPropertyTypes = objectPropertyTypes ? objectPropertyTypes : [self propertysWithTypes];
    
    for (NSString *key in dataDictKeys) {
        
        //source
        id value = converDict[key];
        if ([value isKindOfClass:[NSNull class]]) {
            continue;
        }
        
        //target
        NSString *propertyKey = nil;
        if (referDict[key]) {
            propertyKey = referDict[key];
        } else if([self autoUpperCaseToCamelCase]) {
            //下划线转驼峰
            propertyKey = [NSString camelCaseFromUnderscoreCase:key];
        } else {
            propertyKey = key;
        }
        
        NSString *className = objectPropertyTypes[propertyKey];
        if (className == nil) {
            JRLog(@"No Propertykey %@ In %@", propertyKey, NSStringFromClass(self));
            continue;
        }
        
        if ([self respondsToSelector:@selector(isIgnorePropertyKey:)]) {
            if ([self isIgnorePropertyKey:propertyKey]) {
                continue;
            }
        } else if ([self respondsToSelector:@selector(isIgnorePropertyKey:objectClassName:)]) {
            if ([self isIgnorePropertyKey:propertyKey objectClassName:className]) {
                continue;
            }
        }
        
        // 自定义数据
        if ([self respondsToSelector:@selector(customFormat:value:objectClassName:)]) {
            id customValue = [self customFormat:propertyKey value:value objectClassName:className];
            if (customValue) {
                [object setValue:customValue forKey:propertyKey];
                continue;
            }
        } else if ([self respondsToSelector:@selector(customFormat:value:)]) {
            id customValue = [self customFormat:propertyKey value:value];
            if (customValue) {
                [object setValue:customValue forKey:propertyKey];
                continue;
            }
        }
        
        //
        if (className.length > 0) { // 是类对象
            // 特殊的基本类对象
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
            
            if ([property isKindOfClass:[NSString class]]) { // 字符串类型
                NSString *str = nil;
                if ([value isKindOfClass:[NSNumber class]]) { //兼容数字转字符串
                    str = [NSString stringWithFormat:@"%@", value];
                } else {
                    str = [[propertyClass alloc] initWithString:value];
                }
                [object setValue:str forKey:propertyKey];
                continue;
            }
            
            if ([property isKindOfClass:[NSNumber class]] || [property isKindOfClass:[NSDictionary class]]) { //数字类型和字典直接设值
                
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
                NSAssert([value isKindOfClass:[NSDictionary class]], @" ****  Property [%@] can not exchange %@ to %@ ***** ",propertyKey,NSStringFromClass(propertyClass), NSStringFromClass([value class]));
                NSArray *dataDictKeys = [propertyClass globalKeysWithDict:value];
                NSDictionary *objectPropertyTypes =  [propertyClass globalObjectPropertyTypes];
                id realValue = [propertyClass objectFromJsonDict:value dataDictKeys:dataDictKeys object:nil objectPropertyTypes:objectPropertyTypes];
                [object setValue:realValue forKey:propertyKey];
                
            }
        } else { // 非类对象（基本类型 int float 之类）直接赋值
            if (!value) {
                [object setValue:@(0) forKey:propertyKey];
            } else {
                [object setValue:value forKey:propertyKey];
            }

        }
    }
    
    id finalObject = nil;
    if ([self respondsToSelector:@selector(finalObjectFromConvertedObject:)]) {
        finalObject = [self finalObjectFromConvertedObject:object];
    } else {
        finalObject = object;
    }
    
    return finalObject;
}

#pragma mark - JsonArray -> ObjectArray

+ (NSMutableArray *)objectArrayFromJsonArray:(NSArray *)jsonArray {
    if (![jsonArray isKindOfClass:[NSArray class]]) {
        @try {
            NSAssert([jsonArray isKindOfClass:[NSArray class]], @"JsonArray Is Not Kind Of NSArray");
        }
        @catch (NSException *exception) {

        }
        return nil;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (id data in jsonArray) {
        id result = nil;
        if ([data isKindOfClass:[NSArray class]]) {
            result = [self objectArrayFromJsonArray:data];
        } else if ([data isKindOfClass:[NSDictionary class]]) {
//            NSArray *dataDictKeys = [self globalKeysWithDict:data];
            NSDictionary *objectPropertyTypes =  [self globalObjectPropertyTypes];
            result = [self objectFromJsonDict:data dataDictKeys:nil object:nil objectPropertyTypes:objectPropertyTypes];
        } else {
            result = data;
        }
        [array addObject:result];
    }
    return array;
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
    NSMutableDictionary *globalKeyDict = [NSMutableDictionary dictionary];
    NSArray *dataDictKeys = [dict allKeys];
    NSString *className = NSStringFromClass([self class]);
    globalKeyDict[className] = dataDictKeys;
    return globalKeyDict[className];
}

+ (NSDictionary *)globalObjectPropertyTypes {
    NSMutableDictionary *globalPropertyDict = [NSMutableDictionary dictionary];
    NSString *className = NSStringFromClass([self class]);
    globalPropertyDict[className] = [self propertysWithTypes];
    return globalPropertyDict[className];
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

@implementation NSString (JsonReciprocity)

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

+ (NSString *)underscoreCaseFromCamelCase:(NSString *)camelCase {
    if (camelCase.length == 0) {
        return camelCase;
    }
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0; i < camelCase.length; i++) {
        unichar c = [camelCase characterAtIndex:i];
        NSString *cString = [NSString stringWithFormat:@"%c", c];
        NSString *cStringLower = [cString lowercaseString];
        if ([cString isEqualToString:cStringLower]) {
            [string appendString:cStringLower];
        } else {
            [string appendString:@"_"];
            [string appendString:cStringLower];
        }
    }
    return string;
}

@end

