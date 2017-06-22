//
//  DFSPApplicationData.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/15/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPCredentials.h"
#import "DFSPAuthorization.h"

@interface DFSPApplicationData : NSObject
@property (strong,nonatomic) DFSPCredentials* credentials;
@property (strong,nonatomic) DFSPAuthorization* authorization;
@property (strong,nonatomic) NSString* apnsPushToken;
@property (strong,nonatomic) NSString* voipPushToken;
- (instancetype) init NS_DESIGNATED_INITIALIZER;
@end

DFSPApplicationData* DFSPApplicationDataGet();
