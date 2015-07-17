//
//  NLProgramSiever.m
//  NicoLiveAlert
//
//  Created by Чайка on 7/7/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import "NLProgramSiever.h"
#import "NicoLiveAlertDefinitions.h"
#import "NLOfficialProgram.h"
#import "NLCommunityProgram.h"
#import "NicoLiveAlert.h"

@interface NLProgramSiever ()
- (void) officialProgram:(NSString *)liveNumber;
- (void) officialProgram:(NSString *)liveNumber title:(NSString *)title;
- (void) channelProgram:(NSString *)liveNumber;
- (void) communityProgram:(NSString *)liveNumber community:(NSString *)community owner:(NSString *)owner autoOpen:(BOOL)autoOpen;
- (void) autoOpen:(NSMenuItem *)item;
@end

@implementation NLProgramSiever
@synthesize service;
#pragma mark - synthesize properties
#pragma mark - class method
#pragma mark - constructor / destructor
- (id) initWithAccounts:(NLAccounts *)accnts statusbar:(NLStatusbar *)bar
{
	self = [super init];
	if (self) {
		accounts = accnts;
		watchlist = accnts.watchlist;
		statusbar = bar;
		activePrograms = [[NSMutableDictionary alloc] init];
		queue = dispatch_queue_create([[self className] UTF8String], DISPATCH_QUEUE_CONCURRENT);
	}// end if self

	return self;
}// end - (id) initWithAccounts:(NLAccounts *)accnts statusbar:(NLStatusbar *)bar
#pragma mark - override
#pragma mark - delegate
#pragma mark - properties
#pragma mark - actions
#pragma mark - messages
- (void) checkProgram:(NSArray *)programInfo
{
	if ([programInfo count] == 2) {
		[self officialProgram:[programInfo objectAtIndex:OffsetLiveNumber] title:[programInfo objectAtIndex:OffsetOfficialTitle]];
		return;
	}// end if

	if ([[programInfo objectAtIndex:1] isEqualToString:kindOfficalProgram]) {
		[self officialProgram:[programInfo objectAtIndex:OffsetLiveNumber]];
		return;
	}// end if

	for (NSString *item in programInfo) {
		NSNumber *autoOpen = [watchlist valueForKey:item];
		if (autoOpen != nil) {
			[self communityProgram:[programInfo objectAtIndex:OffsetLiveNumber] community:[programInfo objectAtIndex:OffsetCommunityChannelNumber] owner:[programInfo objectAtIndex:OffsetProgramOwnerID] autoOpen:[autoOpen boolValue]];
			break;
		}// end if
	}//end foreach
}// end - (void) checkProgram:(NSArray *)programInfo

#pragma mark NLProgramControll delegate Method
- (void) removeProgram:(NLProgram *)program
{
	if ([[program class] isSubclassOfClass:[NLCommunityProgram class]])
		[statusbar removeFromUserMenu:program.menuItem];
	else
		[statusbar removeFromOfficialMenu:program.menuItem];

	for (NSString *key in [activePrograms allKeys]) {
		if ([[activePrograms valueForKey:key] isEqual:program]) {
			[activePrograms removeObjectForKey:key];
			break;
		}// end if found old program
	}// end foreach active programs

		// cleanup
	program = nil;
}// end - (void) removeProgram:(NLProgram *)program
#pragma mark - private
- (void) officialProgram:(NSString *)liveNumber
{
	NSLog(@"Official : %@", liveNumber);
	NLOfficialProgram *prog = [[NLOfficialProgram alloc] initWithLiveNumber:liveNumber];
	prog.delegate = self;
	[prog notify];
	NSMenuItem *item = [prog menuItem];
	[statusbar addToOfficialMenu:item];
	NSLog(@"%@", prog);
	[activePrograms setValue:prog forKey:liveNumber];
}// end - (void) officialProgram:(NSString *)liveNumber

- (void) officialProgram:(NSString *)liveNumber title:(NSString *)title
{
	NSLog(@"Official : %@, Titile : %@", liveNumber, title);
	NLOfficialProgram *prog = [[NLOfficialProgram alloc] initWithLiveNumber:liveNumber];
	prog.delegate = self;
	[prog notify];
	NSMenuItem *item = [prog menuItem];
	[statusbar addToOfficialMenu:item];
	NSLog(@"%@", prog);
	[activePrograms setValue:prog forKey:liveNumber];
}// end - (void) officialBroadcast:(NSString *)liveNumber title:(NSString *)title

- (void) channelProgram:(NSString *)liveNumber
{
	NSLog(@"Channel : %@", liveNumber);
}// end - (void) channelProgram:(NSString *)liveNumber

- (void) communityProgram:(NSString *)liveNumber community:(NSString *)community owner:(NSString *)owner autoOpen:(BOOL)autoOpen
{
	NSLog(@"Community : %@, autoOpen %c", liveNumber, (autoOpen == YES) ? 'Y':'N');
	NSString *primaryAccount = [accounts primaryAccountForCommunity:community];
	NLCommunityProgram *prog = [[NLCommunityProgram alloc] initWithLiveNumber:liveNumber owner:owner primaryAccount:primaryAccount];
	prog.delegate = self;
	[prog notify];
	NSMenuItem *item = [prog menuItem];
	[statusbar addToUserMenu:item];
	NSLog(@"%@", prog);

	NLProgram *oldProgram = [activePrograms valueForKey:owner];
	if (oldProgram != nil)
		[self removeProgram:oldProgram];
	[activePrograms setValue:prog forKey:owner];

	if (autoOpen) {
		[self autoOpen:prog.menuItem];
	}// end if
}// end - (void) communityProgram:(NSString *)liveNumber community:(NSString *)community owner:(NSString *)owner autoOpen:(BOOL)autoOpen

- (void) autoOpen:(NSMenuItem *)item
{
	if ([[NSUserDefaults standardUserDefaults] boolForKey:PrefKeyAutoOpenCheckedLive])
		dispatch_async(queue, ^{ [(NicoLiveAlert *)NSApp openProgram:item]; });
}// end - (void) autoOpen:(NSMenuItem *)item
#pragma mark - C functions

@end
