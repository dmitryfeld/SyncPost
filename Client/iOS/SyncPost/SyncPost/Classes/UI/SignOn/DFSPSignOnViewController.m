//
//  DFSPSignOnViewController.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/15/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPSignOnViewController.h"

@interface DFSPSignOnViewController ()<UITextFieldDelegate> {
    UITextField* _activeField;
    CGFloat _slidingViewDisplacement;
}
@property (strong,nonatomic) IBOutlet UITextField* userNameTextField;
@property (strong,nonatomic) IBOutlet UITextField* passwordTextField;
@property (strong,nonatomic) IBOutlet UIButton* signOnButton;
@property (strong,nonatomic) IBOutlet UIView* slidingView;
@property (strong,nonatomic,readonly) UITapGestureRecognizer *tapGesture;

@end

@implementation DFSPSignOnViewController
@synthesize delegate;
@synthesize tapGesture = _tapGesture;
@dynamic credentials;

- (void) dealloc {
    [self unRegisterForKeyboardNotifications];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    self.userNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.signOnButton.enabled = [self validateInput];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) onSignOnButton:(id)sender {
    [self hideKeyboard];
    if ([self.delegate respondsToSelector:@selector(signOnViewControllerDidTapUpdateButton:)]) {
        if ([NSThread isMainThread]) {
            [self.delegate signOnViewControllerDidTapUpdateButton:self];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate signOnViewControllerDidTapUpdateButton:self];
            });
        }
    }
}
-(IBAction) onTextFieldChanged:(id)sender {
    UITextField *textField = (UITextField *)sender;
    textField.rightView.hidden = YES;
    if (textField == self.userNameTextField) {
        self.signOnButton.enabled = [self validateInput];
    }
    if (textField == self.passwordTextField) {
        self.signOnButton.enabled = [self validateInput];
    }
}


- (BOOL) validateInput {
    BOOL result = NO;
    if (self.userNameTextField.text.length > 6) {
        result = YES;
    }
    if (self.passwordTextField.text.length > 8) {
        result = YES;
    }
    return YES;
}

#pragma mark Text Field Delegate Methods
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_activeField != textField) {
        _activeField = textField;
    }
    [self.view addGestureRecognizer:self.tapGesture];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.rightView.hidden = YES;
    
    if (textField == self.userNameTextField) {
        textField.returnKeyType = UIReturnKeyNext;
    }
    
    if (textField == self.passwordTextField) {
        textField.returnKeyType = UIReturnKeyGo;
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.userNameTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    
    if (textField == self.passwordTextField) {
        [self hideKeyboard];
        [self onSignOnButton:nil];
    }
    return YES;
}

#pragma mark Keyboard Notification methods
- (void) registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
}
- (void) unRegisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void) onKeyboardWillAppear:(NSNotification*)aNotification {
    NSDictionary* info = aNotification.userInfo;
    CGSize size = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self showKeyboardWithKeyboardSize:size];
}
- (void) onKeyboardWillDisappear:(NSNotification*)aNotification {
    [self hideKeyboard];
}

#pragma mark Keyboard Methods
-(void) showKeyboardWithKeyboardSize:(CGSize)keyboarSize {
    CGRect slidingFrame = self.slidingView.frame;
    CGFloat remainingHeight = self.view.frame.size.height - keyboarSize.height;
    
    CGFloat slidingViewDisplacement = remainingHeight - (slidingFrame.size.height + slidingFrame.origin.y);
    
    if ((slidingViewDisplacement < 0) && (slidingViewDisplacement != _slidingViewDisplacement)) {
        _slidingViewDisplacement = slidingViewDisplacement;
        [UIView animateWithDuration:0.2 animations:^{
            CGRect aRect = self.view.frame;
            aRect.origin.y = _slidingViewDisplacement;
            self.view.frame = aRect;
        }];
    }
}
-(void) hideKeyboard {
    [_activeField resignFirstResponder];
    if (_slidingViewDisplacement < 0) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect loginFrame = self.view.frame;
            loginFrame.origin.y -= _slidingViewDisplacement;
            self.view.frame = loginFrame;
            _slidingViewDisplacement = 0.f;
        }];
    }
    [self.view removeGestureRecognizer:self.tapGesture];
}
#pragma mark Tap Gesture Methods
- (UITapGestureRecognizer*) tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    }
    return _tapGesture;
}
- (void) onTapGesture:(UIGestureRecognizer*)gesture {
    [self hideKeyboard];
}


- (DFSPCredentials*) credentials {
    DFSPMutableCredentials* result = [DFSPMutableCredentials new];
    result.userName = self.userNameTextField.text;
    result.password = self.passwordTextField.text;
    return [result immutableCopy];
}

@end
