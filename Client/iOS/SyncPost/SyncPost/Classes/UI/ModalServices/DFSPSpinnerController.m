//
//  DFSPSpinnerController.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/15/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPSpinnerController.h"
#import "DFSPModalTransitionDelegate.h"
#import "UIColor+Service.h"

@interface DFSPSpinnerController () {
@private
    __strong UIColor* _backgroundColor;
}
@property (strong,nonatomic) IBOutlet UIActivityIndicatorView* activityIndicatorView;
@end

@implementation DFSPSpinnerController
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void) whenPresented {
    [self.activityIndicatorView startAnimating];
}
- (void) whenDismissed {
    [self.activityIndicatorView stopAnimating];
}

- (UIColor*) backgroundColor {
    if (!_backgroundColor) {
        _backgroundColor = [[UIColor alloc] initWithWhite:0x000000 alpha:.3];
    }
    return _backgroundColor;
}
+ (DFSPSpinnerController*) newController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SpinnerController" bundle:nil];
    NSString* identifier = @"DFSPSpinnerController";
    return (DFSPSpinnerController*)[storyboard instantiateViewControllerWithIdentifier:identifier];
}

@end
