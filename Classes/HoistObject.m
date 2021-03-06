//
//  HoistObject.m
//  Hoist
//
//  Created by Will Townsend on 20/02/14.
//  Copyright (c) 2014 Will Townsend. All rights reserved.
//

#import "HoistObject.h"

@implementation HoistObject

#pragma mark - Class

+ (void)fetchAllWithCompletion:(void (^)(NSArray *objects, HoistResponseStatusCode responseCode))completion
{
    
    [[Hoist shared] fetchObjectsForType:NSStringFromClass([self class]) completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            // If an error occurred, return with the status code
            if (error) {
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, [httpResponse statusCode]);
                    });
                }
                return;
            }
            
            // If everything appears okay parse JSON and convert to HoistObjects
            id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSMutableArray *hoistObjects = [NSMutableArray array];
                for (NSDictionary *dic in responseObject) {
                    
                    HoistObject *object = [[self class] new];
                    [object configureWithDictionary:dic];
                    [hoistObjects addObject:object];
                    
                }
                
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion([NSArray arrayWithArray:hoistObjects], [httpResponse statusCode]);
                    });
                }
                return;
            } else {
                // Unexpected response
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, [httpResponse statusCode]);
                    });
                }
                return;
            }
        }
        
        // What.
        NSLog(@"Host Object ERROR: %@ %@", error.localizedDescription, data);
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, HoistResponseStatusCodeUnknown);
            });
        }
        return;
    }];
}

+ (void)fetchByObjectId:(NSString *)objectId completion:(void (^)(id object, HoistResponseStatusCode responseCode))completion
{
    [[Hoist shared] fetchObjectForType:NSStringFromClass([self class]) objectId:objectId completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            // If error, return with the status code
            if (error) {
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, [httpResponse statusCode]);
                    });
                }
                return;
            }
            
            // Parse object
            id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                HoistObject *object = [[self class] new];
                [object configureWithDictionary:responseObject];
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(object, [httpResponse statusCode]);
                    });
                }
                return;
            } else {
                // Unexpected response
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, [httpResponse statusCode]);
                    });
                }
                return;
            }
        }
        
        // What.
        NSLog(@"Host Object ERROR: %@", error.localizedDescription);
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, HoistResponseStatusCodeUnknown);
            });
        }
        return;
    }];
}

+ (void)deleteAll
{
    [self deleteAllWithCompletion:nil];
}

+ (void)deleteAllWithCompletion:(void (^)(HoistResponseStatusCode responseCode))completion
{
    [[Hoist shared] deleteAllForType:NSStringFromClass([self class]) completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion([httpResponse statusCode]);
                });
            }
        } else {
            // What.
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(HoistResponseStatusCodeUnknown);
                });
            }
        }
    }];
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"{%@}", [self hoist_description]];
}

#pragma mark - Instance

- (void)save
{
    [self saveWithCompletion:nil];
}

- (void)saveWithCompletion:(void (^)(HoistResponseStatusCode responseCode))completion
{
    [[Hoist shared] saveObject:[self hoist_dictionaryRepresentation] forType:NSStringFromClass([self class]) completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion([httpResponse statusCode]);
                });
            }
        } else {
            // What.
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(HoistResponseStatusCodeUnknown);
                });
            }
        }
    }];
}

- (void)delete
{
    [self deleteWithCompletion:nil];
}

- (void)deleteWithCompletion:(void (^)(HoistResponseStatusCode responseCode))completion
{
    [[Hoist shared] deleteObjectWithID:self.objectId forType:NSStringFromClass([self class]) completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion([httpResponse statusCode]);
                });
            }
        } else {
            // What.
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(HoistResponseStatusCodeUnknown);
                });
            }
        }
        
    }];
}


- (void)configureWithDictionary:(NSDictionary *)dictionary
{
    //TODO: Add automatic type conversion. Strings only for now.
    // Auto set object properties. Crude for now.
    NSDictionary *mappings = [self propertyToJSONMappings];
    
    for (NSString *propertyName in [self hoist_propertyNames]) {
        
        NSString *key = propertyName;
        
        NSString *jsonKey = mappings[propertyName];
        
        if (jsonKey) {
            key = jsonKey;
        }
        
        id obj = dictionary[key];
        if (obj) {
            
            // Figure out the property type
            NSString *className = [self hoist_classNameFromPropertyName:propertyName];
            Class class = NSClassFromString(className);
            
            // Set the primative, hope it works.
            if (!class) {
                [self setValue:obj forKey:propertyName];
            }
            // Set the object if they are the same kind
            else if ([obj isKindOfClass:class]) {
                [self setValue:obj forKey:propertyName];
            }
            // If the property is an NSDate and obj is NSString, we may have some conversion to do.
            else if ([NSDate class] == class && [obj isKindOfClass:[NSString class]]) {
                
                NSDateFormatter *dateFormatter = [self hoist_dateFormatterForPropertyName:propertyName];
                if (dateFormatter) {
                    NSDate *parsedDate = [dateFormatter dateFromString:obj];
                    [self setValue:parsedDate forKey:propertyName];
                }
            }
        }
    }
}

