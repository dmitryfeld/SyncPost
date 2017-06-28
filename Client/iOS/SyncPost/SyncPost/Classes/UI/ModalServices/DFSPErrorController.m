//
//  DFSPErrorController.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/15/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPErrorController.h"
#import "DFSPModalTransitionDelegate.h"
#import "UIColor+Service.h"

@interface DFSPErrorController () {
@private
    __strong NSError* _error;
    __strong UIColor* _backgroundColor;
    __strong UITapGestureRecognizer* _tapGesture;
    __strong void(^_completionHandler)();
}
@property (strong,nonatomic) IBOutlet UILabel* errorLabel;
@property (strong,nonatomic) UIColor* backgroundColor;
@property (strong,nonatomic) UITapGestureRecognizer* tapGesture;

@end

@implementation DFSPErrorController
@synthesize error = _error;
@synthesize backgroundColor = _backgroundColor;
@synthesize tapGesture = _tapGesture;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.tapGesture];
    self.errorLabel.text = _error.localizedDescription;
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void) presentForController:(UIViewController*)controller withHandler:(void(^)())handler {
    if (!self.isPresented) {
        _completionHandler = handler;
        [super presentForController:controller withHandler:handler];
    }
}
- (void) whenPresented {
}
- (void) whenDismissed {
}

- (UIColor*) backgroundColor {
    if (!_backgroundColor) {
        _backgroundColor = [[UIColor alloc] initWithWhite:0x000000 alpha:.3];
    }
    return _backgroundColor;
}
- (UITapGestureRecognizer*) tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    }
    return _tapGesture;
}
- (void) onTapGesture:(UIGestureRecognizer*)gesture {
    [self dismissWithHandler:_completionHandler];
}
- (NSError*) error {
    return _error;
}
- (void) setError:(NSError *)error {
    if (![_error isEqual:error]) {
        _error = error;
        self.errorLabel.text = _error.localizedDescription;
    }
}
+ (DFSPErrorController*) newController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ErrorController" bundle:nil];
    NSString* identifier = @"DFSPErrorController";
    return (DFSPErrorController*)[storyboard instantiateViewControllerWithIdentifier:identifier];
}

@end
