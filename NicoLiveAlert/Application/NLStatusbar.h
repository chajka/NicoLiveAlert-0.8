//
//  NLStatusbar.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/7/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface NLStatusbar : NSObject {
	__strong	NSStatusItem	*statusBarItem;
	__strong	NSStatusBar		*statusBar;
	NSMenu						*statusbarMenu;
	BOOL						connected;
	BOOL						watchOfficial;
	NSCellStateValue			userState;
	NSInteger					numberOfPrograms;
	NSSize						iconSize;
	CIImage						*sourceImage;
	NSImage						*statusbarIcon;
	NSImage						*statusbarAlt;
	CIFilter					*gammaFilter;
	NSNumber					*gammaPower;
	CIVector					*noProgVect;
	CIVector					*haveProgVect;
	CIFilter					*invertFilter;
	NSPoint						drawPoint;
	NSFont						*progCountFont;
	NSDictionary				*fontAttrDict;
	NSDictionary				*fontAttrInvertDict;
	NSBezierPath				*progCountBackground;
	NSBezierPath				*disconnectPath;
	NSColor						*progCountBackColor;
	NSColor						*disconnectColor;
	NSInteger					userProgramCount;
	NSInteger					officialProgramCount;

}
@property (readwrite)	NSCellStateValue	userState;
@property (readonly)	NSInteger			numberOfPrograms;
@property (readwrite)	BOOL				connected;
@property (readwrite)	BOOL				watchOfficial;


- (id) initWithMenu:(NSMenu *)menu andImageName:(NSString *)imageName;

- (void) updateUserState;

- (void) addToUserMenu:(NSMenuItem *)item;
- (void) removeFromUserMenu:(NSMenuItem *)item;
- (void) addToOfficialMenu:(NSMenuItem *)item;
- (void) removeFromOfficialMenu:(NSMenuItem *)item;
- (void) incleaseProgCount;
- (void) decleaseProgCount;
- (void) toggleConnected;
@end
