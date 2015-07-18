//
//  NicoLiveAlertDefinitions.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/6/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#ifndef NicoLiveAlert_NicoLiveAlertDefinitions_h
#define NicoLiveAlert_NicoLiveAlertDefinitions_h

#define EmptyString									@""

#pragma mark - URLs
#define NicoLoginForm								@"https://secure.nicovideo.jp/secure/login_form"
#define NicoLoginGetTicketURL						@"https://secure.nicovideo.jp/secure/login"
#define NicoLiveGetAlertStatusURL					@"http://live.nicovideo.jp/api/getalertstatus"
#define NicoStreamInfoQuery							@"http://live.nicovideo.jp/api/getstreaminfo/"
#define NicoStreamEmbedQuery						@"http://live.nicovideo.jp/embed/"
#define NicoPlayerStatusQuery						@"http://live.nicovideo.jp/api/getplayerstatus?v="
#define NicoProgramURLFormat						@"http://live.nicovideo.jp/watch/"
#define NicknameQuery								@"http://seiga.nicovideo.jp/api/user/info?id="

#define StartStreamRequestElement					@"<thread thread=\"%@\" version=\"20061206\" res_from=\"-1\"/>"

#pragma mark - Regular expressions
#define ProgramListRegex							@"<chat .*>(.+)</chat>"
#define CommunityTitleRegex							@"<name>(.*)</name>"
#define NicknamePickupRegex							@"<nickname>(.*)</nickname>"

#pragma mark - account info xml element keys
// Exception definition
#define RESULTERRORNAME								@"XML parse error"
#define RESULTERRORREASON							@"XML result is not ok"

// XML element literal
#define elementKeyResponse							@"nicovideo_user_response"
#define elementKeyTicket							@"ticket"
#define elementKeyStatus							@"getalertstatus"
#define elementKeyUserID							@"user_id"
#define elementKeyHash								@"user_hash"
#define elementKeyUserName							@"user_name"
#define elementKeyCommunity							@"community_id"
#define elementKeyAddress							@"addr"
#define elementKeyPort								@"port"
#define elementKeyThread							@"thread"
#define elementKeyError								@"error"
#define elementKeyCode								@"code"
#define elementKeyDesc								@"description"

enum elementLiteralIndex {
	indexResponse = 1,
	indexTicket,
	indexStatus,
	indexUserID,
	indexHash,
	indexUserName,
	indexCommunity,
	indexAddress,
	indexPort,
	indexThread,
	indexError,
	indexCode,
	indexDesc
};

#pragma mark -
#pragma mark definitions for class NLProgram
// Attribute literal
#define fontNameOfProgramTitle		@"HiraKakuPro-W6"
#define fontNameOfProgramOwner		@"HiraKakuPro-W3"
#define fontNameOfDescription		@"HiraMaruPro-W4"
#define fontNameOfCommunity			@"HiraKakuPro-W6"
#define fontNameOfPrimaryAccount	@"Futura-Medium"
#define fontNameOfElapsedTime		@"CourierNewPS-BoldMT"

#define ProgramFromRSSOwnerName		@"RSS"
#define OfficialTitleString	NSLocalizedString(@"OfficialTitleString", @"")
#define StartUserTimeFormat			@" %H:%M + 00:00"
#define ReserveUserTimeFormat		@" %%H:%%M - 00:%02ld"
#define StartOfficialTimeFormat		@"  %H:%M + 00:00"
#define ReserveOfficialTimeFormat	@"  %%H:%%M - 00:%02ld"
#define ElapsedTimeFormat			@"%02ld:%02ld"
#define CountDownTimeFormat			@"%02ld:%02ld"
#define TimeFormatString			@"%H:%M"
#define TimeSanityFormatString		@"%@%@%@"

