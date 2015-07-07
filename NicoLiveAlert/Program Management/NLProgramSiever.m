//
//  NLProgramSiever.m
//  NicoLiveAlert
//
//  Created by Чайка on 7/7/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import "NLProgramSiever.h"
#import "NicoLiveAlertDefinitions.h"

@interface NLProgramSiever ()
- (void) officialProgram:(NSString *)liveNumber;
- (void) officialProgram:(NSString *)liveNumber title:(NSString *)title;
- (void) communityProgram:(NSString *)liveNumber autoOpen:(BOOL)autoOpen;
@end

@implementation NLProgramSiever
#pragma mark - synthesize properties
#pragma mark - class method
#pragma mark - constructor / destructor
- (id) initWithWatchlist:(NSDictionary *)watchlist_
{
	self = [super init];
	if (self) {
		watchlist = watchlist_;
	}// end if self

	return self;
}// end - (id) initWithWatchlist:(NSDictionary *)watchlist
#pragma mark - override
#pragma mark - delegate
#pragma mark - properties
#pragma mark - actions
#pragma mark - messages
- (void) checkProgram:(NSArray *)programInfo
{
	if ([programInfo count] == 2)
		[self officialProgram:[programInfo objectAtIndex:OffsetLiveNumber] title:[programInfo objectAtIndex:OffsetOfficialTitle]];

	if ([[programInfo objectAtIndex:1] isEqualToString:kindOfficalProgram])
		[self officialProgram:[programInfo objectAtIndex:OffsetLiveNumber]];

	for (NSString *item in programInfo) {
		NSNumber *autoOpen = [watchlist valueForKey:item];
		if (autoOpen != nil)
			[self communityProgram:[programInfo objectAtIndex:OffsetLiveNumber] autoOpen:[autoOpen boolValue]];
	}
	
}// end - (void) checkProgram:(NSArray *)programInfo
#pragma mark - private
- (void) officialProgram:(NSString *)liveNumber
{
	NSLog(@"Official : %@", liveNumber);
}// end - (void) officialProgram:(NSString *)liveNumber

- (void) officialProgram:(NSString *)liveNumber title:(NSString *)title
{
	NSLog(@"Official : %@, Titile : %@", liveNumber, title);
}// end - (void) officialBroadcast:(NSString *)liveNumber title:(NSString *)title

- (void) communityProgram:(NSString *)liveNumber autoOpen:(BOOL)autoOpen
{
	NSLog(@"Community : %@, autoOpen %c", liveNumber, (autoOpen == YES) ? 'Y':'N');
}// end - (void) communityProgram:(NSString *)liveNumber autoOpen:(BOOL)autoOpen
#pragma mark - C functions

@end
