//
//  DFSPMember.h
//  SyncPost
//
//  Created by Dmitry Feld on 8/8/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPModel.h"

@class DFSPMutableMember;
@interface DFSPMember : NSObject<DFSPModel>
@property (readonly,nonatomic) NSString* memberName;
@property (readonly,nonatomic) NSString* firstName;
@property (readonly,nonatomic) NSString* lastName;
@property (readonly,nonatomic) NSString* displayName;
@property (readonly,nonatomic) NSString* comment;
- (instancetype) initWithTemplate:(DFSPMember*)model;
- (DFSPMutableMember*) mutableCopy;
@end


@interface DFSPMutableMember : DFSPMember
@property (nonatomic,strong,setter=setMemberName:)NSString* memberName;
@property (nonatomic,strong,setter=setFirstName:)NSString* firstName;
@property (nonatomic,strong,setter=setLastName:)NSString* lastName;
@property (nonatomic,strong,setter=setDisplayName:)NSString* displayName;
@property (nonatomic,strong,setter=setComment:)NSString* comment;
- (void) setMemberName:(NSString*)memberID;
- (void) setFirstName:(NSString *)firstName;
- (void) setLastName:(NSString *)lastName;
- (void) setDisplayName:(NSString *)displayName;
- (void) setComment:(NSString *)comment;
- (DFSPMember*) immutableCopy;
@end

@interface DFSPMemberKVP : DFSPMutableMember
- (void) setValue:(id)value forUndefinedKey:(NSString *)key;
- (void) setValue:(id)value forKey:(NSString *)key;
+ (DFSPMember*) fromDictionary:(NSDictionary*)dictionary;
@end
