//
//  KSSearch.m
//  ios-caa-ecSearch
//
//  Created by Carter Chang on 7/29/15.
//  Copyright (c) 2015 Carter Chang. All rights reserved.
//

#import "KSSearch.h"

@implementation KSSearch

-(NSString *) propertyName {
    return @"KingStone";
}

-(NSMutableArray *) searchWithKeyword:(NSString*)keyword {
    
    NSMutableArray* resAry = [[NSMutableArray alloc]init];
    
    // Fetch html doc
    NSString* queryKeyword =[keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url =[NSString stringWithFormat:@"http://www.kingstone.com.tw/search/result.asp?c_name=%@",queryKeyword];
    NSError *err = nil;
    NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&err];
    
    if(err) {
        return resAry;
    }
    
    // Parse dom tree
    OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:html];
    OCQueryObject *lis = doc.Query(@".row_list").children(@"ul").children(@"li");
    
    for(OCGumboElement *li in lis){
        SearchResultItem *item = [[SearchResultItem alloc] initWithPropertyName:self.propertyName];
        
        OCQueryObject *priceTag = li.Query(@".sale_price").children(@"em");
        if (priceTag.count == 1) {
            item.price = [priceTag.first().text() integerValue];
        }
        
        OCQueryObject *anchorTag = li.Query(@"a.anchor");
        if (priceTag.count == 1) {
            item.title = anchorTag.first().attr(@"title");
            
            NSString *baseUrlStr = @"http://www.kingstone.com.tw";
            item.url = [baseUrlStr stringByAppendingString:anchorTag.first().attr(@"href")];
        }
        
        OCQueryObject *imgTag = anchorTag.children(@"img");
        if (imgTag.count == 1) {
            //NSString *baseUrlStr = @"http://www.kingstone.com.tw";
            item.imageUrl = imgTag.first().attr(@"src");
        }
        
        OCQueryObject *pTag = li.Query(@"p");
        
        NSString *dec = [pTag.text() stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        dec = [dec stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        item.desc = dec;
        
        item.property = self.propertyName;
        
        [resAry addObject:item];
    }
    return resAry;
}

@end
