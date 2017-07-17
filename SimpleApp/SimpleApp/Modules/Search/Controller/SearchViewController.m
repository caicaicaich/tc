//
//  SearchViewController.m
//  SimpleApp
//
//  Created by 蔡朝洪 on 2017/7/16.
//  Copyright © 2017年 leqoqo. All rights reserved.
//

#import "SearchViewController.h"
#import <RTRootNavigationController.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MBProgressHUD.h"
#import "SearchViewModel.h"
#import "NSString+isEmpty.h"
#import "SearchNetRespondBean.h"
#import "ListRequestDirectionEnum.h"
#import "SearchTableViewCell.h"
#import "MJRefresh.h"
#import "UIScrollView+Refresh.h"
#import "Simpletoast.h"
#import "GDNavigationViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import "Search.h"
#import "GlobalDataCacheForDisk.h"
#import "NSString+Helper.h"
#import "TTGTextTagCollectionView.h"


@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,TTGTextTagCollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchText;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (strong, nonatomic) SearchViewModel *searchViewModel;

@property (strong, nonatomic) MBProgressHUD *hud;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *searchArray;

@property (weak, nonatomic) IBOutlet UIView *historyView;

@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *historyTagView;

@property (weak, nonatomic) IBOutlet UIButton *clearHistoryButton;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *historyTagViewHeightConstraint;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    @weakify(self)
    self.searchViewModel = [[SearchViewModel alloc] init];
    
    
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 2.5, 30, 30)];
    rightView.image = [UIImage imageNamed:@"shouye_shousuo"];
    rightView.contentMode = UIViewContentModeCenter;
    self.searchText.leftView = rightView;
    self.searchText.leftViewMode = UITextFieldViewModeAlways;
    self.searchText.clearButtonMode = UITextFieldViewModeAlways;
    
    [self.searchButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.searchButton setBackgroundColor:[UIColor whiteColor]];
    [self.searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.historyView.hidden = NO;
    self.tableView.hidden = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchTableViewCell"];
    
    self.searchArray =  [GlobalDataCacheForDisk SearchHistory];
    
    self.historyTagView.delegate = self;
    self.historyTagView.showsVerticalScrollIndicator = YES;
    self.historyTagView.showsHorizontalScrollIndicator = NO;
    
    TTGTextTagConfig *config = self.historyTagView.defaultConfig;
    config.tagTextFont = [UIFont systemFontOfSize:14.0f];
    config.tagTextColor = [UIColor blackColor];
    config.tagSelectedTextColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    config.tagBackgroundColor = [UIColor whiteColor];
    config.tagSelectedBackgroundColor = [UIColor whiteColor];
    
    self.historyTagView.horizontalSpacing = 6.0;
    self.historyTagView.verticalSpacing = 8.0;
    
    config.tagBorderColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    config.tagSelectedBorderColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    config.tagBorderWidth = 1;
    config.tagSelectedBorderWidth = 1;
    
    config.tagShadowColor = [UIColor blackColor];
    config.tagShadowOffset = CGSizeMake(0, 0.3);
    config.tagShadowOpacity = 0.3f;
    config.tagShadowRadius = 0.5f;
    
    config.tagCornerRadius = 2;
    [self.historyTagView addTags:self.searchArray];
    self.historyTagView.alignment = TTGTagCollectionAlignmentLeft;
    [self.historyTagView reload];
    
    [RACObserve(self, searchArray) subscribeNext:^(id x) {
        @strongify(self)
        if (self.searchArray == nil || self.searchArray.count < 1) {
            self.clearHistoryButton.hidden = YES;
            self.lineView.hidden = YES;
        } else {
            self.clearHistoryButton.hidden = NO;
            self.lineView.hidden = NO;
        }
        
    }];
    
    [[self.clearHistoryButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        self.searchArray = [[NSArray alloc] init];
        [GlobalDataCacheForDisk setSearchHistory:self.searchArray];
        [self.historyTagView removeAllTags];
    }];
    
    
    
    [self.searchViewModel.requestSearchCommand.executing subscribeNext:^(NSNumber *executing) {
        if (executing.boolValue) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        } else {
            [self.hud hideAnimated:YES];
        }
    }];
    
    [self.searchViewModel.requestSearchCommand.executionSignals
     subscribeNext:^(RACSignal *execution) {
         [[execution dematerialize] subscribeNext:^(SearchNetRespondBean *respondBean) {
             @strongify(self)
             [self.tableView.mj_header endRefreshing];
             [self.tableView.mj_footer endRefreshing];
             [self.tableView reloadData];
             if (self.searchViewModel.isLastPage) {
                 [self.tableView.mj_footer setHidden:YES];
             } else {
                 [self.tableView.mj_footer setHidden:NO];
             }
             
         } error:^(NSError *error) {
             @strongify(self)
             [self.hud hideAnimated:YES];
             [self.tableView.mj_header endRefreshing];
             [self.tableView.mj_footer endRefreshing];
             // 错误提示
             [Simpletoast showWithText:error.localizedDescription duration:2.0f];
             
         }];
         
         
     }];
    //上拉加载更多
    [self.tableView addRefreshFooterCallback:^{
        @strongify(self)
        NSDictionary *requestDict = @{@"Direction":@(ListRequestDirectionEnum_LoadMore)};
        [self.searchViewModel.requestSearchCommand execute:requestDict];
    }];
    
    [[self.searchText rac_textSignal] subscribeNext:^(id x) {
        @strongify(self)
        if (self.searchText.text.trimSpaceAndEnter.length > 0) {
            [self.searchButton setBackgroundColor:[UIColor blueColor]];
            [self.searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.searchButton setTitle:@"搜索" forState:UIControlStateNormal];
            
        } else {
            [self.searchButton setTitle:@"取消" forState:UIControlStateNormal];
            [self.searchButton setBackgroundColor:[UIColor whiteColor]];
            [self.searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }];

    
    [[self.searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if ([self.searchButton.titleLabel.text isEqualToString:@"搜索"]) {
            self.historyView.hidden = YES;
            self.tableView.hidden = NO;
            self.searchViewModel.name = self.searchText.text.trimSpaceAndEnter;
            self.searchViewModel.latitude = [NSString stringWithFormat:@"%lf",self.latitude];
            self.searchViewModel.longitude = [NSString stringWithFormat:@"%lf",self.longitude];
            NSDictionary *requestDict = @{@"Direction":@(ListRequestDirectionEnum_Refresh)};
            [self.searchViewModel.requestSearchCommand execute:requestDict];
            if (self.searchArray == nil) {
                NSMutableArray *mutableSearchArray = [[NSMutableArray alloc] init];
                [mutableSearchArray addObject:self.searchText.text.trimSpaceAndEnter];
                self.searchArray =  [[NSArray alloc] initWithArray:mutableSearchArray];
            } else {
                NSMutableArray *mutableSearchArray = [[NSMutableArray alloc]  initWithArray:self.searchArray];
                if ([mutableSearchArray containsObject:self.searchText.text.trimSpaceAndEnter]) {
                    [mutableSearchArray removeObject:self.searchText.text.trimSpaceAndEnter];
                }
                [mutableSearchArray addObject:self.searchText.text.trimSpaceAndEnter];
                self.searchArray =  [[NSArray alloc] initWithArray:mutableSearchArray];
            }
            [GlobalDataCacheForDisk setSearchHistory:self.searchArray];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    }];
    
}

- (void)createUI {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.rt_navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchViewModel.searchArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SearchTableViewCell"];
    cell.searchModel = self.searchViewModel.searchArray[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Search *searchModel = self.searchViewModel.searchArray[indexPath.row];
    if (searchModel == nil) {
        return;
    }
    
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:self.latitude longitude:self.longitude];
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:searchModel.latitude longitude:searchModel.longitude];
    GDNavigationViewController *GDNavVc = [[GDNavigationViewController alloc] init];
    GDNavVc.startPoint = startPoint;
    GDNavVc.endPoint = endPoint;
    [self.navigationController pushViewController:GDNavVc animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
    
}

#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected {
    //_logLabel.text = [NSString stringWithFormat:@"Tap tag: %@, at: %ld, selected: %d", tagText, (long) index, selected];
    self.searchText.text = tagText;
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView updateContentSize:(CGSize)contentSize {
    //NSLog(@"text tag collection: %@ new content size: %@", textTagCollectionView, NSStringFromCGSize(contentSize));
    if (contentSize.height < [UIScreen mainScreen].bounds.size.height - 250) {
        self.historyTagViewHeightConstraint.constant = contentSize.height;
    }
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
