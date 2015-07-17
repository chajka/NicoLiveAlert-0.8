//
//  NicoLiveAlertCollaborator.h
//  NicoLiveAlertCollaborator
//
//  Created by Чайка on 7/17/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NicoLiveAlertCollaboratorProtocol.h"

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface NicoLiveAlertCollaborator : NSObject <NicoLiveAlertCollaboratorProtocol>
- (void) notifyStartBroadcast:(NSDictionary *)userInfo;
- (void) notifyEndBroadcast:(NSDictionary *)userInfo;
@end
