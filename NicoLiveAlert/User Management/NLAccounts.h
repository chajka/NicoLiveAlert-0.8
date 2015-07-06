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

	NSMutableDictionary			*manualWatchList;
	NSMutableDictionary			*watchlist;
}
@property (readonly) NSMutableDictionary	*watchlist;

- (id) init;

- (BOOL) addAccount:(NSString *)mailaddress;
- (BOOL) addAccount:(NSString *)mailaddress password:(NSString *)password;
- (void) addManualWatchItem:(NSString *)item autoOpen:(BOOL)autoOpen;
- (void) removeManualWatchItem:(NSString *)item;
- (void) toggleAutoOpen:(NSString *)item;
- (void) refresh;
@end
