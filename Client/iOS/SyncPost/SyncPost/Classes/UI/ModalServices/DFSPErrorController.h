//
//  DFSPErrorController.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/15/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFSPErrorController : UIViewController
@property (readonly,nonatomic) BOOL isPresented;
- (void) presentForController:(UIViewController*)controller withError:(NSError*)error andHandler:(void (^)())handler;
+ (DFSPErrorController*) newController;
@end
