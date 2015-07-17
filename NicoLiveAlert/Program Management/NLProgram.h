//
//  NLProgram.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/14/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "NLStatusbar.h"

@class NLProgram;
@protocol NLProgramController <NSObject>

- (void) removeProgram:(NLProgram *)program;

@end

@interface NLProgram : NSObject {
	id<NLProgramController>					delegate;
	NLStatusbar								*statusbar;

	NSMenuItem								*programMenu;
	NSImage									*menuImage;

	NSString								*programNumber;
	NSString								*programTitle;
	NSString								*programDescription;
	NSString								*broadcastOwnerName;
	NSString								*communityNumber;
	NSString								*communityName;
	NSImage									*thumbnail;

	NSString								*primaryAccount;
	
	BOOL									reserved;
	NSDate									*openTime;
	NSString								*openTimeString;
	NSDate									*startTime;
	NSString								*startTimeString;
	NSTimer									*notifyTimer;
	NSTimer									*elapsedTimer;
	NSURL									*embedURL;

		// variable for drawing
	NSImage									*imageBuffer;
	NSMutableDictionary						*stringAttributes;
}
@property (readwrite) id<NLProgramController>	delegate;
@property (readonly) NSString				*programNumber;
@property (readonly) NSDictionary			*userInfo;

- (IBAction) openProgram:(id)sender;

- (void) notify;
- (NSMenuItem *) menuItem;
@end
