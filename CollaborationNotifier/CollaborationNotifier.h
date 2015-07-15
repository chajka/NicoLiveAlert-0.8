//
//  CollaborationNotifier.h
//  CollaborationNotifier
//
//  Created by Чайка on 7/15/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollaborationNotifierProtocol.h"

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface CollaborationNotifier : NSObject <CollaborationNotifierProtocol>
@end
