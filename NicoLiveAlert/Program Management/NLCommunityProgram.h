//
//  NLCommunityProgram.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/10/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import "NLOfficialProgram.h"

@interface NLCommunityProgram : NLOfficialProgram <NSXMLParserDelegate>{
	NSString								*description;
	
	NSDictionary							*elementsDict;
	NSMutableString							*stringBuffer;
}
- (id) initWithLiveNumber:(NSString *)liveno owner:(NSString *)owner;
@end
