//
//  BlogPost.m
//  HoistExample
//
//  Created by Will Townsend on 22/02/14.
//  Copyright (c) 2014 Will Townsend. All rights reserved.
//

#import "BlogPost.h"

@implementation BlogPost

- (NSDictionary *)propertyToJSONMappings
{
    NSMutableDictionary *mappings = [super propertyToJSONMappings];
    
    // Key is our property to map the json[object] to.
    [mappings setObject:@"jsonAuthor" forKey:@"author"];
    
    return mappings;
}

@end
