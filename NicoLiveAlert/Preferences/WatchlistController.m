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
- (id) initWithAccounts:(NLAccounts *)accounts
{
	self = [super initWithNibName:@"WatchlistController" bundle:nil];
	if (self) {
		allAccounts = accounts;
	}// end if self

	return self;
}// end - (id) initWithAccounts:(NLAccounts *)accounts

#pragma mark - override
- (void) viewDidLoad
{
	[super viewDidLoad];
	NSArray *watchlist = [[NSUserDefaults standardUserDefaults] arrayForKey:SavedWatchListKey];
	[aryctrlWatchlist addObjects:watchlist];
	tableviewWatchlist.delegate = self;
}// end - (void) viewDidLoad

#pragma mark - delegate
- (void) controlTextDidChange:(NSNotification *)obj
{
	if (![txtfldWatchItem.stringValue isEqualToString:EmptyString])
		buttonAppendItem.enabled = YES;
	else
		buttonAppendItem.enabled = NO;
}// end - (void) controlTextDidChange:(NSNotification *)obj

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
	if ([aryctrlWatchlist.arrangedObjects count] > rowIndex)
		buttonDeleteItem.enabled = YES;
	else
		buttonDeleteItem.enabled = NO;

	return YES;
}// end - (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex

#pragma mark - properties
- (NSString *) identifier { return WatchlistIdentifierName; }

- (NSImage *) toolbarItemImage { return [NSImage imageNamed:WatchlistToolbarImageName]; }

- (NSString *) toolbarItemLabel { return WatchlistToolbarLabel; }

#pragma mark - actions
- (IBAction) addButtonPressed:(id)sender
{
	NSMutableDictionary *entry = [NSMutableDictionary dictionary];
	BOOL autoOpen = (chkboxAutoOpen.state == NSOnState) ? YES : NO;
	NSString *watchItem = txtfldWatchItem.stringValue;
	NSString *ItemNote = txtfldItemNote.stringValue;
	[entry setValue:[NSNumber numberWithBool:autoOpen] forKey:WatchListValueAutoOpen];
	[entry setValue:watchItem forKey:WatchListValueWatchItem];
	[entry setValue:ItemNote forKey:WatchListValueNote];
	[aryctrlWatchlist addObject:entry];

	chkboxAutoOpen.state = NSOffState;
	txtfldWatchItem.stringValue = EmptyString;
	txtfldItemNote.stringValue = EmptyString;
	
	buttonAppendItem.enabled = NO;

		// update watchlist
	[allAccounts addManualWatchItem:watchItem autoOpen:autoOpen];

		// update saved preference
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	NSMutableArray *entries = [NSMutableArray arrayWithArray:[ud arrayForKey:SavedWatchListKey]];
	[entries addObject:entry];
	[ud setObject:entries forKey:SavedWatchListKey];
}// end - (IBAction) addButtonPressed:(id)sender

- (IBAction) deleteButtonPressed:(id)sender
{
	NSArray *selected = aryctrlWatchlist.selectedObjects;
	[aryctrlWatchlist removeObjects:selected];

	[tableviewWatchlist deselectAll:self];
	buttonDeleteItem.enabled = NO;

		// update manual watchlist
	for (NSDictionary *watchItem in selected) {
		[allAccounts removeManualWatchItem:[watchItem valueForKey:WatchListValueWatchItem]];
	}// end foreach selected

		// writeback to saved preference
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	[ud setObject:aryctrlWatchlist.arrangedObjects forKey:SavedWatchListKey];
}// end - (IBAction) deleteButtonPressed:(id)sender
#pragma mark - messages
#pragma mark - private
#pragma mark - C functions

@end
