//
//  NLProgramSiever.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/7/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>
#import "NLStatusbar.h"
#import "NLAccounts.h"
#import "NLProgram.h"

@interface NLProgramSiever : NSObject<NLProgramController> {
	dispatch_queue_t					queue;
	NLAccounts							*accounts;
	NSDictionary						*watchlist;
	NLStatusbar							*statusbar;

	NSMutableArray						*activePrograms;

}
@property (readonly) NSXPCConnection	*service;
- (id) initWithAccounts:(NLAccounts *)accnts statusbar:(NLStatusbar *)statusbar;

- (void) checkProgram:(NSArray *)programInfo;
@end
