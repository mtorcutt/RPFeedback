//
//  LocationManagerViewController.m
//  Review Push Sample
//
//  Created by Michael Orcutt on 10/27/15.
//  Copyright © 2015 Review Push. All rights reserved.
//

#import "LocationManagerViewController.h"
#import "INTULocationManager.h"
#import "RPFeedbackClient.h"
#import "FeedbackViewController.h"
#import "TransparentTableViewCell.h"
#import "MultipleLineTitle.h"

NSString * const LocationManagerViewControllerTableViewCellIdentifier = @"LocationManagerViewControllerTableViewCellIdentifier";

@interface LocationManagerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MultipleLineTitle *titleView;
@property (nonatomic, strong) UIView *topSeparator;
@property (nonatomic, strong) UIView *bottomSeparator;

@end

@implementation LocationManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.insertDismissButton = YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                  style:UITableViewStylePlain];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor  = [UIColor colorWithWhite:1.0 alpha:.20];
    self.tableView.alpha           = 0.0;
    self.tableView.separatorInset  = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset    = UIEdgeInsetsZero;
    self.tableView.separatorInset  = UIEdgeInsetsZero;
    
    [self.tableView registerClass:[TransparentTableViewCell class]
           forCellReuseIdentifier:LocationManagerViewControllerTableViewCellIdentifier];
    
    [self.view addSubview:self.tableView];
    
    self.titleView       = [MultipleLineTitle new];
    self.titleView.alpha = 0.0;
    
    [self.view addSubview:self.titleView];
    
    self.topSeparator                 = [UIView new];
    self.topSeparator.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.20];
    self.topSeparator.alpha           = 0.0;
    
    [self.view addSubview:self.topSeparator];

    self.topSeparator                 = [UIView new];
    self.topSeparator.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.20];
    self.topSeparator.alpha           = 0.0;
    
    [self.view addSubview:self.topSeparator];

    if(self.feedback.location.identifier.length > 0) {
        [self refreshLocation];
    } else {
        [self refreshLocations];
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self layoutSubviews];
}

- (void)layoutSubviews {
    
    CGSize boundsSize = self.view.bounds.size;
    
    [self.titleView sizeToFit];
    
    CGSize tableViewSize = self.tableView.contentSize;
    
    // CGFloat navigationBarHeight = 64.0;
    
    CGRect titleViewFrame     = self.titleView.frame;
    titleViewFrame.origin.x   = 15.0;
    titleViewFrame.size.width = (boundsSize.width - 30.0);
    
    self.titleView.frame = titleViewFrame;
    
    CGRect topSeparatorFrame = CGRectZero;
    topSeparatorFrame.size   = CGSizeMake(boundsSize.width - 30.0, .50);
    
    CGRect tableViewFrame     = CGRectZero;
    tableViewFrame.size.width = boundsSize.width;
    
    if(titleViewFrame.size.height + tableViewSize.height <= (boundsSize.height - 64.0 - 15.0)) {
        tableViewFrame.size.height
        = tableViewSize.height;
        titleViewFrame.origin.y
        = (boundsSize.height - tableViewSize.height - titleViewFrame.size.height - 15.0)/2.0;
    } else {
        tableViewFrame.size.height = boundsSize.height - tableViewFrame.origin.y - 15.5;;
        titleViewFrame.origin.y    = 64.0;
    }
    
    topSeparatorFrame.origin = CGPointMake(15.0, CGRectGetMaxY(titleViewFrame) + 15.0);
    tableViewFrame.origin = CGPointMake(0.0, CGRectGetMaxY(topSeparatorFrame));

    self.titleView.frame    = titleViewFrame;
    self.topSeparator.frame = topSeparatorFrame;
    self.tableView.frame    = tableViewFrame;
}

#pragma mark - Networking

- (void)refreshLocation {
    
    [[RPFeedbackClient sharedClientWithKey:self.APIKey
                                    secret:self.APISecret]
     GETLocation:self.feedback.location completion:^(BOOL success, Location *location, NSString *errorMessage) {

         if(success) {
             
             self.feedback.location = location;
            
             FeedbackViewController *feedbackViewController = [FeedbackViewController new];
             feedbackViewController.feedback                = self.feedback;
             
             [self.navigationController pushViewController:feedbackViewController animated:YES];
            
         } else {
             
             [self refreshLocations];
             
         }
         
     }];

    
}

