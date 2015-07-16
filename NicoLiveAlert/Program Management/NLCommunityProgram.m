//
//  NLCommunityProgram.m
//  NicoLiveAlert
//
//  Created by Чайка on 7/10/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import "NLCommunityProgram.h"
#import "NicoLiveAlertDefinitions.h"
#import "HTTPConnection.h"
#import <Growl/Growl.h>
#import <CocoaOniguruma/OnigRegexp.h>

const static CGFloat ProgramBoundsW = 300;
const static CGFloat ProgramBoundsH = 80;
const static CGFloat thumnailSize = 50;

const static CGFloat DescriptionOffsetX = thumnailSize + 5;
const static CGFloat DescriptionOffsetY = 15;
const static CGFloat DescriptionBoundsW = ProgramBoundsW - thumnailSize - 5;
const static CGFloat DescriptionBoundsH = thumnailSize - DescriptionOffsetY;

const static CGFloat CommunityNameOffsetX = 0;
const static CGFloat CommunityNameOffsetY = 66;
const static CGFloat CommunityNameBoundsW = ProgramBoundsW * 2 / 3;
const static CGFloat CommunityNameBoundsH = 15;

const static CGFloat NicknameOffsetX = CommunityNameOffsetX + CommunityNameBoundsW + 5;
const static CGFloat NicknameOffsetY = CommunityNameOffsetY;

const static CGFloat OffsetTitleX = 0;
const static CGFloat OffsetTitleY = thumnailSize + 2;

const static CGFloat OffsetPrimaryX = thumnailSize + 3;
const static CGFloat OffsetPrimaryY = 0;

#pragma mark color constant
static const CGFloat alpha = 1.0;
static const CGFloat fract = 1.0;
// program title color
static const CGFloat ProgramTitleColorRed = (0.0 / 255);
static const CGFloat ProgramTitleColorGreen = (0.0 / 255);
static const CGFloat ProgramTitleColorBlue = (255.0 / 255);
// program owner color
static const CGFloat ProgramOwnerColorRed = (128.0 / 255);
static const CGFloat ProgramOwnerColorGreen = (64.0 / 255);
static const CGFloat ProgramOwnerColorBlue = (0.0 / 255);
// program description color
static const CGFloat ProgramDescColorRed = (64.0 / 255);
static const CGFloat ProgramDescColorGreen = (64.0 / 255);
static const CGFloat ProgramDescColorBlue = (64.0 / 255);
// commnunity name color
static const CGFloat CommunityNameColorRed = (204.0 / 255);
static const CGFloat CommunityNameColorGreen = (102.0 / 255);
static const CGFloat CommunityNameColorBlue = (255.0 / 255);
// account color
static const CGFloat AccountColorRed = (0.0 / 255);
static const CGFloat AccountColorGreen = (128.0 / 255);
static const CGFloat AccountColorBlue = (128.0 / 255);
// remain time color
static const CGFloat TimeColorRed = (128.0 / 255);
static const CGFloat TimeColorGreen = (0.0 / 255);
static const CGFloat TimeColorBlue = (64.0 / 255);

@interface NLCommunityProgram ()
- (void) parseStreamInfo:(NSString *)liveNumber;
- (void) correctOwnerName:(NSString *)ownerID;
@end

@implementation NLCommunityProgram
#pragma mark - synthesize properties
#pragma mark - class method
#pragma mark - constructor / destructor
- (id) initWithLiveNumber:(NSString *)liveno owner:(NSString *)owner primaryAccount:(NSString *)accnt
{
	self = [super initWithLiveNumber:liveno];
	if (self) {
		primaryAccount = [[NSString alloc] initWithString:accnt];
		[self parseStreamInfo:liveno];
		[self correctOwnerName:owner];
	}// end if self

	return self;
}// end - (id) initWithLiveNumber:(NSString *)liveno owner:(NSString *)owner primaryAccount:(NSString *)accnt
#pragma mark - override
#pragma mark - delegate
#pragma mark - properties
#pragma mark - actions
#pragma mark - messages
#pragma mark - private
- (void) parseStreamInfo:(NSString *)liveNumber
{
	NSString *streaminfoString = [NicoStreamInfoQuery stringByAppendingString:liveNumber];
	NSURL *streamInfoURL = [NSURL URLWithString:streaminfoString];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:streamInfoURL];
	[parser setDelegate:self];
	[parser parse];
}// end - (void) parseStreamInfo:(NSString *)liveNumber

- (void) correctOwnerName:(NSString *)ownerID
{
	NSString *nicknameQueryURLString = [NicknameQuery stringByAppendingString:ownerID];
	NSURL *nicknameQueryURL = [NSURL URLWithString:nicknameQueryURLString];
	NSURLResponse *resp;
	NSString *nicknameResult = [HTTPConnection HTTPSource:nicknameQueryURL response:&resp];
	OnigRegexp *regex = [OnigRegexp compile:NicknamePickupRegex];
	OnigResult *res = [regex search:nicknameResult];
	if (res != nil)
		broadcastOwnerName = [[NSString alloc] initWithString:[res stringAt:1]];
}// end - (void) correctOwnerName:(NSString *)ownerID

