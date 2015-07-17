//
//  NLStatusbar.m
//  NicoLiveAlert
//
//  Created by Чайка on 7/7/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import "NLStatusbar.h"
#import "NicoLiveAlertDefinitions.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark internal constant

static CGFloat origin = 0.0;
static CGFloat iconSizeH = 20.0;
static CGFloat iconSizeW = 20.0;
static CGFloat noProgWidth = 20.0;
static CGFloat disconnectPathWidth = 3.0;
static CGFloat disconnectPathOffset = 5.0;
static CGFloat haveProgWidth = 41.0;
static CGFloat noProgPower = 0.3;
static CGFloat progCountFontSize = 11;
static CGFloat progCountPointY = 1.5;
static CGFloat progCountPointSingleDigitX = 27.0;
static CGFloat progCountBackGroundWidth = 14.8;
static CGFloat progCountBackGrountFromX = 28.0;
static CGFloat progCountBackGrountFromY = 8.5;
static CGFloat progCountBackGrountToX = 34.0;
static CGFloat progCountBackGrountToY = 8.5;
static CGFloat progCountBackDigitOffset = 6.5;
static CGFloat progCountBackColorRed = 000.0/256.0;
static CGFloat progCountBackColorGreen = 153.0/256.0;
static CGFloat progCountBackColorBlue = 051.0/256.0;
static CGFloat progCountBackColorAlpha = 1.00;
static CGFloat disconnectedColorRed = 256.0/256.0;
static CGFloat disconnectedColorGreen = 000.0/256.0;
static CGFloat disconnectedColorBlue = 000.0/256.0;
static CGFloat disconnectedColorAlpha = 0.70;

@interface NLStatusbar ()
#pragma mark constructor support
- (CIImage *) createFromResource:(NSString *)imageName;
- (void) installStatusbarMenu;
- (void) setupMembers:(NSString *)imageName;
- (void) makeStatusbarIcon;
- (void) updateToolTip;
@end

@implementation NLStatusbar
#pragma mark - synthesize properties
@synthesize numberOfPrograms;
@synthesize watchOfficial;
#pragma mark - class method
#pragma mark - constructor / destructor
- (id) initWithMenu:(NSMenu *)menu andImageName:(NSString *)imageName
{
	self = [super init];
	if (self)
	{
		connected = NO;
		userState = NSOffState;
		numberOfPrograms = 0;
		statusbarMenu = menu;
		[self setupMembers:imageName];
		
#if __has_feature(objc_arc) == 0
		[sourceImage retain];
		[gammaFilter retain];
		[invertFilter retain];
		[progCountBackground retain];
		[progCountBackColor retain];
		[disconnectColor retain];
#endif
		userProgramCount = 0;
		officialProgramCount = 0;
		[self installStatusbarMenu];
		[self makeStatusbarIcon];

	}// end if

	return self;
}// end - (id) initWithImage:(NSString *)imageName
#pragma mark - override
#pragma mark - delegate
#pragma mark - properties
- (NSCellStateValue) userState
{
	return userState;
}// end - (NSInteger) userState

- (void) setUserState:(NSCellStateValue)state
{
	userState = state;
	[self makeStatusbarIcon];
}// end - (void) setUserState:(NSInteger)state

- (BOOL) connected
{
	return connected;
}// - (BOOL) connected

- (void) setConnected:(BOOL)connected_
{
	connected = connected_;
	[self makeStatusbarIcon];
}// - (void) setConnected:(BOOL)connected_

- (void) toggleConnected
{
	connected = !connected;
	[self makeStatusbarIcon];
}// end - (void) toggleConnected

- (BOOL) watchOfficial
{
	return watchOfficial;
}// end - (BOOL) watchOfficial

- (void) setWatchOfficial:(BOOL)watch
{
	watchOfficial = watch;
	[[statusbarMenu itemWithTag:tagOfficial] setHidden:!watchOfficial];
}// end - (void) setWatchOfficial:(BOOL)watch

