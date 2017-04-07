//
//  DFSPPushNotificationSupport.h
//  SyncPost
//
//  Created by Dmitry Feld on 4/6/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFSPPushNotificationSupport : NSObject
- (instancetype) initWithApplication:(UIApplication*)owner NS_DESIGNATED_INITIALIZER;
- (void) startRegistration;
- (void) onFailedWithError:(NSError*)error;
- (void) onDidRegisterWithToken:(NSData*)token;
- (void) onDidReceiveNotification:(NSDictionary*)notification andFetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
@end
