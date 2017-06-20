//
//  DFSPRestRequest.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPAccessPoint.h"

@interface DFSPRestRequest : NSObject
@property (readonly,nonatomic,strong) DFSPAccessPoint* accessPoint;
- (instancetype) initWithAccessPoint:(DFSPAccessPoint*)accessPoint NS_DESIGNATED_INITIALIZER;
- (NSMutableURLRequest*) formURLRequest;
- (NSString*) simulatedFileName;
@end
