//
//  DFSPModalController.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/15/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPModalController.h"
#import "DFSPModalTransitionDelegate.h"
#import "UIColor+Service.h"

@interface DFSPModalController () {
@private
    BOOL _isPresented;
    __strong UIViewController* _parentController;
    __strong DFSPModalTransitionDelegate* _transitioning;
}
@property (strong,nonatomic) DFSPModalTransitionDelegate* transitioning;

@end

@implementation DFSPModalController
@synthesize isPresented = _isPresented;
@synthesize transitioning = _transitioning;
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
            [self whenPresented];
            _isPresented = YES;
            [self callHandler:handler];
        }];
    }
}
- (void) dismissWithHandler:(void (^)())handler {
    if (_isPresented) {
        [self whenDismissed];
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
- (void) whenPresented {
    
}
- (void) whenDismissed {
    
}

- (DFSPModalTransitionDelegate*) transitioning {
    if (!_transitioning) {
        _transitioning = [DFSPModalTransitionDelegate new];
    }
    return _transitioning;
}
- (UIColor*) backgroundColor {
    return [[UIColor alloc] initWithWhite:0x000000 alpha:.3];
}

@end
