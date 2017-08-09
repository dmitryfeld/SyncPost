//
//  DFSPSubscriber.h
//  SyncPost
//
//  Created by Dmitry Feld on 5/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPModel.h"

@class DFSPMutableSubscriber;
@interface DFSPSubscriber : NSObject<DFSPModel>
@property (readonly,nonatomic) NSString* memberName;
@property (readonly,nonatomic) NSString* deviceID;
@property (readonly,nonatomic) NSString* pushToken;
- (instancetype) initWithTemplate:(DFSPSubscriber*)model;
- (DFSPMutableSubscriber*) mutableCopy;
@end

@interface DFSPMutableSubscriber : DFSPSubscriber
@property (nonatomic,strong,setter=setMemberName:)NSString* memberName;
@property (nonatomic,strong,setter=setDeviceID:)NSString* deviceID;
@property (nonatomic,strong,setter=setPushToken:)NSString* pushToken;
- (void) setMemberName:(NSString*)memberID;
- (void) setDeviceID:(NSString*)deviceID;
- (void) setPushToken:(NSString*)pushToken;
- (DFSPSubscriber*) immutableCopy;
@end

@interface DFSPSubscriberKVP : DFSPMutableSubscriber
- (void) setValue:(id)value forUndefinedKey:(NSString *)key;
- (void) setValue:(id)value forKey:(NSString *)key;
+ (DFSPSubscriber*) fromDictionary:(NSDictionary*)dictionary;
@end
