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

- (void) notify:(NSTimer *)timer;
@end

@implementation NLProgram
#pragma mark - synthesize properties
#pragma mark - class method
#pragma mark - constructor / destructor
#pragma mark - override
#pragma mark - delegate
#pragma mark - properties
#pragma mark - actions
#pragma mark - messages
- (void) notify
{
	NSString *notificationName = GrowlNotifyStartOfficialProgram;
	if (reserved == YES) {
#ifdef DEBUG
		NSLog(@"Hook Notify");
#endif
		NSTimer *notifyTimer = [[NSTimer alloc] initWithFireDate:startTime interval:10 target:self selector:@selector(notify:) userInfo:nil repeats:NO];
		[[NSRunLoop currentRunLoop] addTimer:notifyTimer forMode:NSDefaultRunLoopMode];
		notificationName = GrowlNotifyFoundOfficialProgram;
#ifdef DEBUG
		NSLog(@"Timer is %@", [notifyTimer isValid] ? @"valid" : @"invarid");
		NSLog(@"FireDate : %@", [[notifyTimer fireDate] descriptionWithCalendarFormat:nil timeZone:[NSTimeZone localTimeZone] locale:nil]);
#endif
	}// end if
	
	[GrowlApplicationBridge notifyWithTitle:programTitle description:programDescription notificationName:notificationName iconData:[thumbnail TIFFRepresentation] priority:0 isSticky:NO clickContext:nil];
}// end - (void) notify
#pragma mark - private
- (void) notify:(NSTimer *)timer
{
#ifdef DEBUG
	NSLog(@"Timerd Notify");
#endif
	[GrowlApplicationBridge notifyWithTitle:programTitle description:programDescription notificationName:GrowlNotifyStartOfficialProgram iconData:[thumbnail TIFFRepresentation] priority:0 isSticky:NO clickContext:nil];
}// end - (void) notify:(NSTimer *)timer
#pragma mark - C functions

@end
