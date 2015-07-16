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

@interface NLProgram : NSObject {
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
	NSDate									*startTime;
	NSString								*startTimeString;
	NSTimer									*notifyTimer;

		// variable for drawing
	NSImage									*imageBuffer;
	NSMutableDictionary						*stringAttributes;

- (void) notify;
- (NSMenuItem *) menuItem;
@end
