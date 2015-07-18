//
//  WatchlistController.m
//  NicoLiveAlert
//
//  Created by Чайка on 7/18/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import "WatchlistController.h"
#import "NicoLiveAlertPreferenceDefinitions.h"

@interface WatchlistController ()

@end

@implementation WatchlistController
#pragma mark - synthesize properties
#pragma mark - class method
#pragma mark - constructor / destructor
#pragma mark - override
- (void) viewDidLoad
{
	[super viewDidLoad];
	// Do view setup here.
}
#pragma mark - delegate
#pragma mark - properties
- (NSString *) identifier { return WatchlistIdentifierName; }
- (NSImage *) toolbarItemImage { return [NSImage imageNamed:WatchlistToolbarImageName]; }
- (NSString *) toolbarItemLabel { return WatchlistToolbarLabel; }
#pragma mark - actions
#pragma mark - messages
#pragma mark - private
#pragma mark - C functions

@end
