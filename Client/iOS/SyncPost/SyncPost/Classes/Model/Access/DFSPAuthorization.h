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
@property (readonly,nonatomic) NSString* authorizationId;
@property (readonly,nonatomic) NSString* credentialsId;
@property (readonly,nonatomic) NSString* token;
@property (readonly,nonatomic) NSTimeInterval createdTime;
@property (readonly,nonatomic) NSTimeInterval expiredTime;
@property (readonly,nonatomic) NSTimeInterval timeToLive;
- (instancetype) initWithTemplate:(DFSPAuthorization*)model;
- (DFSPMutableAuthorization*) mutableCopy;
@end

@interface DFSPMutableAuthorization : DFSPAuthorization<DFSPMutableModel>
@property (strong,nonatomic,setter=setAuthorizationId:) NSString* authorizationId;
@property (strong,nonatomic,setter=setCredentialsId:) NSString* credentialsId;
@property (strong,nonatomic,setter=setToken:) NSString* token;
@property (nonatomic,setter=setCreatedTime:) NSTimeInterval createdTime;
@property (nonatomic,setter=setExpiredTime:) NSTimeInterval expiredTime;
@property (nonatomic,setter=setTimeToLive:) NSTimeInterval timeToLive;
- (void) setAuthorizationId:(NSString*)authorizationId;
- (void) setToken:(NSString*)token;
- (void) setCreatedTime:(NSTimeInterval)createdTime;
- (void) setExpiredTime:(NSTimeInterval)removedTime;
- (void) setTimeToLive:(NSTimeInterval)timeToLive;
- (DFSPAuthorization*) immutableCopy;
@end

@interface DFSPAuthorizationKVP : DFSPMutableAuthorization<DFSPModelKVP>
- (void) setValue:(id)value forUndefinedKey:(NSString *)key;
- (void) setValue:(id)value forKey:(NSString *)key;
+ (DFSPAuthorization*) fromDictionary:(NSDictionary*)dictionary;
@end
