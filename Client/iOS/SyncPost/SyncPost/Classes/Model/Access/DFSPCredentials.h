//
//  DFSPCredentials.h
//  SyncPost
//
//  Created by Dmitry Feld on 5/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPModel.h"

@class DFSPMutableCredentials;
@interface DFSPCredentials : NSObject<DFSPModel>
@property (readonly,nonatomic) NSString* memberName;
@property (readonly,nonatomic) NSString* password;
- (instancetype) initWithTemplate:(DFSPCredentials*)model;
- (DFSPMutableCredentials*) mutableCopy;
@end

@interface DFSPMutableCredentials : DFSPCredentials<DFSPMutableModel>
@property (strong,nonatomic,setter=setMemberName:) NSString* memberName;
@property (strong,nonatomic,setter=setPassword:) NSString* password;
- (void) setUserName:(NSString*)memberName;
- (void) setPassword:(NSString*)password;
- (DFSPCredentials*) immutableCopy;
@end

@interface DFSPCredentialsKVP : DFSPMutableCredentials<DFSPModelKVP>
- (void) setValue:(id)value forUndefinedKey:(NSString *)key;
- (void) setValue:(id)value forKey:(NSString *)key;
+ (DFSPCredentials*) fromDictionary:(NSDictionary*)dictionary;
@end
