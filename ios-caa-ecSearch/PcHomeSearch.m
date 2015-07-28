//
//  PcHomeSearch.m
//  ios-caa-ecSearch
//
//  Created by Carter Chang on 7/27/15.
//  Copyright (c) 2015 Carter Chang. All rights reserved.
//

#import "PcHomeSearch.h"
#import <AFHTTPRequestOperationManager.h>
#import <OHMKit.h>

//OHMMappable([SearchResultItem class]);

//OHMSetMapping([searchResultItem class], @{@"favorite_word"  : @"favoriteWord",
//                                 @"favorite_number": @"favoriteNumber");

@interface PcHomeSearch ()
    @property(nonatomic, strong) AFHTTPRequestOperationManager *requestMamager;
    @property(nonatomic, strong) NSString *baseImageUrlStr;
    @property(nonatomic, strong) NSString *baseUrlStr;
@end


@implementation PcHomeSearch

-(id)init {
    self = [super init];
    if(self){
        self.requestMamager = [[AFHTTPRequestOperationManager alloc]init];
        self.baseImageUrlStr = @"http://ec1img.pchome.com.tw";
        self.baseUrlStr = @"http://24h.pchome.com.tw/prod/";
    }
    return self;
}

-(void) searchWithKeywordAsync:(NSString *)keyword completion: (void(^)(NSMutableArray *result, NSError *error))completion {
    [self.requestMamager GET:@"http://ecshweb.pchome.com.tw/search/v3.3/all/results" parameters:@{@"q": keyword} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *itemAry = responseObject[@"prods"];
        NSMutableArray* resAry = [[NSMutableArray alloc]init];
        for (NSDictionary *itemRaw in itemAry) {
            SearchResultItem* searchResultItem = [[SearchResultItem alloc] init];
            searchResultItem.property = @"PCHome";
            searchResultItem.title = itemRaw[@"name"];
            searchResultItem.url = [[self.baseUrlStr copy] stringByAppendingString:itemRaw[@"Id"]];
            searchResultItem.imageUrl = [[self.baseImageUrlStr copy] stringByAppendingString:itemRaw[@"picS"]];
            searchResultItem.price =  [itemRaw[@"price"] integerValue];
            searchResultItem.desc = itemRaw[@"describe"];
            [resAry addObject:searchResultItem];
        }
        
        completion(resAry, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }] ;
}


-(void) searchWithKeywordAsync_map:(NSString *)keyword completion: (void(^)(NSMutableArray *result, NSError *error))completion {
    
    OHMMappable([SearchResultItem class]);
    OHMSetMapping([SearchResultItem class], @{
                                              @"name": @"title",
                                              @"price": @"price",
                                              @"describe": @"desc",
                                              @"picS": @"imageUrl",
                                              @"Id": @"url"
                                              });
                                     
    OHMValueAdapterBlock completeImageUrl = ^(NSString *url) {
        return [[self.baseImageUrlStr copy] stringByAppendingString:url];
    };
    
    OHMValueAdapterBlock completeUrl = ^(NSString *url) {
        return [[self.baseUrlStr copy] stringByAppendingString:url];
    };
    
    OHMSetAdapter([SearchResultItem class], @{@"imageUrl": completeImageUrl, @"url": completeUrl});
    
    [self.requestMamager GET:@"http://ecshweb.pchome.com.tw/search/v3.3/all/results" parameters:@{@"q": keyword} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         
        NSArray *itemAry = responseObject[@"prods"];
        NSMutableArray* resAry = [[NSMutableArray alloc]init];
        for (NSDictionary *itemRaw in itemAry) {
            SearchResultItem* searchResultItem = [[SearchResultItem alloc] init];
            searchResultItem.property = @"PCHome";
            [searchResultItem setValuesForKeysWithDictionary:itemRaw];
            [resAry addObject:searchResultItem];
        }
        
        completion(resAry, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }] ;
    
     
}

@end
