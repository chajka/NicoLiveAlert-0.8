//
//  NLProgramSiever.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/7/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLProgramSiever : NSObject {
	NSDictionary						*watchlist;
}
- (id) initWithWatchlist:(NSDictionary *)watchlist;
@end
