//
//  NLUser.m
//  NicoLiveAlert
//
//  Created by Чайка on 7/6/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import "NLUser.h"
#import "NicoLiveAlertDefinitions.h"

@interface NLUser ()
- (BOOL) getTicket;
- (void) getUserInfo;
@end

@implementation NLUser
#pragma mark - synthesize properties
@synthesize userID;
@synthesize nickname;
@synthesize watchEnable;
@synthesize joined;
@synthesize server;
@synthesize port;
@synthesize thread;
@synthesize ticket;

#pragma mark - class method
#pragma mark - constructor / destructor
- (id) initWithAccount:(NSString *)account_
{
	self = [super init];
	if (self) {
		account = [YCHTTPSKeychainItem userInKeychain:account_ forURL:[NSURL URLWithString:NicoLoginForm]];
		if (account == nil)
			return nil;
		connection = [[HTTPConnection alloc] init];
		if ([self getTicket] == NO)
			return nil;
		joined = [[NSMutableArray alloc] init];
		[self getUserInfo];
		if (nickname == nil)
			return nil;
	}// end if self

	return self;
}// end - (id) initWithAccount:(NSString *)account
#pragma mark - override
#pragma mark - delegate
#pragma mark - properties
- (NSString *) mailaddress { return account.account; }
- (NSString *) password	{ return account.password; }
#pragma mark - actions
#pragma mark - messages
#pragma mark - private
- (BOOL) getTicket
{
	NSURL *url = [NSURL URLWithString:NicoLoginGetTicketURL];
	NSMutableDictionary *params = [NSMutableDictionary dictionary];
	[params setValue:@"nicolive_antenna" forKey:@"site"];
	[params setValue:account.account forKey:@"mail"];
	[params setValue:account.password forKey:@"password"];

	NSError *err = nil;
	[connection setURL:url andParams:params];
	NSData *result = [connection dataByPost:&err];

	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:result];
	[parser setDelegate:self];
	[parser parse];

	if (ticket == nil)
		return NO;
	else
		return YES;
}// end - (BOOL) getTicket

- (void) getUserInfo
{
	NSURL *url = [NSURL URLWithString:NicoLiveGetAlertStatusURL];
	NSMutableDictionary *params = [NSMutableDictionary dictionary];
	[params setValue:ticket forKey:@"ticket"];

	NSError *err = nil;
	[connection setURL:url andParams:params];
	NSData *result = [connection dataByPost:&err];
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:result];
	[parser setDelegate:self];
	[parser parse];
}// end - (void) getUserInfo
#pragma mark - C functions
#pragma mark - NSXMLParser degegate methods

- (void) parserDidStartDocument:(NSXMLParser *)parser
{
	elementsDict = [[NSDictionary alloc] initWithObjectsAndKeys:
			[NSNumber numberWithInteger:indexUserID], elementKeyUserID,
			[NSNumber numberWithInteger:indexUserName], elementKeyUserName,
			[NSNumber numberWithInteger:indexCommunity], elementKeyCommunity,
			[NSNumber numberWithInteger:indexAddress], elementKeyAddress,
			[NSNumber numberWithInteger:indexPort], elementKeyPort,
			[NSNumber numberWithInteger:indexThread], elementKeyThread,
			[NSNumber numberWithInteger:indexTicket], elementKeyTicket, nil];
	
					
}// end - (void) parserDidStartDocument:(NSXMLParser *)parser

- (void) parserDidEndDocument:(NSXMLParser *)parser
{
	elementsDict = nil;
}// end - (void) parserDidEndDocument:(NSXMLParser *)parser

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	stringBuffer = [[NSMutableString alloc] init];
}// end - (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	NSInteger index = [[elementsDict valueForKey:elementName] integerValue];
	switch (index) {
		case indexUserID:
			userID = [[NSString alloc] initWithString:stringBuffer];
			break;
		case indexUserName:
			nickname = [[NSString alloc] initWithString:stringBuffer];
			break;
		case indexCommunity:
			[joined addObject:[NSString stringWithString:stringBuffer]];
			break;
		case indexAddress:
			server = [[NSString alloc] initWithString:stringBuffer];
			break;
		case indexPort:
			port = [stringBuffer integerValue];
			break;
		case indexThread:
			thread = [[NSString alloc] initWithString:stringBuffer];
			break;
		case indexTicket:
			ticket = [[NSString alloc] initWithString:stringBuffer];
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
