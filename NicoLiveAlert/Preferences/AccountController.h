//
//  AccountController.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/20/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NLAccounts.h"
#import "MASPreferencesViewController.h"

@interface AccountController : NSViewController <MASPreferencesViewController> {
	IBOutlet NSArrayController			*aryctrlAccounts;
	IBOutlet NSTableView				*tableviewAccounts;

	IBOutlet NSComboBox					*comboMaladdresses;
	IBOutlet NSSecureTextField			*txtfldPassword;
	IBOutlet NSButton					*buttonAddAccount;
	IBOutlet NSButton					*buttonDeleteAccount;

	NLAccounts							*allAccounts;
}
@property (nonatomic, readonly) NSString		*identifier;
@property (nonatomic, readonly) NSImage			*toolbarItemImage;
@property (nonatomic, readonly) NSString		*toolbarItemLabel;

- (id) initWithAccounts:(NLAccounts *)accounts;

@end
