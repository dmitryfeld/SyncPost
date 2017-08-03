//
//  DFSPRestProcessor.h
//  SyncPost
//
//  Created by Dmitry Feld on 8/2/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFSPRestProcessor : NSObject
@property (readonly,nonatomic) BOOL inProgress;
- (instancetype) initWithRequest:(NSURLRequest*)request andCompletionHandler:(void(^)(NSError*,NSData*))completionHandler NS_DESIGNATED_INITIALIZER;
- (void) start;
- (void) stop;
@end
