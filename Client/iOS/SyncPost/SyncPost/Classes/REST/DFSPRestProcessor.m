//
//  DFSPRestProcessor.m
//  SyncPost
//
//  Created by Dmitry Feld on 8/2/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPRestProcessor.h"
#import "NSError+Rest.h"

@interface DFSPRestProcessor()<NSURLSessionDataDelegate, NSURLSessionTaskDelegate> {
@private
    __strong NSURLRequest* _request;
    __strong void(^_completionHandler)(NSError*,NSData*);
    __strong NSURLSessionTask* _task;
    __strong NSMutableData* _data;
    //=====
    //SecIdentityRef _clientCertificate;
}
@end

@implementation DFSPRestProcessor
@dynamic inProgress;
- (instancetype) init {
    if (self = [self initWithRequest:nil andCompletionHandler:nil]) {
        [NSException raise:@"DFSPRestAPI Init" format:@"Invalid Arguments"];
    }
    return self;
}
- (instancetype) initWithRequest:(NSURLRequest*)request andCompletionHandler:(void(^)(NSError*,NSData*))completionHandler {
    if (self = [super init]) {
        _request = request;
        _completionHandler = completionHandler;
    }
    return self;
}
- (void) dealloc {
    [self stop];
}
- (void) start {
    if (!self.inProgress) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
        
        _task = [session dataTaskWithRequest:_request];
        if( _task ) {
            if (!_data) {
                _data = [NSMutableData new];
            }
            _data.length = 0;
            [_task resume];
        } else {
            NSError* error = [NSError restErrorWithCode:kDFSPRestErrorFailureToStartURLSession];
            [self processHandlerWithError:error andData:_data];
        }
    }
}
- (void) stop {
    [_task cancel],_task = nil;
    _data.length = 0;
}
- (BOOL) inProgress {
    return nil != _task;
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    _data.length = 0;
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    [self processHandlerWithError:error andData:_data];
}

/*
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate]) {
        NSURLCredential *credential = [self provideClientCertificate];
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    }
}
*/
- (void) processHandlerWithError:(NSError*)error andData:(NSData*)data {
    if (_completionHandler) {
        if ([NSThread isMainThread]) {
            _completionHandler(error,data);
            [_task cancel],_task = nil;
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _completionHandler(error,data);
                [_task cancel],_task = nil;
            });
        }
    }
}

/*
- (SecIdentityRef) findClientCertificate {
    
    
    NSString *pkcs12Path = [[NSBundle mainBundle] pathForResource:@"blah" ofType:@"p12"];
    NSData *pkcs12Data = [[NSData alloc] initWithContentsOfFile:pkcs12Path];
    
    CFDataRef inPKCS12Data = (__bridge CFDataRef)pkcs12Data;
    CFStringRef password = CFSTR("password");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items = NULL;
    
    OSStatus err = SecPKCS12Import(inPKCS12Data, optionsDictionary, &items);
    
    CFRelease(optionsDictionary);
    CFRelease(password);
    
    if (_clientCertificate) {
        CFRelease(_clientCertificate);
        _clientCertificate = NULL;
    }

    
    if (err == errSecSuccess && CFArrayGetCount(items) > 0) {
        CFDictionaryRef pkcsDict = CFArrayGetValueAtIndex(items, 0);
        
        SecTrustRef trust = (SecTrustRef)CFDictionaryGetValue(pkcsDict, kSecImportItemTrust);
        
        if (trust != NULL) {
            _clientCertificate = (SecIdentityRef)CFDictionaryGetValue(pkcsDict, kSecImportItemIdentity);
            CFRetain(_clientCertificate);
        }
    }
    
    if (items) {
        CFRelease(items);
    }
    
    return _clientCertificate;
}

- (NSURLCredential *)provideClientCertificate {
    SecIdentityRef identity = [self findClientCertificate];
    
    if (!identity) {
        return nil;
    }
    
    SecCertificateRef certificate = NULL;
    SecIdentityCopyCertificate (identity, &certificate);
    const void *certs[] = {certificate};
    CFArrayRef certArray = CFArrayCreate(kCFAllocatorDefault, certs, 1, NULL);
    NSURLCredential *credential = [NSURLCredential credentialWithIdentity:identity certificates:(__bridge NSArray *)certArray persistence:NSURLCredentialPersistencePermanent];
    CFRelease(certArray);
    
    return credential;
}
*/

@end
