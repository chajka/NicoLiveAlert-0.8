//
//  NicoLiveAlert.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/6/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>
#import "NLAccounts.h"
#import "NLProgramList.h"
#import "NLProgramSiever.h"
#import "NLStatusbar.h"
#import "MASPreferencesWindowController.h"
#import "MASPreferencesViewController.h"

@interface NicoLiveAlert : NSObject <NSApplicationDelegate, GrowlApplicationBridgeDelegate> {
	IBOutlet NSMenu						*menuStatusbar;
	
	NLAccounts							*allUsers;
	NLProgramSiever						*siever;
	NLProgramList						*programLister;
	NLStatusbar							*statusbar;

	MASPreferencesWindowController		*preferenceWindowController;
	BOOL								firstTime;

	NSTimer								*checkTimer;
	NSXPCConnection						*collaborator;
}

- (IBAction) openProgram:(id)sender;
- (void) joinToCommentViewer:(NSString *)liveNumber;
@end

