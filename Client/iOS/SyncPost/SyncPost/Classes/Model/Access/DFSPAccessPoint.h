//
//  DFSPAccessPoint.h
//  SyncPost
//
//  Created by Dmitry Feld on 5/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPCredentials.h"
#import "DFSPAuthorization.h"

@class DFSPMutableAccessPoint;
@interface DFSPAccessPoint : NSObject<DFSPModel>
@property (readonly,nonatomic) DFSPCredentials* credentials;
@property (readonly,nonatomic) DFSPAuthorization* authorization;
@property (readonly,nonatomic) NSString* requestPath;
- (instancetype) initWithTemplate:(DFSPAccessPoint*)model;
- (DFSPMutableAccessPoint*) mutableCopy;
@end

@interface DFSPMutableAccessPoint : DFSPAccessPoint
@property (strong,nonatomic,setter=setCredentials:) DFSPCredentials* credentials;
@property (strong,nonatomic,setter=setAuthorization:) DFSPAuthorization* authorization;
@property (strong,nonatomic,setter=setRequestPath:) NSString* requestPath;
- (void) setAuthorization:(DFSPAuthorization *)authorization;
- (void) setRequestPath:(NSString*)requestPath;
- (DFSPAccessPoint*) immutableCopy;
@end

@interface DFSPAccessPointKVP : DFSPMutableAccessPoint
- (void) setValue:(id)value forUndefinedKey:(NSString *)key;
- (void) setValue:(id)value forKey:(NSString *)key;
+ (DFSPAccessPoint*) fromDictionary:(NSDictionary*)dictionary;
@end
