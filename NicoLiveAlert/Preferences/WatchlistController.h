//
//  WatchlistController.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/18/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferencesViewController.h"

@interface WatchlistController : NSViewController <MASPreferencesViewController> {
	
}
@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSImage *toolbarItemImage;
@property (nonatomic, readonly) NSString *toolbarItemLabel;

@end
