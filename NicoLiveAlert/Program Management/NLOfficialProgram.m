//
//  NLOfficialProgram.m
//  NicoLiveAlert
//
//  Created by Чайка on 7/8/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import "NLOfficialProgram.h"
#import "NicoLiveAlertDefinitions.h"
#import "HTTPConnection.h"
#import <CocoaOniguruma/OnigRegexp.h>

const static CGFloat ProgramBoundsW = 300;
const static CGFloat ProgramBoundsH = 50;
const static CGFloat thumnailSize = 50;

const static CGFloat offsetTitleX = 60;
const static CGFloat offsetTitleY = 15;
const static CGFloat boundsTitleW = ProgramBoundsW - offsetTitleX - thumnailSize ;
const static CGFloat boundsTitleH = ProgramBoundsH - offsetTitleY;

#pragma mark color constant
static const CGFloat alpha = 1.0;
	// program title color
static const CGFloat ProgramTitleColorRed = (0.0 / 255);
static const CGFloat ProgramTitleColorGreen = (0.0 / 255);
static const CGFloat ProgramTitleColorBlue = (255.0 / 255);
	// account color
static const CGFloat AccountColorRed = (0.0 / 255);
static const CGFloat AccountColorGreen = (128.0 / 255);
static const CGFloat AccountColorBlue = (128.0 / 255);
	// remain time color
static const CGFloat TimeColorRed = (128.0 / 255);
static const CGFloat TimeColorGreen = (0.0 / 255);
static const CGFloat TimeColorBlue = (64.0 / 255);

@interface NLOfficialProgram ()
- (void) parseEmbed:(NSString *)liveNumber;
@end

@implementation NLOfficialProgram
#pragma mark - synthesize properties
#pragma mark - class method
#pragma mark - constructor / destructor
- (id) initWithLiveNumber:(NSString *)liveno
{
	self = [super init];
	if (self) {
		[self parseEmbed:liveno];
		programNumber = [[NSString alloc] initWithString:liveno];
		communityName = @"Official";
	}// end if self

	return self;
}// end - (id) initWithLiveNumber:(NSString *)liveno
#pragma mark - override
#pragma mark - delegate
#pragma mark - properties
#pragma mark - actions
#pragma mark - messages
#pragma mark - private
- (void) parseEmbed:(NSString *)liveNumber
{
	NSString *embedURLString = [NicoStreamEmbedQuery stringByAppendingString:liveNumber];
	NSURL *embedURL = [NSURL URLWithString:embedURLString];
	NSURLResponse *resp;
	NSString *embedSource = [HTTPConnection HTTPSource:embedURL response:&resp];

		// get program title
	OnigRegexp *regex = [OnigRegexp compile:ProgramTtileRegex];
	OnigResult *res = [regex search:embedSource];
	if (res != nil)
		programTitle = [[NSString alloc] initWithString:[res stringAt:1]];

		// get thumbnail
	regex = [OnigRegexp compile:ProgramThumbnailRegex];
	res = [regex search:embedSource];
	if (res != nil) {
		NSURL *url = [NSURL URLWithString:[res stringAt:1]];
		NSData *thumbData = [HTTPConnection HTTPData:url response:&resp];
		thumbnail = [[NSImage alloc] initWithData:thumbData];
	}// end if

		// get start time
	regex = [OnigRegexp compile:ProgramStartTimeRegex];
	res = [regex search:embedSource];
	if (res != nil) {
		NSString *originalDateString = [res stringAt:1];
		NSString *sanitizedDateString = [originalDateString replaceAllByRegexp:DateSanityRegex with:EmptyString];
		NSDictionary *localeDict = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
		startTime = [NSDate dateWithNaturalLanguageString:sanitizedDateString locale:localeDict];
		startTimeString = [startTime descriptionWithCalendarFormat:@"%H:%M" timeZone:[NSTimeZone localTimeZone] locale:nil];
		if ([startTime compare:[NSDate date]] == NSOrderedDescending)
			reserved = YES;
	}// end if
	
}// end - (void) parseEmbed:(NSString *)liveNumber

- (void) drawContents
{
	NSColor *titleColor = [NSColor colorWithCalibratedRed:ProgramTitleColorRed green:ProgramTitleColorGreen blue:ProgramTitleColorBlue alpha:alpha];
	NSColor *accountColor = [NSColor colorWithCalibratedRed:AccountColorRed green:AccountColorGreen blue:AccountColorBlue alpha:alpha];
	NSColor *timeColor = [NSColor colorWithCalibratedRed:TimeColorRed green:TimeColorGreen blue:TimeColorBlue alpha:alpha];

	menuImage = [[NSImage alloc] initWithSize:NSMakeSize(ProgramBoundsW, ProgramBoundsH)];
	[menuImage lockFocus];
		// draw thumbnail
	[thumbnail setSize:NSMakeSize(thumnailSize, thumnailSize)];
	[thumbnail drawInRect:NSMakeRect(0.0f, 0.0f, thumnailSize, thumnailSize)];

		// draw title
	stringAttributes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
						[NSFont fontWithName:fontNameOfProgramTitle size:11], NSFontAttributeName,
						titleColor, NSForegroundColorAttributeName,
						[NSNumber numberWithInteger:2], NSLigatureAttributeName,
						[NSNumber numberWithFloat:-0.5f], NSKernAttributeName, nil];
	NSRect titleRect = NSMakeRect(offsetTitleX, offsetTitleY, boundsTitleW, boundsTitleH);
	[programTitle drawInRect:titleRect withAttributes:stringAttributes];
		// draw primary account
	[stringAttributes setValue:[NSFont fontWithName:fontNameOfPrimaryAccount size:13] forKey:NSFontAttributeName];
	[stringAttributes setValue:accountColor forKey:NSForegroundColorAttributeName];
	[communityName drawAtPoint:NSMakePoint(offsetTitleX, 0) withAttributes:stringAttributes];
	[menuImage unlockFocus];
}// end - (void) drawContents
#pragma mark - C functions

@end
