//
//  DFSPRequestTemplate.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/21/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPModel.h"

@interface DFSPRequestTemplate : NSObject
@property (readonly,nonatomic,strong) NSString* name;
@property (readonly,nonatomic,strong) NSString* contentType;
@property (readonly,nonatomic,strong) NSString* requestPath;
@property (readonly,nonatomic,strong) NSString* method;
@property (readonly,nonatomic) BOOL simulated;
@property (readonly,nonatomic,strong) NSString* simulatedDataPath;
@property (readonly,nonatomic,strong) NSDictionary<NSString*,NSString*>* parameters;
@property (readonly,nonatomic,strong) NSDictionary<NSString*,NSString*>* body;
- (instancetype) initWithDisctionary:(NSDictionary<NSString*,id>*)dictionary NS_DESIGNATED_INITIALIZER;
- (NSURLRequest*) prepareRequestWithContext:(id)context withError:(NSError * _Nullable *)error;
- (id<DFSPModel>) processResponse:(NSDictionary*)response withError:(NSError * _Nullable *)error;
@end
