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
@property (readonly,nonatomic) NSString* userName;
@property (readonly,nonatomic) NSString* password;
- (instancetype) initWithTemplate:(DFSPCredentials*)model;
- (DFSPMutableCredentials*) mutableCopy;
@end

@interface DFSPMutableCredentials : DFSPCredentials<DFSPMutableModel>
@property (strong,nonatomic,setter=setUserName:) NSString* userName;
@property (strong,nonatomic,setter=setPassword:) NSString* password;
- (void) setUserName:(NSString*)userName;
- (void) setPassword:(NSString*)password;
- (DFSPCredentials*) immutableCopy;
@end

@interface DFSPCredentialsKVP : DFSPMutableCredentials<DFSPModelKVP>
- (void) setValue:(id)value forUndefinedKey:(NSString *)key;
- (void) setValue:(id)value forKey:(NSString *)key;
+ (DFSPCredentials*) fromDictionary:(NSDictionary*)dictionary;
@end
