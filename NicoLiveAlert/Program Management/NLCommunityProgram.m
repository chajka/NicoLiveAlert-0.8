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

@interface NLCommunityProgram ()
- (void) parseStreamInfo:(NSString *)liveNumber;
- (void) correctOwnerName:(NSString *)ownerID;
@end

@implementation NLCommunityProgram
#pragma mark - synthesize properties
#pragma mark - class method
#pragma mark - constructor / destructor
- (id) initWithLiveNumber:(NSString *)liveno owner:(NSString *)owner
{
	self = [super initWithLiveNumber:liveno];
	if (self) {
		[self parseStreamInfo:liveno];
		[self correctOwnerName:owner];
	}// end if self

	return self;
}// end - (id) initWithLiveNumber:(NSString *)liveno owner:(NSString *)owner
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
		ownerName = [[NSString alloc] initWithString:[res stringAt:1]];
}// end - (void) correctOwnerName:(NSString *)ownerID

- (void) notify
{
	NSString *notificationName = GrowlNotifyStartUserProgram;
	if (reserved == YES) {
		NSTimer *notifyTimer = [[NSTimer alloc] initWithFireDate:startTime interval:0 target:self selector:@selector(notify:) userInfo:nil repeats:NO];
		[[NSRunLoop currentRunLoop] addTimer:notifyTimer forMode:NSDefaultRunLoopMode];
		notificationName = GrowlNotifyFoundUserProgram;
	}// end if

	[GrowlApplicationBridge notifyWithTitle:programTitle description:programDescription notificationName:notificationName iconData:[thumbnail TIFFRepresentation] priority:0 isSticky:NO clickContext:nil];
}// end - (void) notify
#pragma mark - private
- (void) notify:(NSTimer *)timer
{
	[GrowlApplicationBridge notifyWithTitle:programTitle description:programDescription notificationName:GrowlNotifyStartUserProgram iconData:[thumbnail TIFFRepresentation] priority:0 isSticky:NO clickContext:nil];
}// end - (void) notify:(NSTimer *)timer

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
			if (communityName == nil)
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
