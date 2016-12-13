//
//  SearchViewController.m
//  YUMMY
//
//  Created by Đinh Quân on 10/20/16.
//  Copyright © 2016 Đinh Quân. All rights reserved.
//

#import "SearchViewController.h"
#import "AFNetworking.h"
#import "baseUrl.h"
#import "suggestTableViewCell.h"
#import "LoaicongthucObject.h"

@interface SearchViewController () {
    NSMutableArray *loaiCongthucObjects;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    //set ảnh cho nút của tab hiện tại ở tabbar
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"searchTabbarButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"searchTabbarButton-Active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(6.0, 0.0, -6.0, 0.0);
    */
    //self.tableView.delegate = self;
    //self.tableView.dataSource = self;
    //self.searchBar.delegate = self;
    
    //status bar color update
    [self setNeedsStatusBarAppearanceUpdate];
    
    //search bar style
    [self.searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    
    //table view style
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    
    
    //để cuối hàm!!!
    //self.tabBarController.selectedIndex = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - ẩn navigation bar
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

#pragma mark - hiện lại navigation bar khi sang view controller tiếp theo
- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
*/
#pragma mark - set statusbar style ~ bởi đã đăng ký mặc định light style trong info.plist
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - serach bar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    //khi bắt đầu edit, các suggest ban đầu sẽ biến mất
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //khi text trong search bar được thay đổi, tìm kiếm luôn
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    //hiện dữ liệu tìm kiếm theo text trong search bar
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setText:nil];
    
}

#pragma mark - Tableview DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //chia 2 trường hợp với sugest cell và result cell
    
    
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    UITableViewCell *cell;
    //UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:<#(nonnull NSString *)#> forIndexPath:<#(nonnull NSIndexPath *)#>];
    return  cell;
}

@end
