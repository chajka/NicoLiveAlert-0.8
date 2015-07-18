//
//  WatchlistController.m
//  NicoLiveAlert
//
//  Created by Чайка on 7/18/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import "WatchlistController.h"
#import "NicoLiveAlertDefinitions.h"
#import "NicoLiveAlertPreferenceDefinitions.h"

@interface WatchlistController ()

@end

@implementation WatchlistController
#pragma mark - synthesize properties
#pragma mark - class method
#pragma mark - constructor / destructor
#pragma mark - override
- (void) viewDidLoad
{
	[super viewDidLoad];
	NSArray *watchlist = [[NSUserDefaults standardUserDefaults] arrayForKey:SavedWatchListKey];
	[aryctrlWatchlist addObjects:watchlist];
}// end - (void) viewDidLoad
#pragma mark - delegate
- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
	return YES;
}// end - (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex

#pragma mark - properties
- (NSString *) identifier { return WatchlistIdentifierName; }

- (NSImage *) toolbarItemImage { return [NSImage imageNamed:WatchlistToolbarImageName]; }

- (NSString *) toolbarItemLabel { return WatchlistToolbarLabel; }

#pragma mark - actions
- (IBAction) addButtonPressed:(id)sender
{
	
}// end - (IBAction) addButtonPressed:(id)sender

- (IBAction) deleteButtonPressed:(id)sender
{
	
}// end - (IBAction) deleteButtonPressed:(id)sender
#pragma mark - messages
#pragma mark - private
#pragma mark - C functions

@end
