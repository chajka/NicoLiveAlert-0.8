//
//  NicoLiveAlertPreferenceDefinitions.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/18/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#ifndef NicoLiveAlert_NicoLiveAlertPreferenceDefinitions_h
#define NicoLiveAlert_NicoLiveAlertPreferenceDefinitions_h
#pragma mark - WatchlistController
#define WatchlistIdentifierName									@"ManualWatchlist"
#define WatchlistToolbarImageName								@"watchlist"
#define WatchlistToolbarLabel									NSLocalizedString(@"ManualWatchlist", @"")

#pragma mark - saved preference keys
#define SavedAccountListKey							@"AccountsList"
#define AccountValueUserID							@"UserID"
#define AccountValueNickname						@"Nickname"
#define AccountValueMailAddress						@"MailAddress"
#define AccountValueWatchEnabled					@"WatchEnabled"

#define SavedWatchListKey							@"WatchListTable"
#define WatchListValueWatchItem						@"WatchItem"
#define WatchListValueNote							@"Note"
#define WatchListValueAutoOpen						@"AutoOpen"

#endif