#pragma mark - NLOfficialProgram
#define ProgramTtileRegex							@"<h1 class=\"title\">(.*)</h1>"
#define ProgramThumbnailRegex						@"<img src=\"(http://(icon\\.n|nl\\.s)img.jp/.*)\" alt=\"\">"
#define ProgramStatusRegex							@"<div class=\"status (before|beforeTS|onair|done|doneTS)\">"
#define ProgramStartTimeRegex						@"<div class=\"data\">(.*)</div>"
#define DateSanityRegex								@"</?font[^>]*>"

#define ONAIRSTATE									@"onair"
#define BEFORESTATE									@"before"
#define BEFORETSSTATE								@"beforeTS"
#define DONESTATE									@"done"
#define DONETSSTATE									@"doneTS"

#pragma mark - getstreaminfo xml keys
#define elementKeyRequestID							@"request_id"
#define elementKeyProgramTitle						@"title"
#define elementKeyProgramDescription				@"description"
#define elementKeyDefaultCommunity					@"default_community"
#define elementKeyCommunityName						@"name"
#define elementKeyCommunityThumbnail				@"thumbnail"
enum getstreamInfoIndex {
	IndexRequestID = 1,
	IndexProgramTitle,
	IndexProgramDesc,
	IndexDefaultCommunity,
	IndexCommunityName,
	IndexCommunityThumbnail
};

#pragma mark -
#pragma mark Application Collaboration
#pragma mark classic
#define ServerCharleston			@"Charleston"
#define ServerFMELauncher			@"FMELauncher"
#pragma mark XPC
#define CollaboratorXPCName			"tv.from.chajka.NicoLiveAlert.Collaborator"
#define XPCNotificationName			@"XPCNotificationName"
#define TypeProgramStart			@"TypeProgramStart"
#define TypeProgramEnd				@"TypeProgramEnd"
#define Information					@"Information"
#define ImporterXPCName				"tv.from.chajka.NicoLiveAlert.Importer"
#define ImporterQueueName			"tv.from.cjajka.NicoLiveAlert.Importer.queue"
#define TypePreference				@"TypePreference"
#define PrefSource					@"source"
#define PrefDest					@"dest"
#define PreferenceData				@"PreferenceData"

#pragma mark - definitions for Statusbar
#define DeactiveConnection							@"Disconnected"
#define ActiveNoprogString							@"Monitoring"
#define userProgramOnly								@"%ld User program"
#define officialProgramOnly							@"%ld Official program"
#define TwoOrMoreSuffix								@"s"
#define StringConcatinater							@", "

enum statusBarMenuItems {
	tagAutoOpen = 1001,
	tagPorgrams,
	tagOfficial,
	tagSep1 = 1010,
	tagAccounts,
	tagResetConnection,
	tagRescanRSS,
	tagLaunchApplications,
	tagSep2 = 1020,
	tagPreference,
	tagCheckUpdate,
	tagQuit
};

#define OnImageName									@"NLOnState"
#define OffImageName								@"NLOffState"
#define MixedImageName								@"NLMixedState"

// Status Bar menu's localized string definition
#define TITLEAUTOOPEN								NSLocalizedString(@"TitleAutoOpen", @"")
#define	TITLEPROGRAMS								NSLocalizedString(@"TitlePrograms", @"")

#define	TITLEACCOUNTS								NSLocalizedString(@"TitleAccounts", @"")
#define TITLERESETCONNECTION						NSLocalizedString(@"TitleResetConnection", @"")
#define TITLESCANRSS								NSLocalizedString(@"TitleScanRSS", @"")
#define	TITLELAUNCHER								NSLocalizedString(@"TitleLauncher", @"")
#define	TITLEPREFERENCE								NSLocalizedString(@"TitlePreference", @"")
#define TITLECHECKUPDATE							NSLocalizedString(@"TitleCheckUpdate", @"")

