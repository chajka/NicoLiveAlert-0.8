//
//  NLProgramSiever.m
//  NicoLiveAlert
//
//  Created by Чайка on 7/6/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import "NLProgramSiever.h"

@implementation NLProgramSiever
#pragma mark - synthesize properties
#pragma mark - class method
#pragma mark - constructor / destructor
- (id) initWithAccounts:(NLAccounts *)accnts
{
	self = [super init];
	if (self) {
		accounts = accnts;
	}// end if self;

	return self;
}// end - (id) initWithAccounts:(NLAccounts *)accnts
#pragma mark - override
#pragma mark - delegate
#pragma mark - properties
#pragma mark - actions
#pragma mark - messages
#pragma mark - private
#pragma mark - C functions
#pragma mark - Common StreamConnectionDelegate methods
- (void) streamReadyToConnect:(YCStreamSessionGCD *)session reachable:(BOOL)reachable
{
	
}// end - (void) streamReadyToConnect:(YCStreamSessionGCD *)session reachable:(BOOL)reachable

/*
- (void) streamIsDisconnected:(YCStreamSessionGCD *)session stream:(NSStream *)stream
{
}//end - (void) streamIsDisconnected:(YCStreamSessionGCD *)session stream:(NSStream *)stream
*/
#pragma mark - InputStreamConnectionDelegate methods
- (void) readStreamHasBytesAvailable:(NSInputStream *)stream
{
}// end - (void) readStreamHasBytesAvailable:(NSInputStream *)stream

- (void) readStreamEndEncounted:(NSInputStream *)stream
{
}// end - (void) readStreamEndEncounted:(NSInputStream *)stream

- (void) readStreamErrorOccured:(NSInputStream *)iStream
{
}// end - (void) readStreamErrorOccured:(NSInputStream *)iStream
/*
- (void) readStreamOpenCompleted:(NSInputStream *)iStream
{
	￼￼<#code#>
}// end - (void) readStreamOpenCompleted:(NSInputStream *)iStream
- (void) readStreamCanAcceptBytes:(NSInputStream *)iStream
{
	￼￼<#code#>
}// end
- (void) readStreamNone:(NSStream *)iStream
{
	￼￼<#code#>
}// end - (void) readStreamCanAcceptBytes:(NSInputStream *)iStream
*/
#pragma mark - OutputStreamConnectionDelegate methods
- (void) writeStreamCanAcceptBytes:(NSOutputStream *)oStream
{
}// end - (void) writeStreamCanAcceptBytes:(NSOutputStream *)oStream

- (void) writeStreamEndEncounted:(NSOutputStream *)oStream
{
}// end - (void) writeStreamEndEncounted:(NSOutputStream *)oStream

- (void) writeStreamErrorOccured:(NSOutputStream *)oStream
{
}// end - (void) writeStreamErrorOccured:(NSOutputStream *)oStream
/*
- (void) writeStreamOpenCompleted:(NSOutputStream *)oStream
{
	￼￼<#code#>
}// end - (void) writeStreamOpenCompleted:(NSOutputStream *)oStream

- (void) writeStreamHasBytesAvailable:(NSOutputStream *)oStream
{
	￼￼<#code#>
}// end - (void) writeStreamHasBytesAvailable:(NSOutputStream *)oStream

- (void) writeStreamNone:(NSOutputStream *)oStream
{
	￼￼<#code#>
}// end - (void) writeStreamNone:(NSOutputStream *)oStream
*/

@end
