//
//  NicoLiveAlert.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/6/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NLAccounts.h"
#import "NLProgramList.h"

@interface NicoLiveAlert : NSObject <NSApplicationDelegate> {
	NLAccounts							*allUsers;
	NLProgramList						*programLister;
}


@end

