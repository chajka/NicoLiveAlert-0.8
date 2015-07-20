//
//  NLAccounts.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/6/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLAccount.h"

@interface NLAccounts : NSObject {
	NSMutableArray				*accounts;
	NSMutableDictionary			*users;

	NSMutableDictionary			*manualWatchList;
	NSMutableDictionary			*watchlist;
}
@property (readonly) NSMutableArray			*accounts;
@property (readonly) NSMutableDictionary	*users;
@property (readonly) NSMutableDictionary	*watchlist;

- (id) init;

- (NLAccount *) addAccount:(NSString *)mailaddress;
- (NLAccount *) addAccount:(NSString *)mailaddress password:(NSString *)password;
- (void) removeAccount:(NSString *)mailaddress;
- (NSString *) primaryAccountForCommunity:(NSString *)community;
- (void) addManualWatchItem:(NSString *)item autoOpen:(BOOL)autoOpen;
- (void) removeManualWatchItem:(NSString *)item;
- (void) toggleAutoOpen:(NSString *)item;
- (void) refresh;
- (BOOL) userIDisMine:(NSString *)userID;
@end
