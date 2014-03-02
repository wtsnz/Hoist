//
//  BlogPost.m
//  HoistExample
//
//  Created by Will Townsend on 22/02/14.
//  Copyright (c) 2014 Will Townsend. All rights reserved.
//

#import "BlogPost.h"

@implementation BlogPost

#pragma mark - Hoist Object Overrides

- (NSDictionary *)propertyToJSONMappings
{
    NSMutableDictionary *mappings = [super propertyToJSONMappings];
    
    // Key is our property to map the json[object] to.
    [mappings setObject:@"jsonAuthor" forKey:@"author"];
    
    return mappings;
}

#pragma mark - Date Formats

- (NSString *)publishedDateFormat
{
    return @"yyyy/MM/dd";
}

@end
