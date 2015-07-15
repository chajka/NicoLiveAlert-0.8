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

@interface NicoLiveAlert : NSObject <NSApplicationDelegate, GrowlApplicationBridgeDelegate> {
	IBOutlet NSMenu						*menuStatusbar;
	
	NLAccounts							*allUsers;
	NLProgramSiever						*siever;
	NLProgramList						*programLister;
	NLStatusbar							*statusbar;
}


@end

