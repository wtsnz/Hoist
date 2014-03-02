//
//  BlogPost.h
//  HoistExample
//
//  Created by Will Townsend on 22/02/14.
//  Copyright (c) 2014 Will Townsend. All rights reserved.
//

#import "HoistObject.h"

@interface BlogPost : HoistObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSNumber *views;
@property (nonatomic) BOOL draft;

@end
