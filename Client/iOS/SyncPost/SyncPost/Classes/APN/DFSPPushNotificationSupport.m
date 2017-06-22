//
//  DFSPPushNotificationSupport.m
//  SyncPost
//
//  Created by Dmitry Feld on 4/6/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPPushNotificationSupport.h"
#import "NSString+Service.h"
#import "DFSPApplicationData.h"

@interface DFSPPushNotificationSupport() {
@private
    __weak UIApplication* _owner;
    __strong NSError* _lastError;
    __strong NSString* _deviceToken;
}
@end

@implementation DFSPPushNotificationSupport
- (instancetype) init {
    if (self = [self initWithApplication:nil]) {
    }
    return self;
}
- (instancetype) initWithApplication:(UIApplication *)owner {
    if (self = [super init]) {
        _owner = owner;
    }
    return self;
}
- (void) startRegistration {
    [_owner registerForRemoteNotifications];
}
- (void) onFailedWithError:(NSError*)error {
    _lastError = error;
    NSLog(@"APNS ERROR: %@",error);
}
- (void) onDidRegisterWithToken:(NSData*)token {
    _deviceToken = [NSString stringWithDeviceID:token];
    DFSPApplicationDataGet().apnsPushToken = _deviceToken;
    NSLog(@"APNS TOKEN: %@",_deviceToken);
}
- (void) onDidReceiveNotification:(NSDictionary*)notification andFetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"APNS RECEIVED: %@",notification);
    if (completionHandler) {
        dispatch_async(dispatch_get_main_queue(),^{
            completionHandler(UIBackgroundFetchResultNewData);
        });
    }
}

@end
