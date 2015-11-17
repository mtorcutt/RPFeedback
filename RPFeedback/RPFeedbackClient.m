//
//  ReviewPushClient.m
//  Review Push For Business
//
//  Created by Michael Orcutt on 7/29/15.
//  Copyright (c) 2015 ReviewPush. All rights reserved.
//

#import "RPFeedbackClient.h"

NSString * const ReviewPushFeedbackURLString       = @"feedback";
NSString * const ReviewPushLocationURLString       = @"locations";
NSString * const ReviewPushLocationFormatURLString = @"locations/%@";

@interface RPFeedbackClient ()

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *secret;

@end

@implementation RPFeedbackClient

#pragma mark - Initialization

+ (RPFeedbackClient *)sharedClientWithKey:(NSString *)key secret:(NSString *)secret {
    
    // Setup for client
    static RPFeedbackClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://dashboard.reviewpush.com/api/company"]];
        
        _sharedClient.requestSerializer  = [AFHTTPRequestSerializer serializer];
        
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.removesKeysWithNullValues = YES;
        
        _sharedClient.responseSerializer = responseSerializer;
        _sharedClient.requestSerializer  = [AFJSONRequestSerializer serializer];
        
    });
    
    _sharedClient.key    = key;
    _sharedClient.secret = secret;
    
    return _sharedClient;
}

#pragma mark - Request Helper 

- (NSDictionary *)authorizedParameterDictionaryWithDictionary:(NSDictionary *)dictionary {
    NSMutableDictionary *mutableDictionary = nil;
    if(dictionary != nil) {
        mutableDictionary = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    } else {
        mutableDictionary = [[NSMutableDictionary alloc] init];
    }
    
    [mutableDictionary setObject:self.key    forKey:@"api_key"];
    [mutableDictionary setObject:self.secret forKey:@"api_secret"];
    
    return mutableDictionary;
}

#pragma mark - Requests

- (void)POSTFeedback:(Feedback *)review completion:(void (^)(BOOL success, Feedback *feedBack, NSDictionary *reviewSiteLinks, NSString *errorString))completionBlock {
    
    NSDictionary *dictionary = @{ @"review"      : [NSString stringWithFormat:@"%@", review.feedback],
                                  @"rating"      : [NSString stringWithFormat:@"%ld", (long)review.ratingValue],
                                  @"email"       : [NSString stringWithFormat:@"%@", review.emailAddress],
                                  @"location_id" : [NSString stringWithFormat:@"%@", review.location.identifier],
                                  @"reviewer"    : [NSString stringWithFormat:@"%@", review.fullName] };
    
    NSDictionary *parameters = [self authorizedParameterDictionaryWithDictionary:dictionary];
    
    [self POST:ReviewPushFeedbackURLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(!completionBlock) {
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSError *error = nil;
            
            Feedback *feedback = [[Feedback alloc] initWithDictionary:responseObject[@"data"] error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(error) {
                    completionBlock(NO, nil, nil, nil);
                } else {
                    completionBlock(YES, feedback, responseObject[@"review_site_links"], nil);
                }
            });
            
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(completionBlock) {
            completionBlock(NO, nil, nil, nil);
        }

    }];
}

#pragma mark - RPLocations

- (void)GETLocationsNearLocation:(CLLocation *)location
                      completion:(void(^)(BOOL success,
                                          NSArray *locations,
                                          NSString *errorMessage))completionBlock {

    NSDictionary *parameters = nil;
    if(location != nil) {
        NSDictionary *dictionary = @{ @"latitude"  : @(location.coordinate.latitude),
                                      @"longitude" : @(location.coordinate.longitude) };
        
        parameters = [self authorizedParameterDictionaryWithDictionary:dictionary];
    } else {
        parameters = [self authorizedParameterDictionaryWithDictionary:nil];
    }
    
    [self GET:ReviewPushLocationURLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject %@", responseObject);
        
        if(!completionBlock) {
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableArray *locations = [NSMutableArray new];
            
            [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                NSError *error = nil;
                
                RPLocation *location = [[RPLocation alloc] initWithDictionary:obj error:&error];
                
                [locations addObject:location];
                
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(YES, locations, nil);
            });
            
        });
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"operation.responseObject %@", operation.responseObject);
        NSLog(@"error %@", error);

        if(completionBlock) {
            completionBlock(NO, nil, nil);
        }
        
    }];

}

- (void)GETLocation:(RPLocation *)location
         completion:(void(^)(BOOL success,
                             RPLocation *location,
                             NSString *errorMessage))completionBlock {
    
    NSDictionary *parameters = [self authorizedParameterDictionaryWithDictionary:nil];
    
    NSString *urlString = [NSString stringWithFormat:ReviewPushLocationFormatURLString, location.identifier];
    
    [self GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(!completionBlock) {
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSError *error = nil;
                
            RPLocation *location = [[RPLocation alloc] initWithDictionary:responseObject[@"data"] error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(error) {
                    completionBlock(NO, nil, nil);
                } else {
                    completionBlock(YES, location, nil);
                }
            });
            
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(completionBlock) {
            completionBlock(NO, nil, nil);
        }
        
    }];
    
}

@end
