//
//  SearchResultCell.m
//  ios-caa-ecSearch
//
//  Created by Carter Chang on 7/28/15.
//  Copyright (c) 2015 Carter Chang. All rights reserved.
//

#import "SearchResultCell.h"
#import <UIImageView+AFNetworking.h>

@interface SearchResultCell()
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *propertyLabel;

@end


@implementation SearchResultCell

- (void)awakeFromNib {
    // Initialization code
}

- (void) setSearchResultItem:(SearchResultItem*)item {
    self.titleLabel.text = item.title;
    self.descLabel.text = item.desc;
    self.propertyLabel.text = item.property;
    self.priceLabel.text =  [NSString stringWithFormat:@"$%ld",item.price];
    [self.thumbnailImageView setImageWithURL:[NSURL URLWithString:item.imageUrl]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.thumbnailImageView.image = nil;
}

@end
