//
//  DFSPAuthorizationService.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/27/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFSPAuthorizationService : NSObject
- (instancetype) initWithController:(UIViewController*)controller NS_DESIGNATED_INITIALIZER;
- (void) signOnWithHandler:(void(^)())handler;
- (void) signOffWithHandler:(void(^)())handler;
@end
