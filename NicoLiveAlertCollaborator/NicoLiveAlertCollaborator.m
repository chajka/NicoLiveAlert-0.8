//
//  NicoLiveAlertCollaborator.m
//  NicoLiveAlertCollaborator
//
//  Created by Чайка on 7/17/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import "NicoLiveAlertCollaborator.h"
#import "NicoLiveAlertCollaboration.h"

@implementation NicoLiveAlertCollaborator

- (void) notifyStartBroadcast:(NSDictionary *)userInfo
{
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:NLABroadcastStartNotification object:NLAApplicationName userInfo:userInfo];
}// end - (void) notifyStartBroadcast:(NSDictionary *)userInfo

- (void) notifyEndBroadcast:(NSDictionary *)userInfo
{
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:NLABroadcastEndNotification object:NLAApplicationName userInfo:userInfo];
}// end - (void) notifyEndBroadcast:(NSDictionary *)userInfo
// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
- (void) upperCaseString:(NSString *)aString withReply:(void (^)(NSString *))reply {
    NSString *response = [aString uppercaseString];
    reply(response);
}

@end