#pragma mark - actions
#pragma mark - messages
- (void) updateUserState
{
	NSMenu *usersMenu = [[statusbarMenu itemWithTag:tagAccounts] submenu];
	NSArray *accounts = [usersMenu itemArray];
	NSUInteger userCount = [accounts count];
	int activeCount = 0;
	for (NSMenuItem *item in accounts) {
		if ([item state] == NSOnState)
			activeCount++;
	}// end foreach

	if (activeCount == 0)
		self.userState = NSOffState;
	else if (activeCount == userCount)
		self.userState = NSOnState;
	else
		self.userState = NSMixedState;
}// end - (void) updateUserState

- (void) addToUserMenu:(NSMenuItem *)item
{
	if (userProgramCount == 0)
	{
		NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
		[[statusbarMenu itemWithTag:tagPorgrams] setSubmenu:menu];
		[[statusbarMenu itemWithTag:tagPorgrams] setTitle:TITLEUSERSINGLEPROG];
		[[statusbarMenu itemWithTag:tagPorgrams] setEnabled:YES];
#if __has_feature(objc_arc) == 0
		[menu autorelease];
#endif
	}
	else if (userProgramCount == 1)
	{
		[[statusbarMenu itemWithTag:tagPorgrams] setTitle:TITLEUSERSOMEPROG];
	}// end if user program count
	
	[[[statusbarMenu itemWithTag:tagPorgrams] submenu] insertItem:item atIndex:0];
	[self incleaseProgCount];
	if (++userProgramCount > 0)
		[[statusbarMenu itemWithTag:tagPorgrams] setState:NSOnState];
	[self updateToolTip];
}

- (void) removeFromUserMenu:(NSMenuItem *)item
{
	[[[statusbarMenu itemWithTag:tagPorgrams] submenu] removeItem:item];
	[self decleaseProgCount];
	if (--userProgramCount == 0)
	{
		[[statusbarMenu itemWithTag:tagPorgrams] setState:NSOffState];
		[[statusbarMenu itemWithTag:tagPorgrams] setTitle:TITLEUSERNOPROG];
		[[statusbarMenu itemWithTag:tagPorgrams] setSubmenu:nil];
		[[statusbarMenu itemWithTag:tagPorgrams] setEnabled:NO];
		
	}
	else if (userProgramCount == 1)
	{
		[[statusbarMenu itemWithTag:tagPorgrams] setTitle:TITLEUSERSINGLEPROG];
	}// end if
	
	[self updateToolTip];
}// end - (void) removeFromUserMenu:(NSMenuItem *)item

- (void) addToOfficialMenu:(NSMenuItem *)item
{
	if (officialProgramCount == 0)
	{
		NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
		[[statusbarMenu itemWithTag:tagOfficial] setSubmenu:menu];
		[[statusbarMenu itemWithTag:tagOfficial] setTitle:TITLEOFFICIALSINGLEPROG];
		[[statusbarMenu itemWithTag:tagOfficial] setEnabled:YES];
#if __has_feature(objc_arc) == 0
		[menu autorelease];
#endif
	}
	else if (officialProgramCount == 1)
	{
		[[statusbarMenu itemWithTag:tagOfficial] setTitle:TITLEOFFICIALSOMEPROG];
	}
	[[[statusbarMenu itemWithTag:tagOfficial] submenu] insertItem:item atIndex:0];
	[self incleaseProgCount];
	if (++officialProgramCount > 0)
		[[statusbarMenu itemWithTag:tagOfficial] setState:NSOnState];
	[self updateToolTip];
}

- (void) removeFromOfficialMenu:(NSMenuItem *)item
{
	[[[statusbarMenu itemWithTag:tagOfficial] submenu] removeItem:item];
	[self decleaseProgCount];
	if (--officialProgramCount == 0)
	{
		[[statusbarMenu itemWithTag:tagOfficial] setState:NSOffState];
		[[statusbarMenu itemWithTag:tagOfficial] setTitle:TITLEOFFICIALNOPROG];
		[[statusbarMenu itemWithTag:tagOfficial] setSubmenu:nil];
		[[statusbarMenu itemWithTag:tagOfficial] setEnabled:NO];
	}
	else if (officialProgramCount == 1)
	{
		[[statusbarMenu itemWithTag:tagOfficial] setTitle:TITLEOFFICIALSINGLEPROG];
	}// end if
	
	[self updateToolTip];
}// end - (void) removeFromOfficialMenu:(NSMenuItem *)item