- (void) notify
{
	NSString *notificationName = GrowlNotifyStartUserProgram;
	if (reserved == YES) {
#ifdef DEBUG
		NSLog(@"Hook Notify");
#endif
		notifyTimer = [[NSTimer alloc] initWithFireDate:startTime interval:10 target:self selector:@selector(notifyTimer:) userInfo:nil repeats:NO];
		[[NSRunLoop currentRunLoop] addTimer:notifyTimer forMode:NSDefaultRunLoopMode];
#ifdef DEBUG
		NSLog(@"Timer is %@", [notifyTimer isValid] ? @"valid" : @"invarid");
		NSLog(@"FireDate : %@", [[notifyTimer fireDate] descriptionWithCalendarFormat:nil timeZone:[NSTimeZone localTimeZone] locale:nil]);
#endif
		notificationName = GrowlNotifyFoundUserProgram;
	}// end if

	[GrowlApplicationBridge notifyWithTitle:programTitle description:programDescription notificationName:notificationName iconData:[thumbnail TIFFRepresentation] priority:0 isSticky:NO clickContext:nil];
}// end - (void) notify
#pragma mark - private
- (void) notifyTimer:(NSTimer *)timer
{
#ifdef DEBUG
	NSLog(@"Timerd Notify");
#endif
	[GrowlApplicationBridge notifyWithTitle:programTitle
								description:programDescription
						   notificationName:GrowlNotifyStartUserProgram
								   iconData:[thumbnail TIFFRepresentation]
								   priority:0
								   isSticky:NO
							   clickContext:nil];
}// end - (void) notify:(NSTimer *)timer

- (void) drawContents
{
	NSColor *titleColor = [NSColor colorWithCalibratedRed:ProgramTitleColorRed green:ProgramTitleColorGreen blue:ProgramTitleColorBlue alpha:alpha];
	NSColor *nickColor = [NSColor colorWithCalibratedRed:ProgramOwnerColorRed green:ProgramOwnerColorGreen blue:ProgramOwnerColorBlue alpha:alpha];
	NSColor *descColor = [NSColor colorWithCalibratedRed:ProgramDescColorRed green:ProgramDescColorGreen blue:ProgramDescColorBlue alpha:alpha];
	NSColor *commnunityColor = [NSColor colorWithCalibratedRed:CommunityNameColorRed green:CommunityNameColorGreen blue:CommunityNameColorBlue alpha:alpha];
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
	[programTitle drawAtPoint:NSMakePoint(OffsetTitleX, OffsetTitleY) withAttributes:stringAttributes];
		// draw description
	[stringAttributes setValue:[NSFont fontWithName:fontNameOfDescription size:10] forKey:NSFontAttributeName];
	[stringAttributes setValue:descColor forKey:NSForegroundColorAttributeName];
	NSRect descriptionRect = NSMakeRect(DescriptionOffsetX, DescriptionOffsetY, DescriptionBoundsW, DescriptionBoundsH);
	[programDescription drawInRect:descriptionRect withAttributes:stringAttributes];
		// draw community title
	[stringAttributes setValue:[NSFont fontWithName:fontNameOfCommunity size:11] forKey:NSFontAttributeName];
	[stringAttributes setValue:commnunityColor forKey:NSForegroundColorAttributeName];
	NSRect communityNameRect = NSMakeRect(CommunityNameOffsetX, CommunityNameOffsetY, CommunityNameBoundsW, CommunityNameBoundsH);
	[communityName drawInRect:communityNameRect withAttributes:stringAttributes];
		// draw program owner
	[stringAttributes setValue:[NSFont fontWithName:fontNameOfProgramOwner size:11] forKey:NSFontAttributeName];
	[stringAttributes setValue:nickColor forKey:NSForegroundColorAttributeName];
	NSPoint ownerNamePoint = NSMakePoint(NicknameOffsetX, NicknameOffsetY);
	[broadcastOwnerName drawAtPoint:ownerNamePoint withAttributes:stringAttributes];
		// draw primary account
	[stringAttributes setValue:[NSFont fontWithName:fontNameOfPrimaryAccount size:13] forKey:NSFontAttributeName];
	[stringAttributes setValue:accountColor forKey:NSForegroundColorAttributeName];
	[primaryAccount drawAtPoint:NSMakePoint(OffsetPrimaryX, OffsetPrimaryY) withAttributes:stringAttributes];
	[menuImage unlockFocus];
}// end - (void) drawContents

