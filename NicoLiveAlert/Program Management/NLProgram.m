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
		NSTimer *notifyTimer = [[NSTimer alloc] initWithFireDate:startTime interval:0 target:self selector:@selector(notify:) userInfo:nil repeats:NO];
		[[NSRunLoop currentRunLoop] addTimer:notifyTimer forMode:NSDefaultRunLoopMode];
		notificationName = GrowlNotifyFoundOfficialProgram;
	}// end if
	
	[GrowlApplicationBridge notifyWithTitle:programTitle description:programDescription notificationName:notificationName iconData:[thumbnail TIFFRepresentation] priority:0 isSticky:NO clickContext:nil];
}// end - (void) notify
#pragma mark - private
- (void) notify:(NSTimer *)timer
{
	[GrowlApplicationBridge notifyWithTitle:programTitle description:programDescription notificationName:GrowlNotifyStartOfficialProgram iconData:[thumbnail TIFFRepresentation] priority:0 isSticky:NO clickContext:nil];
}// end - (void) notify:(NSTimer *)timer
#pragma mark - C functions

@end