- (void) incleaseProgCount
{
	numberOfPrograms++;
	connected = YES;
	[self makeStatusbarIcon];
}// end - (BOOL) incleaseProgCount

- (void) decleaseProgCount
{
	if (numberOfPrograms > 0)
		numberOfPrograms--;
	[self makeStatusbarIcon];
}// end - (BOOL) decleaseProgCount

#pragma mark - private
- (CIImage *) createFromResource:(NSString *)imageName
{
	NSImage *image = [NSImage imageNamed:imageName];
	NSData *imageData = [image TIFFRepresentation];
	
	return [CIImage imageWithData:imageData];
}// end - (CIImage *) createFromResource:(NSString *)imageName

- (void) setupMembers:(NSString *)imageName
{
#if __has_feature(objc_arc)
#else
#endif
	drawPoint = NSMakePoint(progCountPointSingleDigitX, progCountPointY);
	iconSize = NSMakeSize(iconSizeW, iconSizeH);
	sourceImage = [self createFromResource:imageName];
	statusbarIcon = [[NSImage alloc] initWithSize:iconSize];
	statusbarAlt = [[NSImage alloc] initWithSize:iconSize];
	gammaFilter = [CIFilter filterWithName:@"CIGammaAdjust"];
	gammaPower = [NSNumber numberWithFloat:noProgPower];
	invertFilter = [CIFilter filterWithName:@"CIColorInvert"];
	progCountFont = [NSFont fontWithName:@"CourierNewPS-BoldItalicMT" size:progCountFontSize];
	fontAttrDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSColor whiteColor], NSForegroundColorAttributeName, progCountFont,NSFontAttributeName, nil];
	fontAttrInvertDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSColor blackColor], NSForegroundColorAttributeName, progCountFont ,NSFontAttributeName, nil];
	// create bezier path for program number's background
	progCountBackground = [NSBezierPath bezierPath];
	[progCountBackground setLineCapStyle:NSRoundLineCapStyle];
	[progCountBackground setLineWidth:progCountBackGroundWidth];
	[progCountBackground moveToPoint:NSMakePoint(progCountBackGrountFromX, progCountBackGrountFromY)];
	[progCountBackground lineToPoint:NSMakePoint(progCountBackGrountToX, progCountBackGrountToY)];
	
	// create bezier path for dissconect cross mark
	disconnectPath = [[NSBezierPath alloc] init];
	[disconnectPath setLineCapStyle:NSRoundLineCapStyle];
	[disconnectPath setLineWidth:disconnectPathWidth];
	[disconnectPath moveToPoint:NSMakePoint(disconnectPathOffset, disconnectPathOffset)];
	[disconnectPath lineToPoint:NSMakePoint((iconSizeW - disconnectPathOffset), (iconSizeH - disconnectPathOffset))];
	[disconnectPath moveToPoint:NSMakePoint(disconnectPathOffset, (iconSizeH - disconnectPathOffset))];
	[disconnectPath lineToPoint:NSMakePoint(iconSizeH - disconnectPathOffset, disconnectPathOffset)];
	
	// make each color for background and disconnect cross
	progCountBackColor = [NSColor colorWithCalibratedRed:progCountBackColorRed green:progCountBackColorGreen blue:progCountBackColorBlue alpha:progCountBackColorAlpha];
	disconnectColor = [NSColor colorWithCalibratedRed:disconnectedColorRed green:disconnectedColorGreen blue:disconnectedColorBlue alpha:disconnectedColorAlpha];
#if __has_feature(objc_arc)
#else
#endif
}// end - (void) setupMembers

