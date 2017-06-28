//
//  DFSPSignOnViewController.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/15/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFSPCredentials.h"

@class DFSPSignOnViewController;
@protocol DFSPSignOnViewControllerDelegate <NSObject>
@required
- (void) signOnViewControllerDidTapSignonButton:(DFSPSignOnViewController*)controller;
@end

@interface DFSPSignOnViewController : UIViewController
@property (assign,nonatomic) id<DFSPSignOnViewControllerDelegate> delegate;
@property (readonly,nonatomic) DFSPCredentials* credentials;
@end
