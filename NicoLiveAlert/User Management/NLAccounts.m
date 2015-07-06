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
@end

@implementation NLAccounts
#pragma mark - synthesize properties
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
#pragma mark - private
- (void) restoreFromSavedPreference
{
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
		// restore accounts
	accounts = [[NSMutableArray alloc] init];
	NSArray *users = [ud arrayForKey:SavedAccountListKey];
	for (NSDictionary *user in users) {
		NSString *accnt = [user valueForKey:@"MailAddress"];
		NLAccount *account = [[NLAccount alloc] initWithAccount:accnt];
		if (account != nil) {
			account.watchEnable = [[user valueForKey:@"WatchEnabled"] boolValue];
			[accounts addObject:account];
		}// end if account is there
	}// end foreach

		// restore manual watch list
	manualWatchList = [[NSMutableDictionary alloc] init];
	NSArray *items = [ud arrayForKey:SavedWatchListKey];
	for (NSDictionary *item in items) {
		NSString *watch = [item valueForKey:@"WatchItem"];
		NSNumber *autoOpen = [item valueForKey:@"AutoOpen"];
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
NSLog(@"%@", watchlist);
}// end - (void) buildWatchlist
#pragma mark - C functions

@end
