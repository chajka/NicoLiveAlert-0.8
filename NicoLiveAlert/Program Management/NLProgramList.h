//
//  NLProgramList.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/6/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>
#import <CocoaOniguruma/OnigRegexp.h>
#import "YCStreamSession.h"
#import "NLAccounts.h"
#import "NLProgramSiever.h"

@interface NLProgramList : NSObject <YCStreamSessionDelegate> {
	dispatch_queue_t				queue;
	YCStreamSession					*session;
	NLAccounts						*accounts;
	NLProgramSiever					*siever;

	NSString						*requestEelement;
	BOOL							reachable;

	BOOL							requestPosted;

	NSInputStream					*streamToRead;
	NSOutputStream					*streamToWrite;

	CFMutableDataRef				recievedData;
	OnigRegexp						*programlistRegex;
}
- (id) initWithAccounts:(NLAccounts *)accounts siever:(NLProgramSiever *)siever;
@end
