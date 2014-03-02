# Hoist

[![Version](http://cocoapod-badges.herokuapp.com/v/Hoist/badge.png)](http://cocoadocs.org/docsets/Hoist)
[![Platform](http://cocoapod-badges.herokuapp.com/p/Hoist/badge.png)](http://cocoadocs.org/docsets/Hoist)

From the [Hoist Apps Website](http://hoistapps.com/):

Hoist's hosting and set of APIs are designed around making your development
	easier, without taking control out of your hands.

This Hoist client library for your iOS projects. Use Hoist as a datastore for objects.

## Get started

Hoist is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "Hoist"

or check out the example project in the Example folder.

## Usage

#####For now I've only implemented the `data.hoi.io` API methods, as found in the [documentation](http://docs.hoi.io/api-docs/data.html).

I will work to add the user, notification and the file API's in the future.

### Hoist.h

I hate libraries that take too much control away from you, and standing alongside Hoist's tag line, this library won't take any control away from you, so there are two ways one can use this library.

The Hoist class is a singleton that will take care of the HTTP Requests to Hoist. Simply set the ApiKey of your application as found on your Hoist application's dashboard

	[[Hoist shared] setApiKey:@"EZYRNDNOEEXGQWHNJLMJ"];

The Hoist class then has a few methods to Fetch, Save/Update and Delete objects/models.

	- (void)fetchObjectForType:(NSString *)type objectId:(NSString *)objectId completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion;
	- (void)fetchObjectsForType:(NSString *)type completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion;
	- (void)saveObject:(NSDictionary *)dictionary forType:(NSString *)type completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion;
	- (void)deleteObjectWithID:(NSString *)objectId forType:(NSString *)type completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion;
	- (void)deleteAllForType:(NSString *)type completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion;

These methods provide you with the ability to write your own object mapping. Though if you're not feeling up to that...

### HoistObject.h

Designed to be subclassed, the HoistObject class has a few helper methods that make working with Hoist objects really easy.

Create a subclass of `HoistObject` with the same name as the Hoist model. Let's say we created a `BlogPost` object.

The `BlogPost` object now has a few methods that make saving it to Hoist really easy.

#####Class methods avaliable

	+ (void)fetchAllWithCompletion:(void (^)(NSArray *objects, HoistResponseStatusCode responseCode))completion;
	+ (void)fetchByObjectId:(NSString *)objectId completion:(void (^)(id object, HoistResponseStatusCode responseCode))completion;
	+ (void)deleteAll;
	+ (void)deleteAllWithCompletion:(void (^)(HoistResponseStatusCode responseCode))completion;

Objects are automatically decoded from the JSON reponse as long as the properties are called the same as the JSON keys.

If for some reason you want to have different property names than JSON keys you can override the `- (NSDictionary *)propertyToJSONMappings`. Just make sure you add any keys to the `propertyToJSONMappings` returned from `[super propertyToJSONMappings]` - See the example project for an example.

#####Instance methods avaliable

	- (void)save;
	- (void)saveWithCompletion:(void (^)(HoistResponseStatusCode responseCode))completion;
	- (void)delete;
	- (void)deleteWithCompletion:(void (^)(HoistResponseStatusCode responseCode))completion;

#####Automagical NSDate Parsing

Any HoistObject Dates are automatically parsed/stored with a RFC3339 date format. This is the same date format as what Hoist uses to store the `createdAt` and `updatedAt` dates.

If you would like to parse/store the date in a different format for your custom object properties, you can! All you need to do is create a function in your HoistObject subclass with the same name of your date property with "DateFormat" added to the end.

Say for example we have a `publishedDate` NSDate property on our BlogPost object. We just need to define the `- (NSString *)publishedDateFormat` function and return our custom date format string ("propertyName" + "Format"). Then we get automapping to and from the property/json!

Not sure how well I explained this, but there is an example in the project that maps the blogPost's `publishedDate` to the json key `jsonPubDate` using a custom date format :)

###Example

These two classes make it really easy to do something like this 
```ObjectiveC
// Set the API Key
[[Hoist shared] setApiKey:@"EZYRNDNOEEXGQWHNJLMJ"];
    
// Fetch all BlogPosts
[BlogPost fetchAllWithCompletion:^(NSArray *objects, HoistResponseStatusCode responseCode) 	{
        
    if (responseCode == HoistResponseStatusCodeOk) {
            
        // If there isn't a BlogPost
        if (![objects count]) {
                
            // Let's create one, and save it
            BlogPost *blogPost = [BlogPost new];
            blogPost.title = @"Blog Post Title!";
            blogPost.body = @"Body of the blog post.";
            blogPost.views = @(0);
            blogPost.draft = YES;
            blogPost.publishedDate = [NSDate dateWithTimeIntervalSinceNow:-10000];
            [blogPost save];
                
        } else {
                
            // Get the first BlogPost
            BlogPost *blogPost = [objects firstObject];
                
            // We can then change things and call save to update the object
            blogPost.views = @([blogPost.views integerValue] + 1);
            [blogPost saveWithCompletion:^(HoistResponseStatusCode responseCode) {
                    NSLog(@"Saved with: %@", NSStringFromHoistResponseStatusCode(responseCode));
            }];
                
        }
        NSLog(@"%@", objects);
    } else {
        NSLog(@"%@", NSStringFromHoistResponseStatusCode(responseCode));
    }
}];
```

Be sure to check out the [BlogPost.m](Project/HoistExample/BlogPost.m) and [BlogPost.h](Project/HoistExample/BlogPost.h) HoistObject too.

## Requirements

Project is built for iOS7+

## Author

Will Townsend, will@townsend.io, [@vfxguynz](https://twitter.com/vfxguynz)

## License

Hoist is available under the MIT license. See the LICENSE file for more info.

