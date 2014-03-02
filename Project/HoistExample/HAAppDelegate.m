//
//  HAAppDelegate.m
//  HoistExample
//
//  Created by Will Townsend on 22/02/14.
//  Copyright (c) 2014 Will Townsend. All rights reserved.
//

#import "HAAppDelegate.h"

#import "Hoist.h"

#import "BlogPost.h"

@implementation HAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set the API Key
    [[Hoist shared] setApiKey:@"EZYRNDNOEEXGQWHNJLMJ"];
    
    // Fetch all BlogPosts
    [BlogPost fetchAllWithCompletion:^(NSArray *objects, HoistResponseStatusCode responseCode) {
        
        if (responseCode == HoistResponseStatusCodeOk) {
            
            // If there isn't a BlogPost
            if (![objects count]) {
                
                // Let's create one, and save it
                BlogPost *blogPost = [BlogPost new];
                blogPost.title = @"Blog Post Title!";
                blogPost.body = @"Body of the blog post.";
                blogPost.author = @"Will Townsend";
                blogPost.views = @(0);
                blogPost.draft = YES;
                blogPost.publishedDate = [NSDate dateWithTimeIntervalSinceNow:-10000];
                [blogPost save];
                
            } else {
                
                // Get the first BlogPost
                BlogPost *blogPost = [objects firstObject];
                
                // We can then change things and call save to update the object
                blogPost.views = @([blogPost.views integerValue] + 1);
                blogPost.draft = YES;
                
                [blogPost saveWithCompletion:^(HoistResponseStatusCode responseCode) {
                    NSLog(@"Saved with: %@", NSStringFromHoistResponseStatusCode(responseCode));
                }];
                
            }
            
            NSLog(@"%@", objects);
            
        } else {
            NSLog(@"%@", NSStringFromHoistResponseStatusCode(responseCode));
        }
        
    }];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
