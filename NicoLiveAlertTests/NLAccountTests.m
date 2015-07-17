//
//  NLAccountTests.m
//  NicoLiveAlert
//
//  Created by Чайка on 7/6/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "NLAccount.h"

@interface NLAccountTests : XCTestCase

@end

@implementation NLAccountTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) test01_Allocation {
	NLAccount *user = [[NLAccount alloc] initWithAccount:@"chajka.niconico@gmail.com"];
	XCTAssertNotNil(user, @"Test01 allocation fail\"%s\"", __PRETTY_FUNCTION__);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
