//
//  SearchResultItem.h
//  ios-caa-ecSearch
//
//  Created by Carter Chang on 7/27/15.
//  Copyright (c) 2015 Carter Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OHMKit.h>


@interface SearchResultItem : NSObject

@property(nonatomic, strong) NSString *property;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *imageUrl;
@property(nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) NSInteger price;

@end
