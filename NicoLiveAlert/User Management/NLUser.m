//
//  NLUser.m
//  NicoLiveAlert
//
//  Created by Чайка on 7/6/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import "NLUser.h"

@implementation NLUser
#pragma mark - synthesize properties
@synthesize watchEnable;
@synthesize joined;
@synthesize server;
@synthesize port;
@synthesize thread;
@synthesize ticket;

#pragma mark - class method
#pragma mark - constructor / destructor
#pragma mark - override
#pragma mark - delegate
#pragma mark - properties
- (NSString *) mailaddress { return account.account; }
- (NSString *) password	{ return account.password; }
#pragma mark - actions
#pragma mark - messages
#pragma mark - private
#pragma mark - C functions

@end