- (void) installStatusbarMenu
{
	statusBar = [NSStatusBar systemStatusBar];
	statusBarItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];
#if __has_feature(objc_arc) == 0
	[statusBarItem retain];
	[statusBar retain];
#endif
	[statusBarItem setTitle:@""];
	[statusBarItem setImage:statusbarIcon];
	[statusBarItem setAlternateImage:statusbarAlt];
	[statusBarItem setToolTip:@"NicoLiveAlert"];
	[statusBarItem setHighlightMode:YES];
		// localize
	[[statusbarMenu itemWithTag:tagAutoOpen] setTitle:TITLEAUTOOPEN];
	[[statusbarMenu itemWithTag:tagPorgrams] setTitle:TITLEUSERNOPROG];
	[[statusbarMenu itemWithTag:tagOfficial] setTitle:TITLEOFFICIALNOPROG];
	[[statusbarMenu itemWithTag:tagAccounts] setTitle:TITLEACCOUNTS];
	[[statusbarMenu	itemWithTag:tagLaunchApplications] setTitle:TITLELAUNCHER];
	[[statusbarMenu itemWithTag:tagPreference] setTitle:TITLEPREFERENCE];
	[[statusbarMenu itemWithTag:tagCheckUpdate] setTitle:TITLECHECKUPDATE];
	[[statusbarMenu itemWithTag:tagQuit] setTitle:TITLEQUIT];

	NSImage *onImage = [NSImage imageNamed:OnImageName];
	NSImage *offImage = [NSImage imageNamed:OffImageName];
	NSImage *mixedImage = [NSImage imageNamed:MixedImageName];
	NSMenuItem *accountItem = [statusbarMenu itemWithTag:tagAccounts];
	[accountItem setOnStateImage:onImage];
	[accountItem setOffStateImage:offImage];
	[accountItem setMixedStateImage:mixedImage];

	[statusBarItem setMenu:statusbarMenu];
}// end - (void) installStatusbarMenu

