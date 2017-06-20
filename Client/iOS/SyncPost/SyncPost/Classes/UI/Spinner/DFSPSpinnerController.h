//
//  DFSPSpinnerController.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/15/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFSPSpinnerController : UIViewController
@property (readonly,nonatomic) BOOL isPresented;
- (void) presentForController:(UIViewController*)controller withHandler:(void(^)())handler;
- (void) dismissWithHandler:(void(^)())handler;
+ (DFSPSpinnerController*) newController;
@end
