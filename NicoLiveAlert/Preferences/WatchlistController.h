//
//  WatchlistController.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/18/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferencesViewController.h"
#import "NLAccounts.h"

@interface WatchlistController : NSViewController <MASPreferencesViewController, NSTableViewDelegate> {
	IBOutlet NSArrayController					*aryctrlWatchlist;
	IBOutlet NSTableView						*tableviewWatchlist;
	IBOutlet NSTextField						*txtfldWatchItem;
	IBOutlet NSTextField						*txtfldItemNote;
	IBOutlet NSButton							*chkboxAutoOpen;
	IBOutlet NSButton							*buttonAppendItem;
	IBOutlet NSButton							*buttonDeleteItem;

	NLAccounts									*allAccounts;
}
@property (nonatomic, readonly) NSString		*identifier;
@property (nonatomic, readonly) NSImage			*toolbarItemImage;
@property (nonatomic, readonly) NSString		*toolbarItemLabel;

- (id) initWithAccounts:(NLAccounts *)accounts;
@end
