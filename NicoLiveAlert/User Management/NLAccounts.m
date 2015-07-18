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
@synthesize accounts;
@synthesize users;
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

- (void) removeAccount:(NSString *)mailaddress
{
	for (NLAccount *account in [accounts reverseObjectEnumerator]) {
		if ([account.mailaddress isEqualToString:mailaddress]) {
			[accounts removeObject:account];
			break;
		}// end if found account to delete
	}// end foreach all accounts
}// end - (void) removeAccount:(NSString *)mailaddress

- (NSString *) primaryAccountForCommunity:(NSString *)community
{
	for (NSString *nickname in [users allKeys]) {
		NLAccount *account = [users valueForKey:nickname];
		if ([account.joined containsObject:community])
			return nickname;
	}// end foreach accounts

	return @"Manual";
}// end - (NSString *) primaryAccountForCommunity:(NSString *)community

- (void) addManualWatchItem:(NSString *)item autoOpen:(BOOL)autoOpen_
{
	NSNumber *autoOpen = [NSNumber numberWithBool:autoOpen_];
	[manualWatchList setValue:autoOpen forKey:item];
	[self rebuildWatchlist];
}// end - (void) addManualWatchItem:(NSString *)item autoOpen:(BOOL)autoOpen

- (void) removeManualWatchItem:(NSString *)item
{
	[manualWatchList removeObjectForKey:item];
	[self rebuildWatchlist];
}// end - (void) removeManualWatchItem:(NSString *)item

- (void) toggleAutoOpen:(NSString *)item
{
	BOOL autoopen = [[manualWatchList valueForKey:item] boolValue];
	NSNumber *autoOpen = [NSNumber numberWithBool:((autoopen == YES) ? NO:YES)];
	[manualWatchList setValue:autoOpen forKey:item];
	[self rebuildWatchlist];
}// end - (void) toggleAutoOpen:(NSString *)item

- (void) refresh
{
	for (NLAccount *account in accounts) {
		[account refresh];
	}// end foreach account

	[self rebuildWatchlist];
}// end - (void) refresh

- (BOOL) userIDisMine:(NSString *)uid
{
	for (NLAccount *account in accounts) {
		if ([account.userID isEqualToString:uid])
			return YES;
	}// end foreach account

	return NO;
}// end - (BOOL) userIDisMine:(NSString *)uid

#pragma mark - private
- (void) restoreFromSavedPreference
{
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
		// restore accounts
	accounts = [[NSMutableArray alloc] init];
	users = [[NSMutableDictionary alloc] init];
	NSArray *prefusers = [ud arrayForKey:SavedAccountListKey];
	for (NSDictionary *user in prefusers) {
		NSString *accnt = [user valueForKey:AccountValueMailAddress];
		NLAccount *account = [[NLAccount alloc] initWithAccount:accnt];
		if (account != nil) {
			account.watchEnable = [[user valueForKey:AccountValueWatchEnabled] boolValue];
			[accounts addObject:account];
			[users setValue:account forKey:account.nickname];
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
