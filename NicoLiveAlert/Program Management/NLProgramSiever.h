//
//  NLProgramSiever.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/7/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLStatusbar.h"

@interface NLProgramSiever : NSObject {
	NSDictionary						*watchlist;
	NLStatusbar							*statusbar;
}
- (id) initWithWatchlist:(NSDictionary *)watchlist statusbar:(NLStatusbar *)statusbar;

- (void) checkProgram:(NSArray *)programInfo;
@end
