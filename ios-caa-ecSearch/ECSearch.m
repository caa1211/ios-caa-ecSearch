//
//  ECSearch.m
//  ios-caa-ecSearch
//
//  Created by Carter Chang on 7/27/15.
//  Copyright (c) 2015 Carter Chang. All rights reserved.
//

#import "ECSearch.h"


@interface ECSearch ()
@property(strong, nonatomic) NSString *property;
@property(strong, nonatomic) dispatch_queue_t queryQueue;
@end


@implementation ECSearch


-(NSString *) propertyName {
    return @"";
}


-(id)init {
    self = [super init];
    if(self){
        self.queryQueue = dispatch_queue_create("momo_queue", nil);
        self.property = [self propertyName];
    }
    return self;
}

-(NSMutableArray *) searchWithKeyword:(NSString *)keyword {
    return nil;
}

-(void) searchWithKeywordAsync:(NSString *)keyword completion: (void(^)(NSMutableArray *result, NSError *error))completion {
    
    dispatch_async(self.queryQueue, ^{
        
        NSMutableArray* resAry = [self searchWithKeyword:keyword];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            completion(resAry, nil);
        });
        
    });
}

@end
