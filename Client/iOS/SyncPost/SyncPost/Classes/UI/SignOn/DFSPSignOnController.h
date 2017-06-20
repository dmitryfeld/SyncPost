//
//  DFSPSignOnController.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/15/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFSPSignOnController : UINavigationController
@property (readonly,nonatomic) BOOL isPresented;
- (void) presentForController:(UIViewController*)controller withHandler:(void(^)(NSError*))handler;
+ (DFSPSignOnController*) newController;
@end
