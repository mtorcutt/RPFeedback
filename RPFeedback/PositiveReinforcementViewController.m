//
//  PositiveReinforcementViewController.m
//  Review Push Sample
//
//  Created by Michael Orcutt on 10/28/15.
//  Copyright © 2015 Review Push. All rights reserved.
//

#import "PositiveReinforcementViewController.h"

#import "TransparentTableViewCell.h"
#import "MultipleLineTitle.h"
#import "RPReviewSite.h"

NSString * const PositiveReinforcementViewControllerTableViewCellIdentifier = @"PositiveReinforcementViewControllerTableViewCellIdentifier";

@interface PositiveReinforcementViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MultipleLineTitle *titleView;
@property (nonatomic, strong) UIView *topSeparator;
@property (nonatomic, strong) UIView *bottomSeparator;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation PositiveReinforcementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.insertDismissButton = YES;
    
    self.tableView                 = [[UITableView alloc] initWithFrame:CGRectZero
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
           forCellReuseIdentifier:PositiveReinforcementViewControllerTableViewCellIdentifier];
    
    [self.view addSubview:self.tableView];
    
    self.titleView                      = [MultipleLineTitle new];
    self.titleView.textLabel.text       = @"We love positive reviews!";
    self.titleView.detailTextLabel.text = @"Would you like to share this with friends?";
    self.titleView.alpha                = 0.0;
    
    [self.view addSubview:self.titleView];
    
    self.topSeparator                 = [UIView new];
    self.topSeparator.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.20];
    self.topSeparator.alpha           = 0.0;
    
    [self.view addSubview:self.topSeparator];
    
    self.topSeparator                 = [UIView new];
    self.topSeparator.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.20];
    self.topSeparator.alpha           = 0.0;
    
    [self.view addSubview:self.topSeparator];
    
    self.dataSource = [NSMutableArray new];
    
    [self.reviewSites enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key,
                                                          id  _Nonnull obj,
                                                          BOOL * _Nonnull stop)
    {
        
        RPReviewSite *site = [RPReviewSite new];
        site.title       = key;
        site.link        = [obj valueForKey:@"url"];
        
        [self.dataSource addObject:site];
        
    }];
    
    [self.tableView reloadData];
    [self layoutSubviews];
    
    [UIView animateWithDuration:.35 animations:^{
        self.tableView.alpha       = 1.0;
        self.titleView.alpha       = 1.0;
        self.topSeparator.alpha    = 1.0;
        self.bottomSeparator.alpha = 1.0;
    }];
    
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
    
    CGSize tableViewSize = self.tableView.contentSize;
    
//    CGFloat navigationBarHeight = 64.0;
    
    CGRect titleViewFrame     = CGRectZero;
    titleViewFrame.size
    = [self.titleView sizeThatFits:CGSizeMake(boundsSize.width - 30.0, CGFLOAT_MAX)];
    titleViewFrame.origin.x   = (boundsSize.width - titleViewFrame.size.width)/2.0;
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransparentTableViewCell *cell
    = [tableView dequeueReusableCellWithIdentifier:PositiveReinforcementViewControllerTableViewCellIdentifier];
    
    RPReviewSite *site = self.dataSource[indexPath.row];
    
    cell.textLabel.text = site.title;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RPReviewSite *site = self.dataSource[indexPath.row];

    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:site.link]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:site.link]];
    }
}

@end
