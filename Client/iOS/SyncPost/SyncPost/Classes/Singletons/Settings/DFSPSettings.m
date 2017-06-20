//
//  DFSPSettings.m
//  SyncPost
//
//  Created by Dmitry Feld on 5/19/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPSettings.h"
#import "DFSPSingleton.h"

const static NSString *__kDFSPSettingsTag = @"__kDFSPSettingsTag";

@interface DFSPSettings()<DFSPTagged> {
@private
    __strong NSMutableArray<DFSPEnvironment*>* _environments;
    NSUInteger _environmentID;
}
@end

@implementation DFSPSettings
@synthesize applicationName = _applicationName;
@synthesize appVersionString = _appVersionString;
@synthesize bundleSeedIdentifier = _bundleSeedIdentifier;
@synthesize buildVersionString = _buildVersionString;
@synthesize bundleIdentifier = _bundleIdentifier;

@synthesize availableEnvironments = _environments;
@dynamic environment;
- (instancetype) init {
    if (self = [super init]) {
        NSDictionary *infoPList = [NSBundle mainBundle].infoDictionary;
        NSString* appName = infoPList[@"CFBundleExecutable"];
        NSString* userDefaults = infoPList[@"Defaults"];
        NSString* appVersion = infoPList[@"CFBundleShortVersionString"];
        NSString* buildVersion = infoPList[@"CFBundleVersion"];
        NSString* bundleSeedIdentifier = [self bundleSeedID];
        NSString* bundleIdentifier = infoPList[@"CFBundleIdentifier"];
        
        _applicationName = appName;
        _appVersionString = [NSString stringWithFormat:@"%@",appVersion];
        _buildVersionString = [NSString stringWithFormat:@"(%@)",buildVersion];
        _bundleSeedIdentifier = bundleSeedIdentifier;
        _bundleIdentifier = bundleIdentifier;
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:userDefaults ofType:@"plist"]]];
        
        {
            NSArray<NSDictionary<NSString*,NSString*>*>* environments= [[NSUserDefaults standardUserDefaults] objectForKey:@"environments"];
            _environments = [DFSPEnvironment listWithArrayOfDictionaries:environments];
            _environmentID = [[NSUserDefaults standardUserDefaults] integerForKey:@"environmentID"];
        }
        
    }
    return self;
}
- (NSString *)bundleSeedID {
    NSDictionary* query = @{(__bridge NSString *)kSecClass:(__bridge NSString *)kSecClassGenericPassword,(__bridge NSString *)kSecAttrAccount:@"bundleSeedID",(__bridge NSString *)kSecAttrService:@"",(__bridge NSString *)kSecReturnAttributes:(__bridge NSNumber *)kCFBooleanTrue};
    
    CFDictionaryRef result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status == errSecItemNotFound) {
        status = SecItemAdd((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    }
    if (status != errSecSuccess) {
        return nil;
    }
    NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kSecAttrAccessGroup];
    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
    NSString *bundleSeedID = [[components objectEnumerator] nextObject];
    CFRelease(result);
    return bundleSeedID;
}
- (void) addEnvironment:(DFSPEnvironment *)environment {
    if (![_environments containsObject:environment]) {
        [_environments addObject:environment];
        [[NSUserDefaults standardUserDefaults] setObject:_environments forKey:@"environments"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (void) selectEnvironment:(DFSPEnvironment *)environment {
    if ([_environments containsObject:environment]) {
        NSUInteger environmentID = [_environments indexOfObject:environment];
        if (NSNotFound != environmentID) {
            if (_environmentID != environmentID) {
                _environmentID = environmentID;
                [[NSUserDefaults standardUserDefaults] setInteger:_environmentID forKey:@"environmentID"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
}
- (DFSPEnvironment*) environment {
    DFSPEnvironment* result = nil;
    if (_environmentID < _environments.count) {
        result = _environments[_environmentID];
    }
    return result;
}

- (id) tag {
    return __kDFSPSettingsTag;
}
@end
DFSPSettings* DFSPSettingsGet() {
    DFSPSettings* result = [DFSPSingleton objectForTag:__kDFSPSettingsTag];
    if (!result) {
        result = [DFSPSettings new];
        [DFSPSingleton addObject:result];
    }
    return result;
}
