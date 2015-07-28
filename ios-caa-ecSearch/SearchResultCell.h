//
//  SearchResultCell.h
//  ios-caa-ecSearch
//
//  Created by Carter Chang on 7/28/15.
//  Copyright (c) 2015 Carter Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultItem.h"

@interface SearchResultCell : UITableViewCell
    @property (strong, nonatomic) SearchResultItem *searchResultItem;
@end
