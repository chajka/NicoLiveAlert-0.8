//
//  NicoLiveAlert.m
//  NicoLiveAlert
//
//  Created by Чайка on 7/6/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import "NicoLiveAlert.h"
#import "NicoLiveAlertDefinitions.h"
#import "NicoLiveAlertCollaboration.h"
#import "NicoLiveAlertCollaboratorProtocol.h"
#import "NLProgram.h"

@interface NicoLiveAlert ()

@property (weak) IBOutlet NSWindow *window;
- (void) setAccountsMenu;

#ifdef __cplusplus
extern "C" {
#endif
static void uncaughtExceptionHandler(NSException *exception);
#ifdef __cplusplus
} //end extern "C"
#endif
@end

@implementation NicoLiveAlert
#pragma mark - synthesize properties
#pragma mark - class method
#pragma mark - constructor / destructor
#pragma mark - override
- (void) awakeFromNib
{
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
	statusbar = [[NLStatusbar alloc] initWithMenu:menuStatusbar andImageName:@"sbicon"];
}// end - (void) awakeFromNib

- (void) applicationWillFinishLaunching:(NSNotification *)notification
{
	[GrowlApplicationBridge registrationDictionaryFromBundle:nil];
	[GrowlApplicationBridge setGrowlDelegate:self];

	allUsers = [[NLAccounts alloc] init];
	[self setAccountsMenu];
	siever = [[NLProgramSiever alloc] initWithAccounts:allUsers statusbar:statusbar];

	collaborator = [[NSXPCConnection alloc] initWithServiceName:@"tv.from.chajka.NicoLiveAlertCollaborator"];
	collaborator.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(NicoLiveAlertCollaboratorProtocol)];
	[collaborator resume];
}// end - (void) applicationWillFinishLaunching:(NSNotification *)notification

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
	programLister = [[NLProgramList alloc] initWithAccounts:allUsers siever:siever statusbar:statusbar];
}// end - (void) applicationDidFinishLaunching:(NSNotification *)aNotification

- (void) applicationWillTerminate:(NSNotification *)aNotification
{
	// Insert code here to tear down your application
}// end - (void) applicationDidFinishLaunching:(NSNotification *)aNotification

#pragma mark - delegate
#pragma mark - properties
#pragma mark - actions
- (IBAction) toggleUserState:(id)sender
{
	
}// end - (IBAction) toggleUserState:(id)sender

- (IBAction) openProgram:(id)sender
{		// open in browser
	NLProgram *item = [sender representedObject];
	NSURL *live = [NSURL URLWithString:[NicoProgramURLFormat stringByAppendingString:item.programNumber]];
	[[NSWorkspace sharedWorkspace] openURL:live];

		// open in comment viewer
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	if ([ud boolForKey:PrefKeyKickCommentViewerByOpenFromMe]) {
		NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
		NSString *url = [live absoluteString];
		[userInfo setValue:url forKey:ProgramURL];
		[userInfo setValue:item.programNumber forKey:LiveNumber];
		[userInfo setValue:[NSNumber numberWithBool:YES] forKey:CommentViewer];
		[userInfo setValue:[NSNumber numberWithBool:NO] forKey:BroadcastStreamer];
		[userInfo setValue:[NSNumber numberWithInteger:broadcastKindUser] forKey:BroadCastKind];
		[[collaborator remoteObjectProxy] notifyStartBroadcast:userInfo];
	}// end if
}// end - (IBAction) openProgram:(id)sender

#pragma mark - messages
#pragma mark - private
- (void) setAccountsMenu
{
	NSImage *onState = [NSImage imageNamed:@"NLOnState"];
	NSImage *offState = [NSImage imageNamed:@"NLOffState"];
	NSMenu *usersMenu = [[menuStatusbar itemWithTag:tagAccounts] submenu];

	NSDictionary *users = [allUsers users];
	for (NSString *nickname in [users allKeys]) {
		NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:nickname action:@selector(toggleUserState:) keyEquivalent:EmptyString];
		[item setOnStateImage:onState];
		[item setOffStateImage:offState];
		NLAccount *account = [users valueForKey:nickname];
		[item setState:((account.watchEnable == YES) ? NSOnState : NSOffState)];
		[usersMenu addItem:item];
	}// end foreach
	[statusbar updateUserState];
}// end - (void) setAccountsMenu

#pragma mark - C functions
static
void uncaughtExceptionHandler(NSException *exception)
{
	NSLog(@"%@", exception.name);
	NSLog(@"%@", exception.reason);
	NSLog(@"%@", exception.callStackSymbols);
}// end void uncaughtExceptionHandler(NSException *exception)

@end
