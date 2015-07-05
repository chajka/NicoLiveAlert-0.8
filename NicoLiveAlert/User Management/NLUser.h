//
//  NLUser.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/6/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YCKeychainService/YCKeychainService.h>
#import "HTTPConnection.h"

@interface NLUser : NSObject <NSXMLParserDelegate> {
	YCHTTPSKeychainItem				*account;

	NSString						*userID;
	NSString						*nickname;
	BOOL							watchEnable;

	NSMutableArray					*joined;

	NSString						*server;
	NSInteger						port;
	NSString						*thread;
	NSString						*ticket;

	NSDictionary					*elementsDict;
	NSMutableString					*stringBuffer;
	HTTPConnection					*connection;
}
@property (readonly) NSString		*mailaddress;
@property (readonly) NSString		*password;
@property (readonly) NSString		*userID;
@property (readonly) NSString		*nickname;
@property (readwrite) BOOL			watchEnable;
@property (readonly) NSArray		*joined;
@property (readonly) NSString		*server;
@property (readonly) NSInteger		port;
@property (readonly) NSString		*thread;
@property (readonly) NSString		*ticket;

- (id) initWithAccount:(NSString *)account;
- (id) initWithAccount:(NSString *)account password:(NSString *)password;
@end
