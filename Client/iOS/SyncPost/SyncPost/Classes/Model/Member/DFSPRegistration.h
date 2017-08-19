//
//  DFSPRegistration.h
//  SyncPost
//
//  Created by Dmitry Feld on 8/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPModel.h"

@class DFSPMutableRegistration;
@interface DFSPRegistration : NSObject<DFSPModel>
@property (readonly,nonatomic,strong) NSString* registrationId;
@property (readonly,nonatomic,strong) NSString* memberId;
@property (readonly,nonatomic,strong) NSString* pushNotificationId;
- (instancetype) initWithTemplate:(DFSPRegistration*)model;
- (DFSPMutableRegistration*) mutableCopy;
@end

@interface DFSPMutableRegistration : DFSPRegistration<DFSPMutableModel>
@property (nonatomic,strong,setter=setRegistrationId:)NSString* registrationId;
@property (nonatomic,strong,setter=setMemberId:)NSString* memberId;
@property (nonatomic,strong,setter=setPushNotificationId:)NSString* pushNotificationId;
- (DFSPRegistration*) immutableCopy;
@end

@interface DFSPRegistrationKVP : DFSPMutableRegistration<DFSPModelKVP>
- (void) setValue:(id)value forUndefinedKey:(NSString *)key;
- (void) setValue:(id)value forKey:(NSString *)key;
+ (DFSPRegistration*) fromDictionary:(NSDictionary*)dictionary;
@end
