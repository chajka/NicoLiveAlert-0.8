//
//  NLProgramSiever.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/7/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLStatusbar.h"
#import "NLAccounts.h"

@interface NLProgramSiever : NSObject {
	NLAccounts							*accounts;
	NSDictionary						*watchlist;
	NLStatusbar							*statusbar;

	NSMutableArray						*activePrograms;
}
- (id) initWithAccounts:(NLAccounts *)accnts statusbar:(NLStatusbar *)statusbar;

- (void) checkProgram:(NSArray *)programInfo;
@end
