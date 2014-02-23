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
    return [NSString stringWithFormat:@"[%@] - {%@}", NSStringFromClass([self class]), [self hoist_description]];
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
    
    for (NSString *property in [self hoist_propertyNames]) {
        
        NSString *key = property;
        
        NSString *jsonKey = mappings[property];
        
        if (jsonKey) {
            key = jsonKey;
        }
        
        id obj = dictionary[key];
        if (obj) {
            [self setValue:obj forKey:property];
        }
    }
}

- (NSDictionary *)propertyToJSONMappings
{
    // Make sure to call super if you override
    return @{@"createdDate": @"_createdDate",
             @"updatedDate": @"_updatedDate",
             @"objectId": @"_id",
             @"rev": @"_rev",
             @"type": @"_type"};
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

- (NSDictionary *)hoist_dictionaryRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    NSArray *keys = [self hoist_propertyNames];
    
    NSDictionary *swappedKeys = [self propertyToJSONMappings];
    
    for (NSString *key in keys) {
        
        if (swappedKeys[key]) {
            
            id value = [self valueForKey:key];
            if (value) {
                [dictionary setObject:value forKey:swappedKeys[key]];
            }
            
        } else {
            id value = [self valueForKey:key];
            if (value) {
                [dictionary setObject:value forKey:key];
            }
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
