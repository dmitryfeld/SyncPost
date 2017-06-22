//
//  DFSPRequestData.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/21/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFSPRequestData : NSObject
@property (readonly,nonatomic,strong) NSString* name;
@property (readonly,nonatomic,strong) NSString* contentType;
@property (readonly,nonatomic,strong) NSString* requestPath;
@property (readonly,nonatomic,strong) NSString* method;
@property (readonly,nonatomic) BOOL simulated;
@property (readonly,nonatomic,strong) NSString* simulatedDataPath;
@property (readonly,nonatomic,strong) NSDictionary<NSString*,id>* parameters;
@property (readonly,nonatomic,strong) NSDictionary<NSString*,id>* body;
- (instancetype) initWithDisctionary:(NSDictionary<NSString*,id>*)dictionary NS_DESIGNATED_INITIALIZER;
@end