- (void)refreshLocations {
    
    [self displayActivityIndicatorViewAnimated:NO];

    __block dispatch_group_t group = dispatch_group_create();
    
    __block BOOL locationSuccess = YES;
    __block CLLocation *location = nil;
    
    dispatch_group_enter(group);
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
                                                                     timeout:30.0
                                                                       block:^(CLLocation *currentLocation,
                                                                               INTULocationAccuracy achievedAccuracy,
                                                                               INTULocationStatus status)
    {
         
         if(status == INTULocationStatusSuccess) {
             location = currentLocation;
         } else {
             locationSuccess = NO;
         }

        dispatch_group_leave(group);
        
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if(locationSuccess == NO) {
            [self displayMessageViewAnimated:YES
                                       image:nil
                                       title:@"Location Error"
                                  detailText:@"We could not retrieve your location."
                                 buttonTitle:nil
                                buttonTapped:nil];
            [self removeActivityIndicatorViewAnimated:YES];
            return;
        }
        
        [[RPFeedbackClient sharedClientWithKey:self.APIKey
                                        secret:self.APISecret]
         GETLocationsNearLocation:location completion:^(BOOL success, NSArray *locations, NSString *errorMessage) {
             
             if(success) {
                 
                 self.locations = locations;
                 
                 if(self.locations.count == 1) {
                     
                     // There is only one location to choose from,
                     // let's push the user along.
                     FeedbackViewController *feedbackViewController = [FeedbackViewController new];
                     
                     self.feedback.location = [self.locations firstObject];
                     
                     feedbackViewController.feedback = self.feedback;
                     
                     [self.navigationController pushViewController:feedbackViewController animated:YES];
                     
                 } else if(self.locations.count == 0) {
                     
                     [self removeActivityIndicatorViewAnimated:YES];
                     [self displayMessageViewAnimated:YES
                                                image:nil
                                                title:@"Locations"
                                           detailText:@"No locations were returned."
                                          buttonTitle:nil
                                         buttonTapped:nil];
                     
                 } else {
                     
                     Location *location = [self.locations firstObject];
                     
                     self.titleView.textLabel.text       = location.name;
                     self.titleView.detailTextLabel.text = @"Please select your location.";
                     
                     [self layoutSubviews];
                     [self.tableView reloadData];
                     [self removeActivityIndicatorViewAnimated:YES];
                     
                     [UIView animateWithDuration:.35 animations:^{
                         self.titleView.alpha    = 1.0;
                         self.topSeparator.alpha = 1.0;
                         self.tableView.alpha    = 1.0;
                     }];
                     
                 }

             } else {

                 [self removeActivityIndicatorViewAnimated:YES];
                 [self displayMessageViewAnimated:YES
                                            image:nil
                                            title:@"Locations"
                                       detailText:@"There was an error. We could not retrieve any locations at the moment."
                                      buttonTitle:nil
                                     buttonTapped:nil];
                 return;

             }
             
         }];
        
    });
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransparentTableViewCell *cell
    = [tableView dequeueReusableCellWithIdentifier:LocationManagerViewControllerTableViewCellIdentifier];
    
    Location *location = self.locations[indexPath.row];
    
    cell.textLabel.attributedText = location.addressAtrributedString;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Location *location = self.locations[indexPath.row];
    
    CGSize maxSize = CGSizeMake(self.view.bounds.size.width - 30.0, CGFLOAT_MAX);
    
    return [location.addressAtrributedString boundingRectWithSize:maxSize
                                                          options:(NSStringDrawingUsesFontLeading |
                                                                   NSStringDrawingUsesLineFragmentOrigin)
                                                          context:nil].size.height + 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FeedbackViewController *feedbackViewController = [FeedbackViewController new];
    
    self.feedback.location = self.locations[indexPath.row];
    
    feedbackViewController.feedback = self.feedback;
    
    [self.navigationController pushViewController:feedbackViewController animated:YES];
}

@end