- (NSMutableDictionary *)propertyToJSONMappings
{
    // Make sure to call super if you override
    return [NSMutableDictionary
            dictionaryWithDictionary:@{
                            @"createdDate":@"_createdDate",
                            @"updatedDate": @"_updatedDate",
                            @"objectId": @"_id",
                            @"rev": @"_rev",
                            @"type": @"_type"}
            ];
}

- (NSString *)defaultDateFormat
{
    return @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
}

#pragma mark - Private Hoist Object Methods

- (NSArray *)hoist_propertyNames
{
    return [self hoist_propertyNamesForClass:[self class]];
}

- (NSArray *)hoist_propertyNamesForClass:(Class)class
{
    NSMutableArray *propertyNames = [NSMutableArray array];
    
    // Recurse, yolo
    Class superClass  = class_getSuperclass(class);
    if (superClass != nil && ![superClass isEqual:[NSObject class]]) {
        [propertyNames addObjectsFromArray:[self hoist_propertyNamesForClass:superClass]];
    }
    
    // Add properties to array
    unsigned int count = 0;
    
    objc_property_t *properties = class_copyPropertyList(class, &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [propertyNames addObject:key];
    }
    
    free(properties);
    
    return propertyNames;
}

- (NSString *)hoist_classNameFromPropertyName:(NSString *)propertyName
{
    // Get property and propertyAttributeDescription
    objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
    const char *attr = property_getAttributes(property);
    NSString *attributeDescription = [NSString stringWithCString:attr encoding:NSUTF8StringEncoding];
    
    // Deal with the first bit.
    attributeDescription = [[attributeDescription componentsSeparatedByString:@","] firstObject];
    
    NSString *className;
    BOOL isType = [[attributeDescription substringToIndex:1] isEqualToString:@"T"];
    BOOL isObject = [[attributeDescription substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"@"];
    
    if (isType && !isObject) {
        // No class, just a primative
        className = [attributeDescription substringWithRange:NSMakeRange(1, 1)];
    } else {
        // Object, get the class
        className = [attributeDescription substringWithRange:NSMakeRange(3, [attributeDescription length] - 4)];
    }
    return className;
}

- (NSDateFormatter *)hoist_dateFormatterForPropertyName:(NSString *)propertyName
{
    NSString *selectorName = [NSString stringWithFormat:@"%@Format", propertyName];
    SEL selector = NSSelectorFromString(selectorName);
    
    if (selector == NULL) {
        NSLog(@"Invalid selector");
    } else {
        
        if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            NSString *dateFormat = [self performSelector:selector];
#pragma clang diagnostic pop
            if (dateFormat) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = dateFormat;
                return dateFormatter;
            }
        }
    }
    
    // Else not implemented, use the default date formatter from HoistObject (RFC3339)
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = [self defaultDateFormat];
    return dateFormatter;
}

- (NSDictionary *)hoist_dictionaryRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    NSArray *propertyNames = [self hoist_propertyNames];
    
    NSDictionary *swappedKeys = [self propertyToJSONMappings];
    
    for (NSString *propertyName in propertyNames) {
        
        // Value to save/convert
        id value = [self valueForKey:propertyName];
        
        NSString *key = propertyName;
        if (swappedKeys[propertyName]) {
            key = swappedKeys[propertyName];
        }
        
        // Figure out the property type
        NSString *className = [self hoist_classNameFromPropertyName:propertyName];
        Class class = NSClassFromString(className);
        
        if ([NSDate class] == class) {
            
            NSDateFormatter *dateFormatter = [self hoist_dateFormatterForPropertyName:propertyName];
            
            if (dateFormatter) {
                NSString *parsedString = [dateFormatter stringFromDate:value];
                value = parsedString;
            } else {
                value = @"";
            }
        }
        
        if (value) {
            [dictionary setObject:value forKey:key];
        }
    }
    
    return dictionary;
}

- (NSString *)hoist_description
{
    NSMutableString *description = [NSMutableString string];
    NSArray *keys = [self hoist_propertyNames];
    
    for (NSInteger i = 0; i < [keys count]; i++) {
        
        NSString *key = keys[i];
        NSString *value = [self valueForKey:key];
        
        if (value) {
            [description appendFormat:@"%@ = %@", key, value];
        } else {
            // Null/nil?
            [description appendFormat:@"%@ = nil", key];
        }
        
        if (i+1 < [keys count]) {
            [description appendString:@", "];
        }
    }
    
    return description;
}

@end
