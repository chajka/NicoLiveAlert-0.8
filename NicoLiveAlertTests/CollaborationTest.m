//
//  CollaborationTest.m
//  NicoLiveAlert
//
//  Created by Чайка on 7/17/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "NicoLiveAlertCollaboratorProtocol.h"
#import "NicoLiveAlertCollaboration.h"

@interface CollaborationTest : XCTestCase {
	NSXPCConnection *connection;
}

@end

@implementation CollaborationTest

- (void)setUp {
    [super setUp];

    connection = [[NSXPCConnection alloc] initWithServiceName:@"tv.from.chajka.NicoLiveAlertCollaborator"];
	connection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(NicoLiveAlertCollaboratorProtocol)];
	[connection resume];
}

- (void)tearDown {
	[connection invalidate];
    [super tearDown];
}

- (void)testExample {
	[[connection remoteObjectProxy] upperCaseString:@"this is a test" withReply:^(NSString *string) {
		NSLog(@"%@", string);
	}];
    XCTAssert(YES, @"Pass");
}

- (void) test01_programStartNotification
{
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
	NSString *url = @"http://live.nicovideo.jp/watch/lv228352134";
	[userInfo setValue:url forKey:ProgramURL];
	[userInfo setValue:@"lv228352134" forKey:LiveNumber];
	[userInfo setValue:[NSNumber numberWithBool:YES] forKey:CommentViewer];
	[userInfo setValue:[NSNumber numberWithBool:NO] forKey:BroadcastStreamer];
	[userInfo setValue:[NSNumber numberWithInteger:broadcastKindUser] forKey:BroadCastKind];

	[[connection remoteObjectProxy] notifyStartBroadcast:userInfo];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