#pragma mark - NSXMLParser degegate methods
- (void) parserDidStartDocument:(NSXMLParser *)parser
{
	elementsDict = [[NSDictionary alloc] initWithObjectsAndKeys:
					[NSNumber numberWithInteger:IndexRequestID], elementKeyRequestID,
					[NSNumber numberWithInteger:IndexProgramTitle], elementKeyProgramTitle,
					[NSNumber numberWithInteger:IndexProgramDesc], elementKeyProgramDescription,
					[NSNumber numberWithInteger:IndexDefaultCommunity], elementKeyDefaultCommunity,
					[NSNumber numberWithInteger:IndexCommunityName], elementKeyCommunityName, nil];
	stringBuffer = [[NSMutableString alloc] init];
}// end - (void) parserDidStartDocument:(NSXMLParser *)parser

- (void) parserDidEndDocument:(NSXMLParser *)parser
{
	elementsDict = nil;
	stringBuffer = nil;
}// end - (void) parserDidEndDocument:(NSXMLParser *)parser

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	NSInteger length = [stringBuffer length];
	NSRange range = NSMakeRange(0, length);
	[stringBuffer deleteCharactersInRange:range];
}// end - (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	NSInteger index = [[elementsDict valueForKey:elementName] integerValue];
	switch (index) {
		case IndexProgramTitle:
			if (programTitle == nil)
				programTitle = [[NSString alloc] initWithString:stringBuffer];
			break;
		case IndexProgramDesc:
			programDescription = [[NSString alloc] initWithString:stringBuffer];
			break;
		case IndexDefaultCommunity:
			communityNumber = [[NSString alloc] initWithString:stringBuffer];
			break;
		case IndexCommunityName:
			if ([communityName isEqualToString:@"Official"])
				communityName = [[NSString alloc] initWithString:stringBuffer];
			break;
		default:
			break;
	}
}// end - (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	[stringBuffer appendString:string];
}// end - (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string

/*
- (void) parser:(NSXMLParser *)parser didStartMappingPrefix:(NSString *)prefix toURI:(NSString *)namespaceURI
{
	<#code#>
}// end - (void) parser:(NSXMLParser *)parser didStartMappingPrefix:(NSString *)prefix toURI:(NSString *)namespaceURI

- (void) parser:(NSXMLParser *)parser didEndMappingPrefix:(NSString *)prefix
{
	<#code#>
}// end - (void) parser:(NSXMLParser *)parser didEndMappingPrefix:(NSString *)prefix

- (NSData *) parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)entityName systemID:(NSString *)systemID
{
	<#code#>
	
	return <#NSData#>;
}// end - (NSData *) parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)entityName systemID:(NSString *)systemID

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	<#code#>
}// end - (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError

- (void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError
{
	<#code#>
}// end - (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError

- (void) parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString
{
	<#code#>
}// end - (void) parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString

- (void) parser:(NSXMLParser *)parser foundProcessingInstructionWithTarget:(NSString *)target data:(NSString *)data
{
	<#code#>
}// end - (void) parser:(NSXMLParser *)parser foundProcessingInstructionWithTarget:(NSString *)target data:(NSString *)data

- (void) parser:(NSXMLParser *)parser foundComment:(NSString *)comment
{
	<#code#>
}// end - (void) parser:(NSXMLParser *)parser foundComment:(NSString *)comment

- (void) parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
	<#code#>
}// end - (void) parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock

#pragma mark DTD
- (void) parser:(NSXMLParser *)parser foundAttributeDeclarationWithName:(NSString *)attributeName forElement:(NSString *)elementName type:(NSString *)type defaultValue:(NSString *)defaultValue
{
	<#code#>
}// end - (void) parser:(NSXMLParser *)parser foundAttributeDeclarationWithName:(NSString *)attributeName forElement:(NSString *)elementName type:(NSString *)type defaultValue:(NSString *)defaultValue

- (void) parser:(NSXMLParser *)parser foundElementDeclarationWithName:(NSString *)elementName model:(NSString *)model
{
	<#code#>
}// end - (void) parser:(NSXMLParser *)parser foundElementDeclarationWithName:(NSString *)elementName model:(NSString *)model

- (void) parser:(NSXMLParser *)parser foundExternalEntityDeclarationWithName:(NSString *)entityName publicID:(NSString *)publicID systemID:(NSString *)systemID
{
	<#code#>
}// end - (void) parser:(NSXMLParser *)parser foundExternalEntityDeclarationWithName:(NSString *)entityName publicID:(NSString *)publicID systemID:(NSString *)systemID

- (void) parser:(NSXMLParser *)parser foundInternalEntityDeclarationWithName:(NSString *)name value:(NSString *)value
{
	<#code#>
}// end - (void) parser:(NSXMLParser *)parser foundInternalEntityDeclarationWithName:(NSString *)name value:(NSString *)value

- (void) parser:(NSXMLParser *)parser foundUnparsedEntityDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID notationName:(NSString *)notationName
{
	<#code#>
}// end - (void) parser:(NSXMLParser *)parser foundUnparsedEntityDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID notationName:(NSString *)notationName

- (void) parser:(NSXMLParser *)parser foundNotationDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID
{
	<#code#>
}// end - (void) parser:(NSXMLParser *)parser foundNotationDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID
*/
@end
