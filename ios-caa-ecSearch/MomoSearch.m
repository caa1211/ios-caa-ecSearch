//
//  MomoSearch.m
//  ios-caa-ecSearch
//
//  Created by Carter Chang on 7/29/15.
//  Copyright (c) 2015 Carter Chang. All rights reserved.
//

#import "MomoSearch.h"


@implementation MomoSearch

-(NSString *) propertyName {
    return @"Momo";
}

-(NSMutableArray *) searchWithKeyword:(NSString*)keyword {
    NSMutableArray *resAry = [[NSMutableArray alloc]init];
    
    // Fetch html doc
    NSString* queryKeyword =[keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url =[NSString stringWithFormat:@"http://www.momoshop.com.tw/mosearch/%@.html",queryKeyword];
    NSError *err = nil;
    NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&err];
    if(err) {
        return resAry;
    }
    
    // Parse dom tree
    OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:html];
    OCQueryObject *lis = doc.Query(@"ul#column").children(@"li");
    
    for(OCGumboElement *li in lis){
        SearchResultItem *item = [[SearchResultItem alloc] initWithPropertyName:self.propertyName];
        
        OCQueryObject *aTag = li.Query(@"#goods_name").children(@"a");
        if (aTag.count == 1)
        {
            item.url = aTag.first().attr(@"href");
            item.title = aTag.first().text();
        }
        
        OCQueryObject *discountPrice = li.Query(@"p.discountPrice");
        OCQueryObject *priceTag = discountPrice.find(@".money").children(@"b");
        if (priceTag.count == 1) {
            item.price = [priceTag.first().text() integerValue];
        }
        
        OCQueryObject *imgTag = li.Query(@"a").children(@"img");
        if (imgTag.count == 1) {
            NSString *baseImageUrlStr = @"http://www.momoshop.com.tw";
            NSString *url = [baseImageUrlStr stringByAppendingString:imgTag.first().attr(@"src")];
            item.imageUrl = url;
        }
        
        [resAry addObject:item];
    }
    
    return resAry;
}


@end
