//
//  SearchResultItem.m
//  ios-caa-ecSearch
//
//  Created by Carter Chang on 7/27/15.
//  Copyright (c) 2015 Carter Chang. All rights reserved.
//

#import "SearchResultItem.h"

@implementation SearchResultItem

-(id)initWithPropertyName:(NSString *)propertyName{
    self = [super init];
    if (self) {
        _property = propertyName;
    }
    return self;
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end
