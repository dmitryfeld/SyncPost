//
//  DFSPSettings.h
//  SyncPost
//
//  Created by Dmitry Feld on 5/19/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPEnvironment.h"

@interface DFSPSettings : NSObject
@property (readonly,nonatomic,strong) NSString* applicationName;
@property (readonly,nonatomic,strong) NSString* appVersionString;
@property (readonly,nonatomic,strong) NSString* bundleSeedIdentifier;
@property (readonly,nonatomic,strong) NSString* buildVersionString;
@property (readonly,nonatomic,strong) NSString* bundleIdentifier;
@property (readonly,nonatomic,strong) DFSPEnvironment* environment;
@property (readonly,nonatomic,strong) NSArray<DFSPEnvironment*>* availableEnvironments;
- (instancetype) init NS_DESIGNATED_INITIALIZER;
- (void) addEnvironment:(DFSPEnvironment*)environment;
- (void) selectEnvironment:(DFSPEnvironment*)environment;
@end
DFSPSettings* DFSPSettingsGet();