- (void) makeStatusbarIcon
{
	@autoreleasepool {
		CIImage *invertImage = nil;
		CIImage *destImage = nil;
		[statusbarIcon setSize:iconSize];
		[statusbarAlt setSize:iconSize];
		if ((userState == NSOffState) || (connected == NO))
		{		// crop image
			// gamma adjust image
			[gammaFilter setValue:sourceImage forKey:@"inputImage"];
			[gammaFilter setValue:gammaPower forKey:@"inputPower"];
			destImage = [gammaFilter valueForKey:@"outputImage"];
		}
		else
		{
			destImage = sourceImage;
		}// end if number of programs
		
		[invertFilter setValue:destImage forKey:@"inputImage"];
		invertImage = [invertFilter valueForKey:@"outputImage"];
		
		NSCIImageRep *sb = [NSCIImageRep imageRepWithCIImage:destImage];
		NSCIImageRep *alt = [NSCIImageRep imageRepWithCIImage:invertImage];
		
		// draw program count on image
		NSString *progCountStr = [NSString stringWithFormat:@"%ld", numberOfPrograms];
		if ((numberOfPrograms == 0) || (connected == NO))
		{
			statusbarIcon = [[NSImage alloc] initWithSize:NSMakeSize(noProgWidth, iconSizeW)];
			statusbarAlt = [[NSImage alloc] initWithSize:NSMakeSize(noProgWidth, iconSizeW)];
		}
		else if (numberOfPrograms > 99)
		{
			[progCountBackground removeAllPoints];
			[progCountBackground moveToPoint:NSMakePoint(progCountBackGrountFromX, progCountBackGrountFromY)];
			[progCountBackground lineToPoint:NSMakePoint(progCountBackGrountToX + (progCountBackDigitOffset * 2), progCountBackGrountToY)];
			statusbarIcon = [[NSImage alloc] initWithSize:NSMakeSize(haveProgWidth + (progCountBackDigitOffset * 2), iconSizeW)];
			statusbarAlt = [[NSImage alloc] initWithSize:NSMakeSize(haveProgWidth + (progCountBackDigitOffset * 2), iconSizeW)];
		}
		else if (numberOfPrograms > 9)
		{
			[progCountBackground removeAllPoints];
			[progCountBackground moveToPoint:NSMakePoint(progCountBackGrountFromX, progCountBackGrountFromY)];
			[progCountBackground lineToPoint:NSMakePoint(progCountBackGrountToX + progCountBackDigitOffset, progCountBackGrountToY)];
			statusbarIcon = [[NSImage alloc] initWithSize:NSMakeSize(haveProgWidth + progCountBackDigitOffset, iconSizeW)];
			statusbarAlt = [[NSImage alloc] initWithSize:NSMakeSize(haveProgWidth + progCountBackDigitOffset, iconSizeW)];
		}
		else if (numberOfPrograms > 0)
		{
			[progCountBackground removeAllPoints];
			[progCountBackground moveToPoint:NSMakePoint(progCountBackGrountFromX, progCountBackGrountFromY)];
			[progCountBackground lineToPoint:NSMakePoint(progCountBackGrountToX, progCountBackGrountToY)];
			statusbarIcon = [[NSImage alloc] initWithSize:NSMakeSize(haveProgWidth, iconSizeW)];
			statusbarAlt = [[NSImage alloc] initWithSize:NSMakeSize(haveProgWidth, iconSizeW)];
		}// end if adjust icon withd by program count.
		
		// draw for image.
		[statusbarIcon lockFocus];
		[sb drawAtPoint:NSMakePoint(origin, origin)];
		// set connect/disconnect status
		if (connected == NO)
		{
			[disconnectColor set];
			[disconnectPath stroke];
		}// end if disconnected
		[progCountBackColor set];
		[progCountBackground stroke];
		[progCountStr drawAtPoint:drawPoint withAttributes:fontAttrDict];
		[statusbarIcon unlockFocus];
		
		// draw for alt image.
		[statusbarAlt lockFocus];
		[alt drawAtPoint:NSMakePoint(origin, origin)];
		[[NSColor whiteColor] set];
		if (connected == NO)
		{
			[disconnectPath stroke];
		}// end if disconnected
		[progCountBackground stroke];
		[progCountStr drawAtPoint:drawPoint withAttributes:fontAttrInvertDict];
		[statusbarAlt unlockFocus];
		
		// update status bar icon.
		[statusBarItem setImage:statusbarIcon];
		[statusBarItem setAlternateImage:statusbarAlt];

		// update User state
		[[statusbarMenu itemWithTag:tagAccounts] setState:userState];
		
		// update tooltip
		[self updateToolTip];
	}
}// end - (CIImage *) makeStatusbarIcon

- (void) updateToolTip
{
	NSMutableString *tooltip = nil;
	NSMutableArray *array = [NSMutableArray array];
	if (connected == NO)
	{
		[statusBarItem setToolTip:DeactiveConnection];
		return;
	}// end if disconnected
	
	if ((userProgramCount == 0) && (officialProgramCount == 0))
	{
		[statusBarItem setToolTip:ActiveNoprogString];
		return;
	}// end if program not found
	
	if (userProgramCount > 0)
	{
		tooltip = [NSMutableString stringWithFormat:userProgramOnly, userProgramCount];
		if (userProgramCount > 1)
			[tooltip appendString:TwoOrMoreSuffix];
		// end if program count is two or more
		[array addObject:tooltip];
		tooltip = nil;
	}// end if user program found
	
	if (officialProgramCount > 0)
	{
		tooltip = [NSMutableString stringWithFormat:officialProgramOnly, officialProgramCount];
		if (officialProgramCount > 1)
			[tooltip appendString:TwoOrMoreSuffix];
		// end if program count is two or more
		[array addObject:tooltip];
		tooltip = nil;
	}// end if user program found
	
	[statusBarItem setToolTip:[array componentsJoinedByString:StringConcatinater]];
}// end - (void) updateToolTip

#pragma mark - C functions

@end
