//
//  MomoSearch.m
//  ios-caa-ecSearch
//
//  Created by Carter Chang on 7/27/15.
//  Copyright (c) 2015 Carter Chang. All rights reserved.
//

#import "MomoSearch.h"
#import "YQL.h"

@interface MomoSearch ()
  @property (strong, nonatomic) NSMutableArray *result;
  @property(nonatomic, strong) YQL* yql;
  @property(strong, nonatomic) dispatch_queue_t queryQueue;
  @property(nonatomic, strong) NSString *baseImageUrlStr;
  @property(nonatomic, strong) NSString *queryString;
@end

@implementation MomoSearchResultItem;
@end

@implementation MomoSearchResultItem_A
@end

@implementation MomoSearch

-(id)init {
    self = [super init];
    if(self){
       self.yql = [[YQL alloc]init];
       self.queryQueue = dispatch_queue_create("momo_queue", nil);
       self.queryString = @"select * from html where url=\"http://www.momoshop.com.tw/mosearch/%@.html\" and xpath='//ul[@id=\"column\"]/li'";
       self.baseImageUrlStr = @"http://www.momoshop.com.tw";
    }
    return self;
}

-(NSMutableArray *) searchWithKeyword:(NSString*)keyword {
    NSString* queryKeyword = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* queryStr = [NSString stringWithFormat:self.queryString,queryKeyword];
    
    NSDictionary *results = [self.yql query:queryStr];
    NSMutableArray* resAry = [[NSMutableArray alloc]init];
    
    if ( ![results[@"query"] isEqual:[NSNull null]] &&
         ![results[@"query"][@"results"] isEqual:[NSNull null]] &&
         ![results[@"query"][@"results"][@"li"] isEqual:[NSNull null]])
    {
        NSArray *itemAry = results[@"query"][@"results"][@"li"];
        
        for (NSDictionary *itemRaw in itemAry) {
            if (![itemRaw[@"p"] isEqual:[NSNull null]]&&
                ![itemRaw[@"p"][0] isEqual:[NSNull null]]&&
                ![itemRaw[@"a"] isEqual:[NSNull null]]&&
                ![itemRaw[@"a"][@"href"] isEqual:[NSNull null]]&&
                ![itemRaw[@"p"][1] isEqual:[NSNull null]] &&
                ![itemRaw[@"p"][1][@"span"] isEqual:[NSNull null]] &&
                [itemRaw[@"p"][1][@"span"] isKindOfClass:[NSArray class]]
                ) {
                
            SearchResultItem* searchResultItem = [[SearchResultItem alloc] init];
            searchResultItem.property = @"Momo";
            searchResultItem.title = itemRaw[@"p"][0][@"a"][@"title"];
            searchResultItem.url = itemRaw[@"a"][@"href"];
            searchResultItem.imageUrl = [[self.baseImageUrlStr copy] stringByAppendingString:itemRaw[@"a"][@"img"][@"src"]];
        
            searchResultItem.price =  [itemRaw[@"p"][1][@"span"][0][@"b"][@"content"] integerValue];
            searchResultItem.desc = @"";
            [resAry addObject:searchResultItem];
                }
        }
        
    }
    
    return resAry;
}


-(NSMutableArray *) searchWithKeyword_map:(NSString*)keyword {
    
    OHMMappable([MomoSearchResultItem_A class]);
    OHMMappable([MomoSearchResultItem class]);
    OHMSetMapping([MomoSearchResultItem class], @{
                                              @"p": @"p",
                                              @"a": @"a"
                                              });
    
    NSString* queryKeyword = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* queryStr = [NSString stringWithFormat:self.queryString,queryKeyword];
    NSDictionary *results = [self.yql query:queryStr];
    NSMutableArray* resAry = [[NSMutableArray alloc]init];

    if ( ![results[@"query"] isEqual:[NSNull null]] &&
        ![results[@"query"][@"results"] isEqual:[NSNull null]] &&
        ![results[@"query"][@"results"][@"li"] isEqual:[NSNull null]])
    {
        NSArray *itemAry = results[@"query"][@"results"][@"li"];
        
        for (NSDictionary *itemRaw in itemAry) {

            SearchResultItem* searchResultItem = [[SearchResultItem alloc] init];
            
            MomoSearchResultItem* momoItem = [[MomoSearchResultItem alloc] init];
            [momoItem setValuesForKeysWithDictionary:itemRaw];
            
            searchResultItem.property = @"Momo";
            searchResultItem.title = momoItem.p[0][@"a"][@"title"];
            searchResultItem.url = momoItem.a.href;
            searchResultItem.imageUrl = [[self.baseImageUrlStr copy] stringByAppendingString:momoItem.a.img[@"src"]];
            
            if ([momoItem.p[1][@"span"] isKindOfClass:[NSArray class]]) {
                searchResultItem.price =  [momoItem.p[1][@"span"][0][@"b"][@"content"] integerValue];
            }
            
            searchResultItem.desc = @"";
            [resAry addObject:searchResultItem];
        }
        
    }
    
    return resAry;
}

-(void) searchWithKeywordAsync:(NSString *)keyword completion: (void(^)(NSMutableArray *result, NSError *error))completion {
    
    dispatch_async(self.queryQueue, ^{
        
        NSMutableArray* resAry = [self searchWithKeyword_map:keyword];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            completion(resAry, nil);
        });
        
    });
}


@end
