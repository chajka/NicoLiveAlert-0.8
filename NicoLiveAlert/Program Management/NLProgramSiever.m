//
//  NLProgramSiever.m
//  NicoLiveAlert
//
//  Created by Чайка on 7/7/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import "NLProgramSiever.h"
#import "NicoLiveAlertDefinitions.h"
#import "NicoLiveAlertCollaboration.h"
#import "NicoLiveAlertCollaboratorProtocol.h"
#import "NLOfficialProgram.h"
#import "NLCommunityProgram.h"
#import "NicoLiveAlert.h"

@interface NLProgramSiever ()
- (void) officialProgram:(NSString *)liveNumber;
- (void) officialProgram:(NSString *)liveNumber title:(NSString *)title;
- (void) communityProgram:(NSString *)liveNumber community:(NSString *)community owner:(NSString *)owner autoOpen:(BOOL)autoOpen;
- (void) autoOpen:(NSMenuItem *)item;
@end

@implementation NLProgramSiever
@synthesize connection;
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
		mainQueue = dispatch_get_main_queue();
	}// end if self

	return self;
}// end - (id) initWithAccounts:(NLAccounts *)accnts statusbar:(NLStatusbar *)bar
#pragma mark - override
#pragma mark - delegate
#pragma mark - properties
#pragma mark - actions
#pragma mark - messages
- (void) checkProgram:(NSArray *)programInfo
{		// check official program
	if ([programInfo count] == 2) {
		[self officialProgram:[programInfo objectAtIndex:OffsetLiveNumber] title:[programInfo objectAtIndex:OffsetOfficialTitle]];
		return;
	}// end if
		// check offical program
	if ([[programInfo objectAtIndex:1] isEqualToString:kindOfficalProgram]) {
		[self officialProgram:[programInfo objectAtIndex:OffsetLiveNumber]];
		return;
	}// end if
		// check program in watchlist
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
	for (NSString *key in [activePrograms allKeys]) {
		if ([[activePrograms valueForKey:key] isEqual:program]) {
			[activePrograms removeObjectForKey:key];
			if ([program isKindOfClass:[NLCommunityProgram class]])
				[statusbar removeFromUserMenu:program.menuItem];
			else
				[statusbar removeFromOfficialMenu:program.menuItem];
			break;
		}// end if found old program
	}// end foreach active programs
		// cleanup
	program = nil;
}// end - (void) removeProgram:(NLProgram *)program
#pragma mark - private
- (void) officialProgram:(NSString *)liveNumber
{
	NLOfficialProgram *prog = [[NLOfficialProgram alloc] initWithLiveNumber:liveNumber];
	NSMenuItem *item = [prog menuItem];
	[statusbar addToOfficialMenu:item];
	[activePrograms setValue:prog forKey:liveNumber];
	prog.delegate = self;
	[prog notify];
}// end - (void) officialProgram:(NSString *)liveNumber

- (void) officialProgram:(NSString *)liveNumber title:(NSString *)title
{
	NLOfficialProgram *prog = [[NLOfficialProgram alloc] initWithLiveNumber:liveNumber];
	NSMenuItem *item = [prog menuItem];
	[statusbar addToOfficialMenu:item];
	[activePrograms setValue:prog forKey:liveNumber];
	prog.delegate = self;
	[prog notify];
}// end - (void) officialBroadcast:(NSString *)liveNumber title:(NSString *)title

- (void) communityProgram:(NSString *)liveNumber community:(NSString *)community owner:(NSString *)owner autoOpen:(BOOL)autoOpen
{
	for (NLProgram *program in [activePrograms allValues]) {
		if ([liveNumber isEqualToString:program.programNumber])
			return;
	}// end foreach program

	NSString *primaryAccount = [accounts primaryAccountForCommunity:community];
	NLCommunityProgram *prog = [[NLCommunityProgram alloc] initWithLiveNumber:liveNumber owner:owner primaryAccount:primaryAccount];
	NSMenuItem *item = [prog menuItem];
	[statusbar addToUserMenu:item];
	
	NLProgram *oldProgram = [activePrograms valueForKey:owner];
	if (oldProgram != nil)
		[self removeProgram:oldProgram];
	[activePrograms setValue:prog forKey:owner];

	if (autoOpen) {
		[self autoOpen:prog.menuItem];
	}// end if

	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	if ([ud boolForKey:PrefKeyKickCommentViewerOnMyBroadcast] && [accounts userIDisMine:owner]) {
		NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
		NSString *url = [NicoProgramURLFormat stringByAppendingString:liveNumber];
		[userInfo setValue:url forKey:ProgramURL];
		[userInfo setValue:liveNumber forKey:liveNumber];
		[userInfo setValue:[NSNumber numberWithBool:YES] forKey:CommentViewer];
		[userInfo setValue:[NSNumber numberWithBool:NO] forKey:BroadcastStreamer];
		[userInfo setValue:[NSNumber numberWithInteger:broadcastKindUser] forKey:BroadCastKind];
		[[connection remoteObjectProxy] notifyStartBroadcast:userInfo];
	}// end if

	prog.delegate = self;
	[prog notify];
}// end - (void) communityProgram:(NSString *)liveNumber community:(NSString *)community owner:(NSString *)owner autoOpen:(BOOL)autoOpen

- (void) autoOpen:(NSMenuItem *)item
{
	if ([[NSUserDefaults standardUserDefaults] boolForKey:PrefKeyAutoOpenCheckedLive])
		[(NicoLiveAlert *)NSApp openProgram:item];
}// end - (void) autoOpen:(NSMenuItem *)item
#pragma mark - C functions

@end
