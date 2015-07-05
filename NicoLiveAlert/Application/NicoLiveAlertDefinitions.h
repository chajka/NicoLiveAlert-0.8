//
//  NicoLiveAlertDefinitions.h
//  NicoLiveAlert
//
//  Created by Чайка on 7/6/15.
//  Copyright (c) 2015 Instrumentality of Mankind. All rights reserved.
//

#ifndef NicoLiveAlert_NicoLiveAlertDefinitions_h
#define NicoLiveAlert_NicoLiveAlertDefinitions_h

#pragma mark - URLs
#define NicoLoginFormFQDN							@"https://secure.nicovideo.jp/secure/login_form"
#define NicoLoginGetTicketURL						@"https://secure.nicovideo.jp/secure/login"
#define NicoLiveGetAlertStatusURL					@"http://live.nicovideo.jp/api/getalertstatus"


#define StartStreamRequestElement					@"<thread thread=\"%@\" version=\"20061206\" res_from=\"-1\"/>\0"

#pragma mark - account info xml element keys
// Exception definition
#define RESULTERRORNAME		@"XML parse error"
#define RESULTERRORREASON	@"XML result is not ok"

// XML element literal
#define elementKeyResponse	@"nicovideo_user_response"
#define elementKeyTicket	@"ticket"
#define elementKeyStatus	@"getalertstatus"
#define elementKeyUserID	@"user_id"
#define elementKeyHash		@"user_hash"
#define elementKeyUserName	@"user_name"
#define elementKeyCommunity	@"community_id"
#define elementKeyAddress	@"addr"
#define elementKeyPort		@"port"
#define elementKeyThread	@"thread"
#define elementKeyError		@"error"
#define elementKeyCode		@"code"
#define elementKeyDesc		@"description"

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

#endif
