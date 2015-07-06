//
//  NLProgramSiever.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/6/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCStreamSessionGCD.h"
#import "NLAccounts.h"

@interface NLProgramSiever : NSObject <YCStreamSessionGCDDelegate> {
	YCStreamSessionGCD				*session;
	NLAccounts						*accounts;
}

@end
