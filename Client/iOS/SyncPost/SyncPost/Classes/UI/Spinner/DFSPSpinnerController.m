//
//  DFSPSpinnerController.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/15/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPSpinnerController.h"
#import "DFSPSpinnerTransitionDelegate.h"
#import "UIColor+Service.h"

@interface DFSPSpinnerController () {
@private
    BOOL _isPresented;
    __strong UIViewController* _parentController;
    __strong DFSPSpinnerTransitionDelegate* _transitioning;
    __strong UIColor* _backgroundColor;
}
@property (strong,nonatomic) IBOutlet UIActivityIndicatorView* activityIndicatorView;
@property (strong,nonatomic) DFSPSpinnerTransitionDelegate* transitioning;
@property (strong,nonatomic) UIColor* backgroundColor;

@end

@implementation DFSPSpinnerController
@synthesize isPresented = _isPresented;
@synthesize transitioning = _transitioning;
@synthesize backgroundColor = _backgroundColor;
- (void)viewDidLoad {
    [super viewDidLoad];
    _isPresented = NO;
    self.view.backgroundColor = self.backgroundColor;
    self.transitioningDelegate = self.transitioning;
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void) presentForController:(UIViewController*)controller withHandler:(void (^)())handler {
    if (!_isPresented) {
        _parentController = controller;
        self.modalPresentationStyle = UIModalPresentationCustom;
        [_parentController presentViewController:self animated:YES completion:^{
            [self.activityIndicatorView startAnimating];
            _isPresented = YES;
            [self callHandler:handler];
        }];
    }
}
- (void) dismissWithHandler:(void (^)())handler {
    if (_isPresented) {
        [self.activityIndicatorView stopAnimating];
        _isPresented = NO;
        [_parentController dismissViewControllerAnimated:YES completion:^{
            [self callHandler:handler];
        }];
    }
}
- (void) callHandler:(void(^)())handler {
    if (handler) {
        if ([NSThread isMainThread]) {
            handler();
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler();
            });
        }
    }
}
- (DFSPSpinnerTransitionDelegate*) transitioning {
    if (!_transitioning) {
        _transitioning = [DFSPSpinnerTransitionDelegate new];
    }
    return _transitioning;
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
