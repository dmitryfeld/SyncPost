//
//  DFSPAuthorization.h
//  SyncPost
//
//  Created by Dmitry Feld on 5/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPModel.h"

@class DFSPMutableAuthorization;
@interface DFSPAuthorization : NSObject<DFSPModel>
@property (readonly,nonatomic) NSString* userID;
@property (readonly,nonatomic) NSString* authorizationToken;
@property (readonly,nonatomic) NSTimeInterval timeToLive;
@property (readonly,nonatomic) NSDate* received;
- (instancetype) initWithTemplate:(DFSPAuthorization*)model;
- (DFSPMutableAuthorization*) mutableCopy;
@end

@interface DFSPMutableAuthorization : DFSPAuthorization<DFSPMutableModel>
@property (strong,nonatomic,setter=setUserID:) NSString* userID;
@property (strong,nonatomic,setter=setAuthorizationToken:) NSString* authorizationToken;
@property (nonatomic,setter=setTimeToLive:) NSTimeInterval timeToLive;
@property (nonatomic,setter=setReceived:) NSDate* received;
- (void) setUserID:(NSString*)userID;
- (void) setAuthorizationToken:(NSString*)authorizationToken;
- (void) setTimeToLive:(NSTimeInterval)timeToLive;
- (void) setReceived:(NSDate *)received;
- (DFSPAuthorization*) immutableCopy;
@end

@interface DFSPAuthorizationKVP : DFSPMutableAuthorization<DFSPModelKVP>
- (void) setValue:(id)value forUndefinedKey:(NSString *)key;
- (void) setValue:(id)value forKey:(NSString *)key;
+ (DFSPAuthorization*) fromDictionary:(NSDictionary*)dictionary;
@end