#define TITLEABOUT									NSLocalizedString(@"TitleAbout", @"")
#define	TITLEQUIT									NSLocalizedString(@"TitleQuit", @"")
// Status Bar menu's alternative strings definition
#define TITLEUSERNOPROG								NSLocalizedString(@"TitleUserNoProgram", @"")
#define TITLEUSERSINGLEPROG							NSLocalizedString(@"TitleUserSingleProgram", @"")
#define TITLEUSERSOMEPROG							NSLocalizedString(@"TitleUserSomePrograms", @"")
#define TITLEOFFICIALNOPROG							NSLocalizedString(@"TitleOfficialNoProgram", @"")
#define TITLEOFFICIALSINGLEPROG						NSLocalizedString(@"TitleOfficialSingleProgram", @"")
#define TITLEOFFICIALSOMEPROG						NSLocalizedString(@"TitleOfficialSomePrograms", @"")

// regular expression definition
#define WatchKindRegex								@"^((co|ch|lv)\\d+)"

//
#define rangePrefix									NSMakeRange(0, 2)
#define kindCommunity								@"co"
#define kindChannel									@"ch"
#define kindOfficial								@"of"
#define kindProgram									@"lv"
#define kindOfficalProgram							@"official"
enum programInfoKind {
	OffsetLiveNumber = 0,
	OffsetOfficialTitle = 1,
	OffsetCommunityChannelNumber = 1,
	OffsetProgramOwnerID = 2
};

enum WatchTargetKind {
	indexWatchCommunity = 1,
	indexWatchChannel,
	indexWatchProgram
};
// url format definition
#define URLFormatCommunity							@"http://com.nicovideo.jp/community/%@"
#define URLFormatChannel							@"http://ch.nicovideo.jp/channel/%@"
#define URLFormatLive								@"http://live.nicovideo.jp/watch/%@"
#define URLFormatUser								@"http://www.nicovideo.jp/user/%@"

#pragma mark - Preference keys
#define PrefKeyNotifyStartUserProgram				@"NotifyStartUserProgram"
#define PrefKeyNotifyStartOfficialProgram			@"NotifyStartOfficialProgram"
#define PrefKeyCheckOfficialChannel					@"CheckOfficialChannel"
#define PrefKeyAutoOpenCheckedLive					@"AutoOpenCheckedLive"
#define PrefKeyKickCommentViewerByOpenFromMe		@"KickCommentViewerByOpenFromMe"
#define PrefKeyKickCommentViewerAtAutoOpen			@"KickCommentViewerAtAutoOpen"
#define PrefKeyKickCommentViewerOnMyBroadcast		@"KickCommentViewerOnMyBroadcast"
#define PrefKeyKickStreamerOnMyBroadcast			@"KickStreamerOnMyBroadcast"
#define PrefKeyNotifySoundDeviceName				@"NotifySoundDeviceName"
#define PrefKeyStartUserProgramSound				@"StartUserProgramSound"
#define PrefKeyStartOfficialProgramSound			@"StartOfficialProgramSound"


#pragma mark -
#pragma mark Growling

#define GrowlNotifyStartMonitoring					@"Start monitoring"
#define GrowlNotifyDisconnected						@"Disconnected"
#define GrowlNotifyFoundOfficialProgram				@"Found Official Program"
#define GrowlNotifyStartOfficialProgram				@"Start Official Program"
#define GrowlNotifyFoundUserProgram					@"Found User Program"
#define GrowlNotifyStartUserProgram					@"Start User Program"
#define	GrowlNotifyFoundListedProgram				@"Found in Manual Watch List"
#define GrowlNotifyStartListedProgram				@"Start in Manual watch List"

#pragma mark -
#pragma mark definitions for NLStatusbar

#pragma mark - users default constant
#define UsersDefaultResourceType					@"plist"
#define UsersDefaultFileName						@"UsersDefaults"

#pragma mark - saved preference keys
#define SavedAccountListKey							@"AccountsList"
#define AccountValueUserID							@"UserID"
#define AccountValueNickname						@"Nickname"
#define AccountValueMailAddress						@"MailAddress"
#define AccountValueWatchEnabled					@"WatchEnabled"

#define SavedWatchListKey							@"WatchListTable"
#define WatchListValueWatchItem						@"WatchItem"
#define WatchListValueNote							@"Note"
#define WatchListValueAutoOpen						@"AutoOpen"

#endif
