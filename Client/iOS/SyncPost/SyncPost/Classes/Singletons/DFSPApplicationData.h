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
@property (strong,nonatomic,readonly)DFSPCredentials* credentials;
@property (strong,nonatomic,readonly)DFSPAuthorization* authorization;
- (instancetype) init NS_DESIGNATED_INITIALIZER;
- (void) authentifyWithCredentials:(DFSPCredentials*)credentials;
- (void) authorizeWithAuthorization:(DFSPAuthorization*)authorization;
@end

DFSPApplicationData* DFSPApplicationDataGet();
