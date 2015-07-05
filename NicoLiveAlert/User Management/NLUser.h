//
//  NLUser.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/6/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YCKeychainService/YCKeychainService.h>

@interface NLUser : NSObject <NSXMLParserDelegate> {
	YCHTTPSKeychainItem				*account;

	NSString						*nickname;
	BOOL							*watchEnable;

	NSArray							*joined;

	NSString						*server;
	NSInteger						port;
	NSString						*thread;
	NSString						*ticket;
}

@end
