//
//  DFSPRequestTemplate.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/21/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPModel.h"

@interface DFSPRequest : NSObject
@property (readonly,nonatomic,strong) NSURLRequest* request;
@property (readonly,nonatomic,strong) NSError* error;
- (instancetype) initWithRequest:(NSURLRequest*) request andError:(NSError*) error NS_DESIGNATED_INITIALIZER;
@end

@interface DFSPResponse : NSObject
@property (readonly,nonatomic,strong) id<DFSPModel> model;
@property (readonly,nonatomic,strong) NSError* error;
- (instancetype) initWithModel:(id<DFSPModel>)model andError:(NSError*) error NS_DESIGNATED_INITIALIZER;
@end


@interface DFSPRequestTemplate : NSObject
@property (readonly,nonatomic,strong) NSString* name;
@property (readonly,nonatomic,strong) NSString* contentType;
@property (readonly,nonatomic,strong) NSString* requestPath;
@property (readonly,nonatomic,strong) NSString* method;
@property (readonly,nonatomic,strong) NSString* simulatedDataPath;
@property (readonly,nonatomic,strong) NSDictionary<NSString*,NSString*>* parameters;
@property (readonly,nonatomic,strong) NSDictionary<NSString*,NSString*>* body;
- (instancetype) initWithDisctionary:(NSDictionary<NSString*,id>*)dictionary NS_DESIGNATED_INITIALIZER;
- (DFSPRequest*) prepareRequestWithContext:(id)context;
- (DFSPResponse*) processResponse:(NSDictionary*)response;
@end
