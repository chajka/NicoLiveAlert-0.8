//
//  NLProgram.m
//  NicoLiveAlert
//
//  Created by Чайка on 7/14/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import "NLProgram.h"
#import <Growl/Growl.h>
#import "NicoLiveAlertDefinitions.h"

@interface NLProgram ()
- (void) drawContents;
- (void) notifyTimer:(NSTimer *)timer;
@end

@implementation NLProgram
#pragma mark - synthesize properties
@synthesize programNumber;

#pragma mark - class method
#pragma mark - constructor / destructor
#pragma mark - override
#pragma mark - delegate
#pragma mark - properties
#pragma mark - actions
- (IBAction) openProgram:(id)sender
{
	NSURL *liveURL = [NSURL URLWithString:[NicoProgramURLFormat stringByAppendingString:programNumber]];
	[[NSWorkspace sharedWorkspace] openURL:liveURL];
}// end - (IBAction) openProgram:(id)sender

#pragma mark - messages
- (void) notify
{
	NSString *notificationName = GrowlNotifyStartOfficialProgram;
	if (reserved == YES) {
#ifdef DEBUG
		NSLog(@"Hook Notify");
#endif
		notifyTimer = [[NSTimer alloc] initWithFireDate:startTime interval:0.0f target:self selector:@selector(notifyTimer:) userInfo:nil repeats:NO];
		[[NSRunLoop currentRunLoop] addTimer:notifyTimer forMode:NSDefaultRunLoopMode];
		notificationName = GrowlNotifyFoundOfficialProgram;
#ifdef DEBUG
		NSLog(@"Timer is %@", [notifyTimer isValid] ? @"valid" : @"invarid");
		NSLog(@"FireDate : %@", [[notifyTimer fireDate] descriptionWithCalendarFormat:nil timeZone:[NSTimeZone localTimeZone] locale:nil]);
#endif
	}// end if
	
	[GrowlApplicationBridge notifyWithTitle:programTitle description:programDescription notificationName:notificationName iconData:[thumbnail TIFFRepresentation] priority:0 isSticky:NO clickContext:nil];
}// end - (void) notify

- (NSMenuItem *) menuItem
{
	if (programMenu == nil)
		[self drawContents];
	programMenu = [[NSMenuItem alloc] initWithTitle:EmptyString action:@selector(openProgram:) keyEquivalent:EmptyString];
	[programMenu setImage:menuImage];
	[programMenu setRepresentedObject:self];
	
	return programMenu;
}// end - (NSMenuItem *) menuItem

#pragma mark - private
- (void) notifyTimer:(NSTimer *)timer
{
#ifdef DEBUG
	NSLog(@"Timerd Notify");
#endif
	[GrowlApplicationBridge notifyWithTitle:programTitle description:programDescription notificationName:GrowlNotifyStartOfficialProgram iconData:[thumbnail TIFFRepresentation] priority:0 isSticky:NO clickContext:nil];
}// end - (void) notify:(NSTimer *)timer

- (void) drawContents
{
	
}// end - (void) drawContents
#pragma mark - C functions

@end
