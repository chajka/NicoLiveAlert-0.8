//
//  AccountController.m
//  NicoLiveAlert
//
//  Created by Чайка on 7/20/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#import "AccountController.h"
#import <YCKeychainService/YCKeychainService.h>
#import "NicoLiveAlertDefinitions.h"
#import "NicoLiveAlertPreferenceDefinitions.h"

@interface AccountController ()

@end

@implementation AccountController
#pragma mark - synthesize properties
#pragma mark - class method
#pragma mark - constructor / destructor
- (id) initWithAccounts:(NLAccounts *)accounts
{
	self = [super initWithNibName:@"AccountController" bundle:nil];
	if (self) {
		allAccounts = accounts;
	}// end if self

	return self;
}// end - (id) initWithAccounts:(NLAccounts *)accounts

#pragma mark - override
- (void) viewDidLoad
{
    [super viewDidLoad];

	[comboMaladdresses removeAllItems];
	
	for (NLAccount *user in allAccounts.accounts) {
		NSMutableDictionary *entry = [NSMutableDictionary dictionary];
		[entry setValue:[NSNumber numberWithBool:user.watchEnable] forKey:AccountValueWatchEnabled];
		[entry setValue:user.userID forKey:AccountValueUserID];
		[entry setValue:user.nickname forKey:AccountValueNickname];
		[entry setValue:user.mailaddress forKey:AccountValueMailAddress];
		
		[aryctrlAccounts addObject:entry];
		[comboMaladdresses addItemWithObjectValue:user.mailaddress];
	}// end foreach

	[tableviewAccounts deselectAll:self];
}// end - (void) viewDidLoad

- (void) controlTextDidEndEditing:(NSNotification *)obj
{
	NSString *mailaddress = comboMaladdresses.stringValue;
	for (NLAccount *user in allAccounts.accounts) {
		if ([user.mailaddress isEqualToString:mailaddress])
			txtfldPassword.stringValue = user.password;
	}// end foreach
	
	if ([[txtfldPassword stringValue] isEqualToString:EmptyString]) {
		YCHTTPSKeychainItem *user = [YCHTTPSKeychainItem userInKeychain:mailaddress forURL:[NSURL URLWithString:NicoLoginForm]];
		if (user != nil) {
			txtfldPassword.stringValue = user.password;
			buttonAddAccount.enabled = NO;
			buttonDeleteAccount.enabled = YES;
		}// end if already threre
	}// end if
	
	if (![mailaddress isEqualToString:EmptyString])
		[txtfldPassword setEnabled:YES];
	else
		[txtfldPassword setEnabled:NO];
	
	if (![[txtfldPassword stringValue] isEqualToString:EmptyString])
		[buttonAddAccount setEnabled:YES];
	else
		[buttonAddAccount setEnabled:NO];
	
	if ((![[comboMaladdresses stringValue] isEqualToString:EmptyString]) && (![[txtfldPassword stringValue] isEqualToString:EmptyString]))
		[buttonAddAccount setEnabled:YES];
	else
		[buttonAddAccount setEnabled:NO];
}// end - (void) controlTextDidEndEditing:(NSNotification *)obj

#pragma mark - delegate
- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
	if ([aryctrlAccounts.arrangedObjects count] > rowIndex) {
		NSDictionary *entry = [aryctrlAccounts.arrangedObjects objectAtIndex:rowIndex];
		NSString *mailaddress = [entry valueForKey:AccountValueMailAddress];
		[comboMaladdresses selectItemWithObjectValue:mailaddress];
		buttonDeleteAccount.enabled = YES;
	} else {
		buttonDeleteAccount.enabled = NO;
	}

	return YES;
}// end - (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex

#pragma mark - properties
- (NSString *) identifier { return AccountsIdentifierName; }

- (NSImage *) toolbarItemImage { return [NSImage imageNamed:AccountsToolbarImageName]; }

- (NSString *) toolbarItemLabel { return AccountsToolbarLabel; }

#pragma mark - actions
- (IBAction) addAccount:(id)sender
{
	buttonAddAccount.enabled = NO;
	NSString *account = [comboMaladdresses stringValue];
	NSString *password = [txtfldPassword stringValue];
	NLAccount *user = [allAccounts addAccount:account];
	if (user)
		user = [allAccounts addAccount:account password:password];
	
	if (!user)
		return;
	
	NSMutableDictionary *entry = [NSMutableDictionary dictionary];
	[entry setValue:[NSNumber numberWithBool:YES] forKey:AccountValueWatchEnabled];
	[entry setValue:user.userID forKey:AccountValueUserID];
	[entry setValue:user.nickname forKey:AccountValueNickname];
	[entry setValue:user.mailaddress forKey:AccountValueMailAddress];
	[aryctrlAccounts addObject:entry];
	[tableviewAccounts deselectAll:self];
	
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	NSMutableArray *accounts = [NSMutableArray arrayWithArray:[ud arrayForKey:SavedAccountListKey]];
	[accounts addObject:entry];
	[ud setValue:accounts forKey:SavedAccountListKey];
}// end - (IBAction) addAccount:(id)sender

- (IBAction) deleteAccount:(id)sender
{
	NSInteger row = tableviewAccounts.selectedRow;
	NSDictionary *user = [aryctrlAccounts.arrangedObjects objectAtIndex:row];

	[aryctrlAccounts removeObject:user];
	NSString *mailaddress = [user valueForKey:AccountValueMailAddress];
	[allAccounts removeAccount:mailaddress];
	[comboMaladdresses removeItemWithObjectValue:mailaddress];
	comboMaladdresses.stringValue = EmptyString;
	txtfldPassword.stringValue = EmptyString;
	buttonAddAccount.enabled = NO;
	buttonDeleteAccount.enabled = NO;

	NSArray *accounts = [aryctrlAccounts arrangedObjects];
	[[NSUserDefaults standardUserDefaults] setObject:accounts forKey:SavedAccountListKey];
	[tableviewAccounts deselectAll:self];
}// end - (IBAction) deleteAccount:(id)sender
#pragma mark - messages
#pragma mark - private
#pragma mark - C functions

@end
