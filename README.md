## RPFeedback Framework for iOS
RPFeedback is an iOS framework for the [ReviewPush](https://www.reviewpush.com) company level [API](http://developer.reviewpush.com/REST_API/Company_API/Overview.html). It offers a networking class and UI to easily submit feedback for individual company locations.

#### Getting Started
RPFeedback is available on [CocoaPods](https://cocoapods.org). Add the following to your Podfile:

`pod 'RPFeedback'`

#### Requirements

| RPFeedback Version | Minimum iOS Version  | ARC      |
| :------------------: |:---------------------:| :--------: |
| 1.x                | iOS 7                 | Required |

If you have not already done so, set `NSLocationAlwaysUsageDescription` and `NSLocationUsageDescription` in your app Info.plist.

### Usage

#### FeedbackViewController

Initialize the view controller with the following 

**Required**

- API Key
- API Secret

**Optional**

- Feedback model object (optional). If you set the location (model) with a location identifier, the locations view will be bypassed.

```
Feedback *feedback = [Feedback new]; 

RPFeedbackViewController *viewController  
= [[RPFeedbackViewController alloc] initWithFeedback:feedback APIKey:@"api-key-goes-here" APISecret:@"api-secret-goes-here"];
viewController.modalPresentationStyle = UIModalPresentationCustom; // This is important! Please set.

[self presentViewController:viewController animated:NO completion:nil];
```

#### Client 

##### Setup 

Import RPFeedback

`#import <RPFeedback/RPFeedbackClient.h>`

Initialize the client with your company level API Key/Secret combination.

    ReviewPushFeedbackClient *client 
    = [ReviewPushFeedbackClient sharedClientWithKey:@"company-api-key-goes-here"      
                                             secret:@"company-api-secret-goes-here"];

#### GET Location

Initialize a Location model object and set the identifier property (to the location ID you would like.) 

    Location *location  = [Location new]; 
    location.identifier = @"id-goes-here";

Make request

     [client GETLocation:location completion:^(BOOL success, 
                                               Location *location, 
                                               NSString *errorMessage) 
      { 
         if(success) {
            NSLog(@"location: %@:", location");
         } else {
           NSLog(@"error: %@:", errorMessage");
         }
     }]

#### GET Locations (near coordinates via CLLocation)

Supply a CLLocation object. This can be initialized however you would like – by supplying coordinatess or getting it by nearnest location.  

    CLLocation *location = [[CLLocation alloc] initWithLatitude:30.2500 longitude:97.7500]; // Austin, TX :)

Make request

    [client GETLocationsNearLocation:location completion:^(BOOL success, NSArray *locations, NSString *errorMessage)     {
      if(success) {
        NSLog(@"locations: %@:", locations");
      } else {
        NSLog(@"error: %@:", errorMessage");
      }
    }];

#### POST Feedback

Initialize Feedback object with a rating value, feedback, and a Location object. The location object must supply an identifier.

    Feedback *feedback   = [Feedback new];
    feedback.ratingValue = 4.0; // 1.0 to 5.0 review
    feedback.feedback    = @"This place rocks";
    feedback.location    = location; // This must have an 'identifier' property set. 
    
Make the request. The completion block passes back a feedback object and in some scenarios, review site links. The links are used for sharing feedback on other sites. 

    [client POSTFeedback:feedback completion:^(BOOL success,
                                               Feedback *feedback,
                                               NSDictionary *reviewSiteLinks,
                                               NSString *errorMessage)
    {
      if(success) {
        NSLog(@"feedback: %@", feedback);
      } else {
        NSLog(@"errorString: %@", errorString);
      }
    }];

### Credits and 3rd party dependencies
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [JSONModel](https://github.com/icanzilb/JSONModel)
* [JSONModel](https://github.com/icanzilb/JSONModel)
* [INTULocationManager](https://github.com/intuit/LocationManager)
* [SZTextView](https://github.com/glaszig/SZTextView)

### License
RPFeedback is released under the MIT license. See LICENSE for details.
