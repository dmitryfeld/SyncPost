//
//  DFSPApplicationContext.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/22/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPCredentials.h"
#import "DFSPAuthorization.h"

@interface DFSPApplicationContext : NSObject
@property (readonly,nonatomic,strong) DFSPCredentials* credentials;
@property (readonly,nonatomic,strong) DFSPAuthorization* authorization;
@property (readonly,nonatomic,strong) NSString* appVersion;
@property (readonly,nonatomic,strong) NSString* appName;
@property (readonly,nonatomic,strong) NSString* deviceType;
@property (readonly,nonatomic,strong) NSString* osVersion;
@property (readonly,nonatomic,strong) NSString* apnsPushToken;
@property (readonly,nonatomic,strong) NSString* voipPushToken;
- (instancetype) init NS_DESIGNATED_INITIALIZER;
@end
