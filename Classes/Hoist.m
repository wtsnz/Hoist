//
//  Hoist.m
//  Hoist
//
//  Created by Will Townsend on 20/02/14.
//  Copyright (c) 2014 Will Townsend. All rights reserved.
//

#import "Hoist.h"
#import "HoistObject.h"

@interface Hoist ()

@property (strong, nonatomic) NSString *apiKey;
@property (strong, nonatomic) NSURLSession *urlSession;
@property (strong, nonatomic) NSURLSessionConfiguration *urlSessionConfiguration;

@end

@implementation Hoist

static NSString *kHoistApiDataUrl = @"https://data.hoi.io";

#pragma mark - Class

+ (Hoist *)shared
{
    static Hoist *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

#pragma mark - NSObject

- (instancetype)init
{
    if (self = [super init]) {
        self.urlSession = [NSURLSession sessionWithConfiguration:self.urlSessionConfiguration];
    }
    return self;
}

#pragma mark - Hoist Data

- (void)fetchObjectForType:(NSString *)type objectId:(NSString *)objectId completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", kHoistApiDataUrl, type, objectId]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.allHTTPHeaderFields = [self headersForDataRequest];
    
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:request completionHandler:completion];
    
    [task resume];
}

- (void)fetchObjectsForType:(NSString *)type completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kHoistApiDataUrl, type]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.allHTTPHeaderFields = [self headersForDataRequest];
    
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:request completionHandler:completion];
    
    [task resume];
}

- (void)saveObject:(NSDictionary *)dictionary forType:(NSString *)type completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kHoistApiDataUrl, type]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.allHTTPHeaderFields = [self headersForDataRequest];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:request completionHandler:completion];
    
    [task resume];
}

- (void)deleteObjectWithID:(NSString *)objectId forType:(NSString *)type completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", kHoistApiDataUrl, type, objectId]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.allHTTPHeaderFields = [self headersForDataRequest];
    request.HTTPMethod = @"DELETE";
    
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:request completionHandler:completion];
    
    [task resume];
}

- (void)deleteAllForType:(NSString *)type completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kHoistApiDataUrl, type]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.allHTTPHeaderFields = [self headersForDataRequest];
    request.HTTPMethod = @"DELETE";
    
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:request completionHandler:completion];
    
    [task resume];
}

#pragma mark - Getters

- (NSURLSessionConfiguration *)urlSessionConfiguration
{
    if (!_urlSessionConfiguration) {
        _urlSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    return _urlSessionConfiguration;
}

- (NSMutableDictionary *)authorizationHeader
{
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    if (self.apiKey) {
        [headers setObject:[NSString stringWithFormat:@"Hoist %@", self.apiKey] forKey:@"Authorization"];
    }
    return headers;
}

- (NSDictionary *)headersForDataRequest
{
    NSMutableDictionary *headers = [self authorizationHeader];
    
    [headers setObject:@"application/json" forKey:@"Content-Type"];
    [headers setObject:@"application/json" forKey:@"Accept"];
    
    return headers;
}

NSString *NSStringFromHoistResponseStatusCode(HoistResponseStatusCode code)
{
    switch (code) {
        case HoistResponseStatusCodeOk:
            return @"Hoist Reponse Code: 200 - Everything is all good";
            break;
        case HoistResponseStatusCodeCreated:
            return @"Hoist Reponse Code: 201 - Created okay";
            break;
        case HoistResponseStatusCodeUnauthorised:
            return @"Hoist Reponse Code: 401 - Unauthorised";
            break;
        case HoistResponseStatusCodeNotFound:
            return @"Hoist Reponse Code: 404 - Not found";
            break;
        case HoistResponseStatusCodeConflict:
            return @"Hoist Reponse Code: 409 - Conflict";
            break;
        case HoistResponseStatusCodeError:
            return @"Hoist Reponse Code: -1 - Unknown error";
            break;
        default:
            return @"Hoist Reponse Code: ?? - Unknown response code";
            break;
    }
}

#pragma mark - Setters

- (void)setApiKey:(NSString *)apiKey
{
    _apiKey = apiKey;
    // Update the Authorization header
    self.urlSessionConfiguration.HTTPAdditionalHeaders = [self authorizationHeader];
}

@end
