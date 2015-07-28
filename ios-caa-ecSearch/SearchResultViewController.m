//
//  SearchResultViewController.m
//  ios-caa-ecSearch
//
//  Created by Carter Chang on 7/27/15.
//  Copyright (c) 2015 Carter Chang. All rights reserved.
//

#import "SearchResultViewController.h"
#import "MomoSearch.h"
#import "PcHomeSearch.h"
#import "KingStoneSearch.h"
#import "SearchResultCell.h"

@interface SearchResultViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong ,nonatomic) NSMutableArray* searchResultItems;
@property (nonatomic, strong) NSTimer *searchDelayer;
@property (nonatomic, strong) NSMutableIndexSet *ecPropertySet;

@end

typedef enum ECPROPERTY : NSInteger {
    ECPROPERTY_MOMO=0,
    ECPROPERTY_PCHOME24,
    ECPROPERTY_KINGSTONE
}EFFECT_MODE;


@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"EC Search";
    
    self.searchResultItems = [[NSMutableArray alloc]init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self setupSearchBar];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchResultCell" bundle:nil] forCellReuseIdentifier:@"SearchResultCell"]; 
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCell"];
    
    self.ecPropertySet = [[NSMutableIndexSet alloc] init];
    
    [self.ecPropertySet addIndex:ECPROPERTY_MOMO];
    [self.ecPropertySet addIndex:ECPROPERTY_PCHOME24];
    [self.ecPropertySet addIndex:ECPROPERTY_KINGSTONE];
    
    self.searchBar.text =@"iphone 6";
    [self doQuery:self.searchBar.text];
}

-(void)setupSearchBar {
    self.searchBar.translucent = NO;
    self.searchBar.placeholder = @"Production name";
    self.searchBar.delegate = self;
    
    // Change the title of cancel button to ">"
    [self.searchBar setShowsCancelButton:YES animated:NO];
    UIView* view=self.searchBar.subviews[0];
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton*)subView;
            [cancelButton setTitle:@">" forState:UIControlStateNormal];
        }
    }
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.searchDelayer invalidate];
    self.searchDelayer = nil;
    self.searchDelayer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                          target:self
                                                        selector:@selector(doDelayedSearch)
                                                        userInfo:searchText
                                                         repeats:NO];
}

-(void) doDelayedSearch {
    NSLog(@"do search: %@", self.searchBar.text);
    [self doQuery:self.searchBar.text];
    self.searchDelayer = nil;
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //[self fetchBusinessesWithQuery:self.searchBar.text params:self.filters];
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    //self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}


- (void) doQuery:(NSString*) keyword {
    [self.searchResultItems removeAllObjects];
    
    if ([self.ecPropertySet containsIndex:ECPROPERTY_MOMO]) {
        //Momo
        ECSearch *momoSearch = [[MomoSearch alloc] init];
        [momoSearch searchWithKeywordAsync:keyword completion:^(NSMutableArray *result, NSError *error) {
            if (error == nil) {
                [self.searchResultItems addObjectsFromArray:result];
                // Sort
                [self.tableView reloadData];
            }
        }];
    }
    
    if ([self.ecPropertySet containsIndex:ECPROPERTY_PCHOME24]) {
        //PCHome
        ECSearch *pcHomeSearch = [[PcHomeSearch alloc] init];
        [pcHomeSearch searchWithKeywordAsync:keyword completion:^(NSMutableArray *result, NSError *error) {
            if (error == nil) {
                [self.searchResultItems addObjectsFromArray:result];
                // Sort
                [self.tableView reloadData];
            }
        }];
    }

    if ([self.ecPropertySet containsIndex:ECPROPERTY_KINGSTONE]) {
        //KingStone
        ECSearch *kingStoneSearch = [[KingStoneSearch alloc] init];
        [kingStoneSearch searchWithKeywordAsync:keyword completion:^(NSMutableArray *result, NSError *error) {
            if (error == nil) {
                [self.searchResultItems addObjectsFromArray:result];
                // Sort
                [self.tableView reloadData];
            }
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResultItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell" forIndexPath:indexPath];
    //    cell.backgroundColor = tableView.backgroundColor;
    //    cell.textLabel.text = item.title;
    //    cell.textLabel.font = [UIFont systemFontOfSize:18];
    //    cell.textLabel.textColor = [UIColor colorWithRed:0.335 green:0.632 blue:0.916 alpha:1.000];
    //
    
    SearchResultItem *item = self.searchResultItems[indexPath.row];
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    cell.searchResultItem = item;
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void) adjustTableHeight {
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
