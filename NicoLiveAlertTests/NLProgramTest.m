//
//  NLProgramTest.m
//  NicoLiveAlert
//
//  Created by Чайка on 7/16/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

@interface NLProgramTest : XCTestCase

@end

@implementation NLProgramTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
	NSDate *openDate = [NSDate dateWithNaturalLanguageString:@"7月16日(木) 00:50" locale:nil];
	NSDate *startDate = [NSDate dateWithNaturalLanguageString:@"7月16日(木) 01:00" locale:nil];
	NSComparisonResult order = [startDate compare:openDate];
	NSLog(@"%@", [startDate descriptionWithLocale:[NSLocale currentLocale]]);
 
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
