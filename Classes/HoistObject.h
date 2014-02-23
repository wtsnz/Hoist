//
//  HoistObject.h
//  Hoist
//
//  Created by Will Townsend on 20/02/14.
//  Copyright (c) 2014 Will Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "Hoist.h"

@interface HoistObject : NSObject

/**
 The default Hoist _createdDate property
 */
@property (strong, nonatomic) NSDate *createdDate;
/**
 The default Hoist _updatedAt property
 */
@property (strong, nonatomic) NSDate *updatedDate;
/**
 The default Hoist _id property
 */
@property (strong, nonatomic) NSString *objectId;
/**
 The default Hoist _rev property
 */
@property (strong, nonatomic) NSString *rev;
/**
 The default Hoist _type property
 */
@property (strong, nonatomic) NSString *type;

/**
 Fetch all of the object type.
 
 @param completion The completion block to be executed when the task finishes. This block has no return value and takes two arguments: an array of decoded objects and the HoistResponseCode.
 */
+ (void)fetchAllWithCompletion:(void (^)(NSArray *objects, HoistResponseStatusCode responseCode))completion;

/**
 Fetch the object by id.
 
 @param completion The completion block to be executed when the task finishes. This block has no return value and takes two arguments: the decoded HoistObject object and the HoistResponseCode.
 */
+ (void)fetchByObjectId:(NSString *)objectId completion:(void (^)(id object, HoistResponseStatusCode responseCode))completion;

/**
 Delete all of the HoistObjects
 */
+ (void)deleteAll;

/**
 Delete all of the HoistObject(s) with a callback
 
 @param completion The completion block to be executed when the task finishes. This block has no return value and takes one arguments: the HoistResponseCode.
 */
+ (void)deleteAllWithCompletion:(void (^)(HoistResponseStatusCode responseCode))completion;

/**
 Save the HoistObject
 
 @param completion The completion block to be executed when the task finishes. This block has no return value and takes one arguments: the HoistResponseCode.
 */
- (void)save;

/**
 Save the HoistObject with a callback
 
 @param completion The completion block to be executed when the task finishes. This block has no return value and takes one arguments: the HoistResponseCode.
 */
- (void)saveWithCompletion:(void (^)(HoistResponseStatusCode responseCode))completion;

/**
 Delete the HoistObject
 */
- (void)delete;

/**
 Delete the HoistObject with a callback
 
 @param completion The completion block to be executed when the task finishes. This block has no return value and takes one arguments: the HoistResponseCode.
 */
- (void)deleteWithCompletion:(void (^)(HoistResponseStatusCode responseCode))completion;

/**
 Configure the HoistObject from an NSDictionary
 
 @param dictionary The NSDictionary containing the keys and values that will map to the HoistObject
 */
- (void)configureWithDictionary:(NSDictionary *)dictionary;

/**
 Dictionary of Object Properties to JSON Mappings
 
 Subclasses of HoistObject can override this to provide custom mappings. Make sure to add to the [super configureWithDictionary]
*/
- (NSDictionary *)propertyToJSONMappings;

@end
