//
//  NLProgram.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/14/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLStatusbar.h"

@interface NLProgram : NSObject {
	NLStatusbar								*statusbar;

	NSMenuItem								*programMenu;
	NSImage									*menuImage;

	NSString								*programNumber;
	NSString								*programTitle;
	NSString								*programDescription;
	NSImage									*thumbnail;
	
	BOOL									reserved;
	NSDate									*openTime;
	NSDate									*startTime;
}

- (void) notify;
@end
