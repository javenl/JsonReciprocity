JsonReciprocity
===

* A wonderful framework for converting between JsonString and JsonObject. Convenient、Flexible、Easy to Use.<br>方便、灵活、好用的Json与Object互转框架。

* The framework is Category of NSObject, don't need to extends any class.<br>
框架是NSObject的分类，不需要继承任何基类即可使用。

##目录

* [setup 【安装】](#setup)
    * [Setup with pod【通过pod管理】](#setup_pod)
    * [Manually【手动管理】](#setup_manually)
* [Get Start 【使用】](#get_start)
	* [Define【设定】](#define)
	* [Common usage 【基本用法】](#common_usage)
        - [JsonString -> JsonDictionary](#string_dict)
        - [JsonDictionary -> JsonObject](#dict_object)
        - [JsonString -> JsonObject](#string_object)
        - [JsonObject -> JsonDictionary](#object_dict)
        - [JsonDictionary -> JsonString](#dict_string)
        - [JsonObject -> JsonString](#object_string)
        - [JsonString -> JsonObjectArray](#string_object_array)
	* [JsonReciprocityDelegate【Delegate】](#delegate)
        - [classReferenceDictForArray](#delegate_dict_array)
        - [customReferenceDict](#delegate_dict)
        - [isIgnorePropertyKey](#delegate_ignore)
        - [autoUpperCaseToCamelCase](#delegate_autocase)
        - [customFormat:value:](#delegate_custom_format)
    * [Solution for Some Cases 【某些情况下的解决办法】](#solution)
        - [One to many【一对多】](#one_many)
        - [Many to one【多对一】](#many_one)
* [Compare with other framework【框架对比】](#compare)
* [More【其他用法】](#more)
* [About【关于】](#about)
    * [Writer 【作者信息】](#writer)
    * [Issue 【任何问题】](#issue)
    


##<a id="setup"></a>setup 【安装】

###<a id=""></a>Setup with pod 【通过pod管理】
```ruby
pod 'JsonReciprocity', '~> 1.0.0'
```

###<a id="setup_manually"></a>Manually 【手动管理】

1.Download the JSONModel repository as a zip file or clone it.【下载源代码】

2.Copy the /JsonReciprocity/JsonReciprocity into your Xcode project.【把/JsonReciprocity/JsonReciprocity目录中下的文件加入工程】

```
JsonReciprocity
├── JsonDeserialization.h
├── JsonDeserializstion.m
├── JsonReciprocity.h
├── JsonSerialization.h
├── JsonSerialization.m
├── NSMutableDictionary+SafeSet.h
├── NSMutableDictionary+SafeSet.m
├── NSObject+JsonReciprocity.h
└── NSObject+JsonReciprocity.m
```

##<a id="get_start"></a> Get start 【使用】

###<a id="define"></a>Define 【设定】 

JsonString and JsonObject

<table>
<tr>
<td valign="top">
<pre>
{
	"id": 1420194,
	"name" : "Jack",
	"score" : 88.33,
	"register_date" : 1428647083,
	"last_login_time" : 1430642742,
    "house": {
        "address": "GuangZhou China",
        "area": 95.6,
        "tags":[
            "nice",
            "comfort"
            ]}
    },
	"cars":[{
		"brand":"benz",
		"num":"A14212"
	}]
}
</pre>
</td>
<td valign="top">
<pre>
@interface PersonModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, strong) NSDate *registerDate;
@property (nonatomic, assign) NSTimeInterval lastLoginTime;
@property (nonatomic, strong) NSArray *cars;

@end
</pre>
</td>
</tr>
</table>

###<a id="common_usage"></a>Common usage 【基本用法】

```objectivec
#import "JsonReciprocity.h"
```

####<a id="string_dict"></a>JsonString -> JsonDictionary

```objectivec
- (void)jsonStringToJsonDictionary {
    NSString *jsonString = @"\
    {\
        \"id\": 1420194,\
        \"name\" : \"Jack\",\
        \"score\" : 88.33,\
        \"register_date\" : 1428647083,\
        \"last_login_time\" : 1430642742,\
        \"cars\":[{\
            \"brand\":\"benz\",\
            \"num\":\"A14212\"\
        }]\
    }";
    NSDictionary *jsonDictionary = [jsonString toDictionary];
    NSLog(@"jsonString: %@", jsonString);
    NSLog(@"jsonDictionary: %@", jsonDictionary);
}
```

####<a id="dict_object"></a>JsonDictionary -> JsonObject

```objectivec
- (void)jsonDictionaryToJsonObject {
    NSDictionary *jsonDictionary = @{
                                     @"id":@"1420194",
                                     @"name"  :@"Jack",
                                     @"score" : @"88.33",
                                     @"register_date": @"1428647083",
                                     @"last_login_time" : @"1430642742",
                                     @"cars" : @[@{
                                                  @"brand":@"benz",
                                                  @"num":@"A14212"
                                                  }]
                                     };
    PersonModel *personModel = [PersonModel objectFromJsonDict:jsonDictionary];
    NSLog(@"jsonDictionary: %@", jsonDictionary);
    NSLog(@"personModel: %@", personModel.toJsonString);
}
```

####<a id="string_object"></a>JsonString -> JsonObject

```objectivec
- (void)jsonStringToJsonObject {
    NSString *jsonString = @"\
    {\
        \"id\": 1420194,\
        \"name\" : \"Jack\",\
        \"score\" : 88.33,\
        \"register_date\" : 1428647083,\
        \"last_login_time\" : 1430642742,\
        \"cars\":[{\
            \"brand\":\"benz\",\
            \"num\":\"A14212\"\
        }]\
    }";
    PersonModel *personModel = [PersonModel objectFromJsonDict:jsonString.toJsonDictionary];
    NSLog(@"jsonString: %@", jsonString);
    NSLog(@"personModel: %@", personModel.toJsonString);
}
```

####<a id="object_dict"></a>JsonObject -> JsonDictionary

```objectivec
- (void)jsonOjectToJsonDictionary {
    PersonModel *personModel = [[PersonModel alloc] init];
    personModel.id = 1420194;
    personModel.name = @"Jack";
    personModel.score = 88.33;
    personModel.registerDate = [NSDate dateWithTimeIntervalSince1970:1428647083];
    CarModel *car = [[CarModel alloc] init];
    car.brand = @"benz";
    car.num = @"A14212";
    personModel.cars = @[car];
    
    NSDictionary *jsonDictionary = [personModel toJsonDictionary];
    
    NSLog(@"jsonObject: %@", personModel);
    NSLog(@"jsonDictionary: %@", jsonDictionary);
}
```

####<a id="dict_string"></a>JsonDictionary -> JsonString

```objectivec
- (void)jsonDictionaryToJsonString {
    NSDictionary *jsonDictionary = @{
                                     @"id":@"1420194",
                                     @"name"  :@"Jack",
                                     @"score" : @"88.33",
                                     @"register_date": @"1428647083",
                                     @"last_login_time" : @"1430642742",
                                     @"cars" : @[@{
                                                     @"brand":@"benz",
                                                     @"num":@"A14212"
                                                     }]
                                     };
    NSString *jsonString = [jsonDictionary toJsonString];
    
    NSLog(@"jsonDictionary: %@", jsonDictionary);
    NSLog(@"jsonString: %@", jsonString);
}
```

####<a id="object_string"></a>JsonObject -> JsonString

```objectivec
- (void)jsonObjectToJsonString {
    PersonModel *personModel = [[PersonModel alloc] init];
    personModel.id = 1420194;
    personModel.name = @"Jack";
    personModel.score = 88.33;
    personModel.registerDate = [NSDate dateWithTimeIntervalSince1970:1428647083];
    CarModel *car = [[CarModel alloc] init];
    car.brand = @"benz";
    car.num = @"A14212";
    personModel.cars = @[car];
    
    NSString *jsonString = [personModel toJsonString];
    
    NSLog(@"jsonObject: %@", personModel);
    NSLog(@"jsonString: %@", jsonString);
}
```

####<a id="string_object_array"></a>JsonString -> JsonObjectArray

```objectivec
- (void)jsonStringToJsonObjectArray {
    NSString *jsonString = @"\
    [{\
        \"id\": 1420194,\
        \"name\" : \"Jack\",\
        \"score\" : 88.33,\
        \"register_date\" : 1428647083,\
        \"last_login_time\" : 1430642742,\
        \"cars\":[{\
            \"brand\":\"benz\",\
            \"num\":\"A14212\"\
        }]\
    },{\
        \"id\": 1420194,\
        \"name\" : \"Jack\",\
        \"score\" : 88.33,\
        \"register_date\" : 1428647083,\
        \"last_login_time\" : 1430642742,\
        \"cars\":[{\
            \"brand\":\"benz\",\
            \"num\":\"A14212\"\
        }]\
    }]";
    NSArray *personModels = [PersonModel objectArrayFromJsonArray:[jsonString toJsonArray]];
    NSLog(@"jsonString: %@", jsonString);
    NSLog(@"jsonObjects: %@", personModels);
}

```

###<a id="delegate"></a>JsonReciprocityDelegate【Delegate】

通过实现JsonReciprocityDelegate，可以有更多灵活的用法。

####<a id="delegate_dict_array"></a>classReferenceDictForArray

If the json object contains another object array, it is necessary to indicate what class it need to reference. Otherwise, it is a NSArray with NSDictionary.  【如果需要转换的JsonObject中又包含了其他对象的数组，需要指定该数组应该自动转换成什么类型的对象数组，否则就映射成一个字典数组。】

```objectivec
+ (NSDictionary *)classReferenceDictForArray {
    return @{@"cars": [CarModel class]};
}
```

####<a id="delegate_dict"></a>customReferenceDict

alias with property name  【指定映射的别名】

```objectivec
+ (NSDictionary *)customReferenceDict {
    return @{
             @"indexIdString": @"index",
             };
}
```
PS:Only define the custom property, other properties will auto reference.  【不需要把每个变量都写上，只需要写特定的，其他没指定的依然会按照变量名命映射。】

####<a id="delegate_ignore"></a>isIgnorePropertyKey:

What propertys should be ignore. 【忽略某些属性】

```objectivec
- (BOOL)isIgnorePropertyKey:(NSString *)key {
    if ([key isEqualToString:@"test"]) {
        return YES;
    }
    return NO;
}
```

####<a id="delegate_autocase"></a>autoUpperCaseToCamelCase

Auto convert UpperCase tp CamelCase, default is YES. If you don't need to convert, return NO.<br>
【自动把下划线风格转驼峰风格，默认为YES。如果不希望自动转换，可以返回NO】

```objectivec
+ (BOOL)autoUpperCaseToCamelCase {
    return NO;
}
```

Example 【例子】<br>

Without a word, only to define the model, frameword will help you to convert this Irregular json string.
【你不需要写任何代码，把模型定义好，框架就能帮你转换这些不规则的json字符串。】

<table>
<tr>
<td valign="top">
<pre>
{
    "Id" : 111,
    "user_Id" : 4096,
    "car_id" : 1234,
    "lastDate":1430647083,
    "__camel___CASE__tEST__": "this is string"
}
</pre>
</td>
<td valign="top">
<pre>
@interface IrregularTestModel : NSObject

@property (assign, nonatomic) NSInteger id;
@property (assign, nonatomic) NSInteger userId;
@property (assign, nonatomic) NSInteger carId;
@property (strong, nonatomic) NSDate *lastDate;
@property (copy, nonatomic) NSString *camelCaseTest;

@end
</pre>
</td>
</tr>
</table>

####<a id="delegate_custom_format"></a>customFormat:value:
```objectivec
//jsonString = @"{\"date\":\"2015/07/11\"}"
- (id)customFormat:(NSString *)keyPath value:(id)value {
    if ([keyPath isEqualToString:@"date"]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy/MM/dd";
        NSDate *date = [formatter dateFromString:value];
        return date;
    }
    return value;
}
```

###<a id="solution"></a>Solution for Some Cases 【特殊情况下的解决办法】

####<a id="one_many"></a>1.One json key to many object keys  【一个json键对应多个object键】

Use customFormat 【通过customFormat】

```objectivec
- (id)customFormat:(NSString *)keyPath value:(id)value {
    if ([keyPath isEqualToString:@"propertyKey"]) {
    	self.b = value;
    	self.c = value;
    }
    return value;
}
```

####<a id="many_one"></a>2.Many json keys to one object key 【多个json键对应一个object键】

Use customReferenceDict  【通过customReferenceDict】

```objectivec
+ (NSDictionary *)customReferenceDict {
    return @{
             @"json_key_1": @"propertyKey",
             @"json_key_2": @"propertyKey",
             @"json_key_3": @"propertyKey",
             };
}
```

PS: Many json keys should be exclusionary.【多个json键之间应该是互斥的，不应该同时出现。】

##<a id="compare"></a>Compare with other framework【框架对比】

There is a comparison for `JsonReciprocity`, `MJExtension`, `JSONModel`, `Mantle`.<br>
Convert a complex JsonString to JsonObject for 1, 5 ,10, 20 ,50 times. 

【`JsonReciprocity`、`MJExtension`、`JSONModel`、`Mantle`之间的用法对比。】<br>
【一个相对复杂的JsonString转换为JsonObject，转换1、5、10、20、50次所花费的时间，单位秒。】

Framework | 1	| 5		| 10 	  | 20		| 50
----|----|----|----|----|----
JsonReciprocity | 0.00257 | 0.01566 | 0.01882 | 0.04048 | 0.09789 
MJExtension 	| 0.00292 | 0.01692 | 0.02674 | 0.04568 | 0.11325
JsonModel 		| 0.00553 | 0.02781 | 0.05554 | 0.09780 | 0.23649
Mantel 			| 0.01668 | 0.06899 | 0.12888 | 0.23499 | 0.53936

![chart](http://i1.tietuku.com/737c09cbdcf37223.jpg)

For data, JsonReciprocity ≈ MJExtension > JSONModel > Mantle, time rate is about 1 : 1.1 : 2.2 : 5.3.

【从测试数据来看，JsonReciprocity ≈ MJExtension > JSONModel > Mantle，时间比大约是1 : 1.1 : 2.2 : 5.3。】

This is only one Tests here, everybody can make more other Tests.

【这只是其中一个例子，可能不太全面，大家可以自行用其他测试例子试试。】

PS：Tests example with data in `ObjectSerializationTests`.【对比的例子与数据在`ObjectSerializationTests`】

##<a id="more"></a>More  【其他用法】

More cases reference to `JsonReciporcity Demo` and `JsonReciporcity Tests` 【更多的用法可以查看Demo和Tests】

##<a id="about"></a>About (关于)

###<a id="writer"></a>Writer 【作者信息】
GitHub主页:[Javen](https://github.com/javenl)<br>
QQ：412775083<br>
Email：412775083@qq.com<br>

###<a id="issue"></a>Issue 【任何问题】

* Communication with email or QQ.
* If find bugs, feedback to me immediately.
* If need some feature, feedback to me.
* If some better idea, feedback to me.
* If you want contribution, Pull Requests.

* 想交流的可以加qq和发邮件
* 如果发现任何bug，希望你立即告诉我
* 希望有什么新功能，请尽管告诉我
* 如果用起来觉得那里不爽的，欢迎吐槽我
* 如果你想为贡献代码，Pull Requests即可

