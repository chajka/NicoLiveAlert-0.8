//
//  NLProgramList.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/6/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaOniguruma/OnigRegexp.h>
#import "YCStreamSession.h"
#import "NLAccounts.h"

@interface NLProgramList : NSObject <YCStreamSessionDelegate> {
	YCStreamSession					*session;
	NLAccounts						*accounts;
	NSString						*requestEelement;
	BOOL							reachable;

	BOOL							requestPosted;

	NSInputStream					*streamToRead;
	NSOutputStream					*streamToWrite;

	CFMutableDataRef				recievedData;
	OnigRegexp						*programlistRegex;
}
- (id) initWithAccounts:(NLAccounts *)accnts;
@end
