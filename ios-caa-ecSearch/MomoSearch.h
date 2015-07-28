//
//  MomoSearch.h
//  ios-caa-ecSearch
//
//  Created by Carter Chang on 7/27/15.
//  Copyright (c) 2015 Carter Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECSearch.h"

@interface MomoSearch : ECSearch
@end


@interface MomoSearchResultItem_A : NSObject
  @property (nonatomic, strong) NSString *href;
  @property (nonatomic, strong) NSDictionary *img;
@end

@interface MomoSearchResultItem : NSObject
  @property (nonatomic, strong) NSArray *p;
  @property (nonatomic, strong) MomoSearchResultItem_A *a;
@end
