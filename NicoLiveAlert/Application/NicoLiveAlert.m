//
//  NicoLiveAlert.m
//  NicoLiveAlert
//
//  Created by Чайка on 7/6/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import "NicoLiveAlert.h"
#import "NicoLiveAlertDefinitions.h"
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
}// end - (void) applicationWillFinishLaunching:(NSNotification *)notification

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
	programLister = [[NLProgramList alloc] initWithAccounts:allUsers siever:siever statusbar:statusbar];
		// hook timer test
	NSDate *now = [NSDate date];
	NSDate *fireDate = [now dateByAddingTimeInterval:60];
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
{
	NLProgram *item = [sender representedObject];
	NSURL *live = [NSURL URLWithString:[NicoProgramURLFormat stringByAppendingString:item.programNumber]];
	[[NSWorkspace sharedWorkspace] openURL:live];
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
