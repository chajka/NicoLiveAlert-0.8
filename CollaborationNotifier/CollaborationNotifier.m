//
//  CollaborationNotifier.m
//  CollaborationNotifier
//
//  Created by Чайка on 7/15/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import "CollaborationNotifier.h"

@implementation CollaborationNotifier

// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
- (void)upperCaseString:(NSString *)aString withReply:(void (^)(NSString *))reply {
    NSString *response = [aString uppercaseString];
    reply(response);
}

@end
