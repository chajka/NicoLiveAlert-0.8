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
#ifdef DEBUG
		NSLog(@"thumbnail : %@", thumbnail);
#endif
	}// end if

		// get start time
	regex = [OnigRegexp compile:ProgramStartTimeRegex];
	res = [regex search:embedSource];
	if (res != nil) {
		NSString *originalDateString = [res stringAt:1];
		NSString *sanitizedDateString = [originalDateString replaceAllByRegexp:DateSanityRegex with:EmptyString];
		NSDictionary *localeDict = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
		startTime = [NSDate dateWithNaturalLanguageString:sanitizedDateString locale:localeDict];
	}// end if

		// get time shift state
	regex = [OnigRegexp compile:ProgramStatusRegex];
	res = [regex search:embedSource];
	if (res != nil) {
		NSString *state = [res stringAt:1];
		if ([state isEqualToString:BEFORETSSTATE])
			reserved = YES;
		else
			reserved = NO;
	}// end if
		
}// end - (void) parseEmbed:(NSString *)liveNumber
#pragma mark - C functions

@end
