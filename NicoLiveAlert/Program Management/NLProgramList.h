//
//  NLProgramList.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/6/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCStreamSessionGCD.h"
#import "NLAccounts.h"

@interface NLProgramList : NSObject <YCStreamSessionGCDDelegate> {
	YCStreamSessionGCD				*GCDsession;
	NLAccounts						*accounts;
	NSString						*requestEelement;
	BOOL							reachable;

	BOOL							requestPosted;

	NSInputStream					*streamToRead;
	NSOutputStream					*streamToWrite;

	CFMutableDataRef				recievedData;
}

@end
