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

#pragma mark - Hoist Config

- (void)setApiKey:(NSString *)apiKey
{
    _apiKey = apiKey;
    self.urlSessionConfiguration.HTTPAdditionalHeaders = [self headersForHoistUrlSession];
}

#pragma mark - Hoist Data

- (void)fetchObjectForType:(NSString *)type objectId:(NSString *)objectId completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", kHoistApiDataUrl, type, objectId]];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.allHTTPHeaderFields = [self headersForHoistUrlSession];
    
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:request completionHandler:completion];
    
    [task resume];
}

- (void)fetchObjectsForType:(NSString *)type completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kHoistApiDataUrl, type]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.allHTTPHeaderFields = [self headersForHoistUrlSession];
    
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:request completionHandler:completion];
    
    [task resume];
}

- (void)saveObject:(NSDictionary *)dictionary forType:(NSString *)type completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kHoistApiDataUrl, type]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.allHTTPHeaderFields = [self headersForHoistUrlSession];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:request completionHandler:completion];
    
    [task resume];
}

- (void)deleteObjectWithID:(NSString *)objectId forType:(NSString *)type completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", kHoistApiDataUrl, type, objectId]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.allHTTPHeaderFields = [self headersForHoistUrlSession];
    request.HTTPMethod = @"DELETE";
    
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:request completionHandler:completion];
    
    [task resume];
}

- (void)deleteAllForType:(NSString *)type completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kHoistApiDataUrl, type]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.allHTTPHeaderFields = [self headersForHoistUrlSession];
    request.HTTPMethod = @"DELETE";
    
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:request completionHandler:completion];
    
    [task resume];
}

#pragma mark - Getters

- (NSURLSessionConfiguration *)urlSessionConfiguration
{
    if (!_urlSessionConfiguration) {
        _urlSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _urlSessionConfiguration.HTTPAdditionalHeaders = [self headersForHoistUrlSession];
    }
    return _urlSessionConfiguration;
}

- (NSDictionary *)headersForHoistUrlSession
{
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"application/json", @"Accept",
                                    @"application/json", @"Content-Type", nil];
    if (self.apiKey) {
        [headers setObject:[NSString stringWithFormat:@"Hoist %@", self.apiKey] forKey:@"Authorization"];
    }

    return headers;
}

@end
