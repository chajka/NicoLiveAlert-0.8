//
//  NLAccounts.m
//  NicoLiveAlert
//
//  Created by Чайка on 7/6/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import "NLAccounts.h"
#import "NicoLiveAlertDefinitions.h"

@interface NLAccounts ()
- (void) restoreFromSavedPreference;
- (void) buildWatchlist;
- (void) rebuildWatchlist;
@end

@implementation NLAccounts
#pragma mark - synthesize properties
@synthesize watchlist;
#pragma mark - class method
#pragma mark - constructor / destructor
- (id) init
{
	self = [super init];
	if (self) {
		[self restoreFromSavedPreference];
		[self buildWatchlist];
	}// end if self

	return self;
}// end - (id) init
#pragma mark - override
#pragma mark - delegate
#pragma mark - properties
#pragma mark - actions
#pragma mark - messages
- (BOOL) addAccount:(NSString *)mailaddress
{
	NLAccount *account = [[NLAccount alloc] initWithAccount:mailaddress];
	if (account == nil)
		return NO;

	[accounts addObject:account];
	[self rebuildWatchlist];

	return YES;
}// end - (BOOL) addAccount:(NSString *)mailaddress

- (BOOL) addAccount:(NSString *)mailaddress password:(NSString *)password
{
	NLAccount *account = [[NLAccount alloc] initWithAccount:mailaddress password:password];
	if (account == nil)
		return NO;
	
	[accounts addObject:account];
	[self rebuildWatchlist];
	
	return YES;
}// end - (BOOL) addAccount:(NSString *)mailaddress password:(NSString *)password

- (void) refresh
{
	for (NLAccount *account in accounts) {
		[account refresh];
	}// end foreach account

	[self rebuildWatchlist];
}// end - (void) refresh

#pragma mark - private
- (void) restoreFromSavedPreference
{
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
		// restore accounts
	accounts = [[NSMutableArray alloc] init];
	NSArray *users = [ud arrayForKey:SavedAccountListKey];
	for (NSDictionary *user in users) {
		NSString *accnt = [user valueForKey:AccountValueMailAddress];
		NLAccount *account = [[NLAccount alloc] initWithAccount:accnt];
		if (account != nil) {
			account.watchEnable = [[user valueForKey:AccountValueWatchEnabled] boolValue];
			[accounts addObject:account];
		}// end if account is there
	}// end foreach

		// restore manual watch list
	manualWatchList = [[NSMutableDictionary alloc] init];
	NSArray *items = [ud arrayForKey:SavedWatchListKey];
	for (NSDictionary *item in items) {
		NSString *watch = [item valueForKey:WatchListValueWatchItem];
		NSNumber *autoOpen = [item valueForKey:WatchListValueAutoOpen];
		[manualWatchList setValue:autoOpen forKey:watch];
	}// end foreach
}// end - (void) restoreFromSavedPreference

- (void) buildWatchlist
{
	watchlist = [[NSMutableDictionary alloc] init];
	NSNumber *autoOpen = [NSNumber numberWithBool:NO];
	for (NLAccount *account in accounts) {
		NSArray *communities = account.joined;
		for (NSString *item in communities) {
			[watchlist setValue:autoOpen forKey:item];
		}// end foreach joined community or channel
	}// end foreach account

	[watchlist addEntriesFromDictionary:manualWatchList];
}// end - (void) buildWatchlist

- (void) rebuildWatchlist
{
	[watchlist removeAllObjects];
	NSNumber *autoOpen = [NSNumber numberWithBool:NO];
	for (NLAccount *account in accounts) {
		NSArray *communities = account.joined;
		for (NSString *item in communities) {
			[watchlist setValue:autoOpen forKey:item];
		}// end foreach joined community or channel
	}// end foreach account
	
	[watchlist addEntriesFromDictionary:manualWatchList];
}// end - (void) rebuildWatchlist
#pragma mark - C functions

@end
