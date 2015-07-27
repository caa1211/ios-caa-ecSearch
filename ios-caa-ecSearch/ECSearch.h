//
//  ECSearch.h
//  ios-caa-ecSearch
//
//  Created by Carter Chang on 7/27/15.
//  Copyright (c) 2015 Carter Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchResultItem.h"

@interface ECSearch : NSObject
-(NSMutableArray *) searchWithKeyword:(NSString*)keyword;
-(void) searchWithKeywordAsync:(NSString *)keyword completion: (void(^)(NSMutableArray *result, NSError *error))completion;
@end
