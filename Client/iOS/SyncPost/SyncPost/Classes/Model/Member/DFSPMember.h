//
//  DFSPMember.h
//  SyncPost
//
//  Created by Dmitry Feld on 5/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPModel.h"

@class DFSPMutableMember;
@interface DFSPMember : NSObject<DFSPModel>
@property (readonly,nonatomic) NSString* memberID;
@property (readonly,nonatomic) NSString* deviceID;
@property (readonly,nonatomic) NSString* pushToken;
- (instancetype) initWithTemplate:(DFSPMember*)model;
- (DFSPMutableMember*) mutableCopy;
@end

@interface DFSPMutableMember : DFSPMember
@property (nonatomic,strong,setter=setMemberID:)NSString* memberID;
@property (nonatomic,strong,setter=setDeviceID:)NSString* deviceID;
@property (nonatomic,strong,setter=setPushToken:)NSString* pushToken;
- (void) setMemberID:(NSString*)memberID;
- (void) setDeviceID:(NSString*)deviceID;
- (void) setPushToken:(NSString*)pushToken;
- (DFSPMember*) immutableCopy;
@end

@interface DFSPMemberKVP : DFSPMutableMember
- (void) setValue:(id)value forUndefinedKey:(NSString *)key;
- (void) setValue:(id)value forKey:(NSString *)key;
+ (DFSPMember*) fromDictionary:(NSDictionary*)dictionary;
@end
