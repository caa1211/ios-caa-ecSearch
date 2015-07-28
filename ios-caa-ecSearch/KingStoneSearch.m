//
//  KingStoneSearch.m
//  ios-caa-ecSearch
//
//  Created by Ray Chiang on 2015/7/28.
//  Copyright (c) 2015年 Carter Chang. All rights reserved.
//

#import "KingStoneSearch.h"
#import "YQL.h"

@interface KingStoneSearch ()
@property (strong, nonatomic) NSMutableArray *result;
@property(nonatomic, strong) YQL* yql;
@property(strong, nonatomic) dispatch_queue_t queryQueue;
@property(nonatomic, strong) NSString *baseImageUrlStr;
@property(nonatomic, strong) NSString *queryString;
@end

@implementation KingStoneSearch

-(id)init {
    self = [super init];
    if(self){
        self.yql = [[YQL alloc]init];
        self.queryQueue = dispatch_queue_create("kingstone_queue", nil);
        self.queryString = @"select * from html where url='http://www.kingstone.com.tw/search/result.asp?c_name=%@' and xpath='//div[@id=\"mainContent\"]/div/div/ul/li'";
    }
    return self;
}

-(NSMutableArray *) searchWithKeyword:(NSString*)keyword {
    NSString* queryKeyword = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* queryStr = [NSString stringWithFormat:self.queryString,queryKeyword];
    
    NSDictionary *results = [self.yql query:queryStr];
    NSMutableArray* resAry = [[NSMutableArray alloc]init];
    
    if (![results[@"query"] isEqual:[NSNull null]] &&
        ![results[@"query"][@"results"] isEqual:[NSNull null]] &&
        ![results[@"query"][@"results"][@"li"] isEqual:[NSNull null]])
    {
        NSArray *itemAry = results[@"query"][@"results"][@"li"];
        NSString *title;
        NSString *imageUrl;
        NSString *url;
        NSString *desc;
        NSInteger price = 0;
        
        for (NSDictionary *itemRaw in itemAry) {
            // get title, imageUrl, url
            if (![itemRaw[@"a"] isEqual:[NSNull null]]) {
                if (![itemRaw[@"a"][@"title"] isEqual:[NSNull null]]) {
                    title = itemRaw[@"a"][@"title"];
                }
                if (![itemRaw[@"a"][@"img"] isEqual:[NSNull null]] &&
                    ![itemRaw[@"a"][@"img"][@"src"] isEqual:[NSNull null]]) {
                    imageUrl = itemRaw[@"a"][@"img"][@"src"];
                }
                if (![itemRaw[@"a"][@"href"] isEqual:[NSNull null]]) {
                    url = itemRaw[@"a"][@"href"];
                }
            }
            // get desc
            if (![itemRaw[@"p"] isEqual:[NSNull null]] &&
                ![itemRaw[@"p"][1] isEqual:[NSNull null]]) {
                desc = itemRaw[@"p"][1];
            }
            // get price
            if (![itemRaw[@"span"] isEqual:[NSNull null]] &&
                [itemRaw[@"span"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *span in itemRaw[@"span"]) {
                    if (![span[@"span"] isEqual:[NSNull null]] &&
                        [span[@"span"] isKindOfClass:[NSArray class]] &&
                        ![span[@"span"][1] isEqual:[NSNull null]] &&
                        ![span[@"span"][1][@"em"] isEqual:[NSNull null]]
                        ) {
                        price = [span[@"span"][1][@"em"] integerValue];
                        break;
                    }
                }
            }
            
            // if title and price exists, add this item
            if (![title isEqual:[NSNull null]] &&
                price > 0) {
                SearchResultItem* searchResultItem = [[SearchResultItem alloc] init];
                searchResultItem.property = @"KingStone";
                searchResultItem.title = title;
                searchResultItem.url = url;
                searchResultItem.imageUrl = imageUrl;
                searchResultItem.price = price;
                searchResultItem.desc = desc;
                [resAry addObject:searchResultItem];
            }
        }
        
    }
    
    return resAry;
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
