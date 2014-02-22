//
//  Hoist.h
//  Hoist
//
//  Created by Will Townsend on 20/02/14.
//  Copyright (c) 2014 Will Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HoistObject;

@interface Hoist : NSObject

/**
    HoistResponseStatusCode's should match up to standard HTTP status codes.
    Descriptions from the Hoist documentation.
 */
typedef NS_ENUM(NSInteger, HoistResponseStatusCode) {
    /** Everything is all good */
    HoistResponseStatusCodeOk = 200,
    /** A document was created without errors */
    HoistResponseStatusCodeCreated = 201,
    /** Hoist Authenticate header is incorrect */
    HoistResponseStatusCodeUnauthorised = 401,
    /** Data was not found with that Key */
    HoistResponseStatusCodeNotFound = 404,
    /** A Document with that id already exists and has a newer _rev value */
    HoistResponseStatusCodeConflict = 409,
    /** Email address or password missing */
    HoistResponseStatusCodeError = 500,
    /** Unknown error occurred */
    HoistResponseStatusCodeUnknown = -1,
};

/**
 The shared Hoist object
 */
+ (Hoist *)shared;

/**
 Fetches a single object using the objectId and type.
 
 @param type The model type of data you are retrieving
 @param objectId The id of the stores object
 @param completion The completion block to be executed when the task finishes. This block has no return value and takes three arguments: the returned data, the response and the error.
 */
- (void)fetchObjectForType:(NSString *)type objectId:(NSString *)objectId completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion;

/**
 Fetches all objects of the requested type.
 
 @param type The model type of data you are retrieving
 @param completion The completion block to be executed when the task finishes. This block has no return value and takes three arguments: the returned data, the response and the error.
 */
- (void)fetchObjectsForType:(NSString *)type completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion;

/**
 Save the object as the type
 
 @param dictionary The object to save.
 @param type The model type to save.
 @param completion The completion block to be executed when the task finishes. This block has no return value and takes three arguments: the returned data, the response and the error.
 */
- (void)saveObject:(NSDictionary *)dictionary forType:(NSString *)type completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion;

/**
 Delete the object with the specified id for the specified model type
 
 @param objectId The id of the object to delete.
 @param type The model type to save.
 @param completion The completion block to be executed when the task finishes. This block has no return value and takes three arguments: the returned data, the response and the error.
 */
- (void)deleteObjectWithID:(NSString *)objectId forType:(NSString *)type completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion;

/**
 Delete all the objects for the specified model type
 
 @param type The model type to save.
 @param completion The completion block to be executed when the task finishes. This block has no return value and takes three arguments: the returned data, the response and the error.
 */
- (void)deleteAllForType:(NSString *)type completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion;

/**
 Set the Hoist application key
 
 @param apiKey Your Hoist application api key.
 */
- (void)setApiKey:(NSString *)apiKey;

@end
