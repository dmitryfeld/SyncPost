//
//  DFSPAuthorizationPoint.h
//  SyncPost
//
//  Created by Dmitry Feld on 5/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPCredentials.h"

@class DFSPMutableAuthorizationPoint;
@interface DFSPAuthorizationPoint : NSObject<DFSPModel>
@property (readonly,nonatomic) DFSPCredentials* credentials;
@property (readonly,nonatomic) NSURL* accessURL;
- (instancetype) initWithTemplate:(DFSPAuthorizationPoint*)model;
- (DFSPMutableAuthorizationPoint*) mutableCopy;
@end

@interface DFSPMutableAuthorizationPoint : DFSPAuthorizationPoint
@property (strong,nonatomic,setter=setCredentials:) DFSPCredentials* credentials;
@property (strong,nonatomic,setter=setAccessURL:) NSURL* accessURL;
- (void) setCredentials:(DFSPCredentials *)credentials;
- (void) setAccessURL:(NSURL *)accessURL;
- (DFSPAuthorizationPoint*) immutableCopy;
@end

@interface DFSPAuthorizationPointKVP : DFSPMutableAuthorizationPoint
- (void) setValue:(id)value forUndefinedKey:(NSString *)key;
- (void) setValue:(id)value forKey:(NSString *)key;
+ (DFSPAuthorizationPoint*) fromDictionary:(NSDictionary*)dictionary;
@end
