//
//  NLProgramList.m
//  NicoLiveAlert
//
//  Created by Чайка on 7/6/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import "NLProgramList.h"
#import "NicoLiveAlertDefinitions.h"
#import <CocoaOniguruma/OnigRegexp.h>

#define UNLIMITED								(0)

@implementation NLProgramList
#pragma mark - synthesize properties
#pragma mark - class method
#pragma mark - constructor / destructor
- (id) initWithAccounts:(NLAccounts *)accnts siever:(NLProgramSiever *)siever_  statusbar:(NLStatusbar *)statusbar_
{
	self = [super init];
	if (self) {
		queue = dispatch_queue_create("NLProgramList", DISPATCH_QUEUE_CONCURRENT);
		reachable = NO;
		requestPosted = NO;
		accounts = accnts;
		siever = siever_;
		statusbar = statusbar_;

		NLAccount *account = [accounts.accounts objectAtIndex:0];
		NSString *hostName = account.server;
		int port = (int)account.port;
		requestEelement = [[NSString alloc] initWithFormat:StartStreamRequestElement, account.thread];
		session = [[YCStreamSession alloc] initWithHostName:hostName andPort:port];
		[session setDelegate:self];
		[session checkReadyToConnect];
		programlistRegex = [OnigRegexp compile:ProgramListRegex];
		recievedData = CFDataCreateMutable(kCFAllocatorDefault, UNLIMITED);
	}// end if self;

	return self;
}// end - (id) initWithAccounts:(NLAccounts *)accnts siever:(NLProgramSiever *)siever_  statusbar:(NLStatusbar *)statusbar_

- (void) dealloc
{
	CFRelease(recievedData);
}// end - (void) dealloc
#pragma mark - override
#pragma mark - delegate
#pragma mark - properties
#pragma mark - actions
#pragma mark - messages
#pragma mark - private
- (void) reconnect
{		// cleanup last session
	[session closeReadStream];
	[session closeWriteStream];
	[session disconnect];

	NLAccount *account = [accounts.accounts objectAtIndex:0];
	NSString *hostName = account.server;
	int port = (int)account.port;
	requestPosted = NO;
	session = [[YCStreamSession alloc] initWithHostName:hostName andPort:port];
	[session setDelegate:self];
	[session checkReadyToConnect];
}// end - (void) reconnect

- (NSError *) write:(NSString *)str
{
	NSError *err = nil;
	NSMutableData *writeData = [NSMutableData dataWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
	[writeData appendBytes:&"\0" length:1];
	const uint8_t *start = [writeData bytes];
	NSInteger writeLength = 0;
	NSRange writeRange = {.location = 0, .length = [writeData length]};
	
	while (writeRange.length != 0) {
		writeLength = [streamToWrite write:&start[writeRange.location] maxLength:writeRange.length];
		if (writeLength == -1) {
			err = [streamToWrite streamError];
			NSLog(@"write error : %@", err);
			return err;
		}// end if write error occurrd
		writeRange.location += writeLength;
		writeRange.length -= writeLength;
	}// end while
	
	return err;
}// end - (void) write:(NSString *)str

#pragma mark - C functions
#pragma mark - Common StreamConnectionDelegate methods
- (void) streamReadyToConnect:(YCStreamSession*)session_ reachable:(BOOL)reachable_
{
	if (session == session_)
		reachable = reachable_;

	if (reachable)
		[session connect];
	statusbar.connected = YES;
}// end - (void) streamReadyToConnect:(YCStreamSessionGCD *)session reachable:(BOOL)reachable

/*
- (void) streamIsDisconnected:(YCStreamSessionGCD *)session stream:(NSStream *)stream
{
}//end - (void) streamIsDisconnected:(YCStreamSessionGCD *)session stream:(NSStream *)stream
*/
#pragma mark - InputStreamConnectionDelegate methods
- (void) readStreamHasBytesAvailable:(NSInputStream *)stream
{
	uint8_t oneByte;
	NSInteger actuallyRead = 0;
	BOOL repeat = YES;
	do {	// read from stream
		actuallyRead = [stream read:&oneByte maxLength:1U];
		// check data
		switch (actuallyRead) {
			case 1:		// success normaly one byte.
				if (oneByte == '\0')
					repeat = NO;
				else
					CFDataAppendBytes(recievedData, &oneByte, actuallyRead);
				break;
			case 0:
				return;
				break;
			default:
				NSLog(@"Error at reading stream %@ : %@", NSStringFromSelector(_cmd), [self class]);
				NSLog(@"Stream Status : %lu", [stream streamStatus]);
				NSLog(@"Stream Error : %@", [stream streamError]);
				return;
				break;
		}// end switch
	} while (repeat);
	
	NSString *resultElement = [[NSString alloc] initWithData:(__bridge NSData *)recievedData encoding:NSUTF8StringEncoding];
	
	CFIndex length = CFDataGetLength(recievedData);
	CFRange range = CFRangeMake(0, length);
	CFDataDeleteBytes(recievedData, range);
	
	OnigResult *result = [programlistRegex search:resultElement];
	if (result != nil) {
		NSString *programlist = [kindProgram stringByAppendingString:[result stringAt:1]];
		//NSLog(@"} %@ {", programlist);
		NSArray *programInfo = [programlist componentsSeparatedByString:@","];
		[siever checkProgram:programInfo];
	}// end if result is there
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
	streamToWrite = oStream;
	if (requestPosted == NO) {
		[self write:requestEelement];
		requestPosted = YES;
	}// end if
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
