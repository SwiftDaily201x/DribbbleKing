//
//  ViewController.m
//  DribbbleKing
//
//  Created by Fnoz on 16/9/14.
//  Copyright © 2016年 Fnoz. All rights reserved.
//

#import "ViewController.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "NotiHandle.h"
#import "AFNetworking.h"
#import "ONOXMLDocument.h"
#import "RssItem.h"
#import "RssItemCell.h"
#import "ConstDef.h"
#import "YYWebImage.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) RssItem *selectedItem;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *selectTitleLabel;
@property (nonatomic, strong) UIButton *refreshBtn;
@property (nonatomic, strong) UIButton *biongBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //界面相关
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.selectTitleLabel];
    [self.view addSubview:self.refreshBtn];
    [self.view addSubview:self.biongBtn];
    
    //数据相关
    [self refreshItems];
    
    //授权相关
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"wbtoken"]) {
        [self getAuth];
    }
}

#pragma mark - UIElement
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [_tableView registerClass:[RssItemCell class] forCellReuseIdentifier:NSStringFromClass([RssItemCell class])];
    }
    return _tableView;
}

- (UILabel *)selectTitleLabel {
    if (!_selectTitleLabel) {
        _selectTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 65, SCREEN_WIDTH, 50)];
        _selectTitleLabel.textColor = [UIColor whiteColor];
        _selectTitleLabel.font = [UIFont systemFontOfSize:17];
        _selectTitleLabel.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    }
    return _selectTitleLabel;
}

- (UIButton *)refreshBtn {
    if (!_refreshBtn) {
        _refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 110, SCREEN_HEIGHT - 60, 40, 40)];
        _refreshBtn.backgroundColor = [UIColor orangeColor];
        _refreshBtn.layer.cornerRadius = 20;
        [_refreshBtn addTarget:self action:@selector(refreshItems) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshBtn;
}

- (UIButton *)biongBtn {
    if (!_biongBtn) {
        _biongBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 60, 40, 40)];
        _biongBtn.backgroundColor = [UIColor greenColor];
        _biongBtn.layer.cornerRadius = 20;
        [_biongBtn addTarget:self action:@selector(biong) forControlEvents:UIControlEventTouchUpInside];
    }
    return _biongBtn;
}

#pragma mark - Action
- (void)refreshItems {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer new]];
    self.refreshBtn.alpha = 0.5;
    self.refreshBtn.userInteractionEnabled = NO;
    [manager GET:@"https://dribbble.com/shots/popular.rss" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             self.refreshBtn.alpha = 1;
             self.refreshBtn.userInteractionEnabled = YES;
             ONOXMLDocument *xmlDoc = [ONOXMLDocument XMLDocumentWithData:responseObject error:nil];
             ONOXMLElement *rootElement = [xmlDoc rootElement];
             ONOXMLElement *channelElement = [rootElement childrenWithTag:@"channel"][0];
             NSArray *itemXmlArray = [channelElement childrenWithTag:@"item"];
             _itemArray = [NSMutableArray array];
             for (ONOXMLElement *ele in itemXmlArray) {
                 RssItem *item = [[RssItem alloc] initWithWithXMLElement:ele];
                 if ([item.imageUrl rangeOfString:@".gif"].location != NSNotFound) {
                     [_itemArray addObject:item];
                 }
             }
             
             [self.tableView reloadData];
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             self.refreshBtn.alpha = 1;
             self.refreshBtn.userInteractionEnabled = YES;
             NSLog(@"%@",error);  //这里打印错误信息
             
         }];
}

- (void)getAuth {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"http://www.sina.com";
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)setSelectedItem:(RssItem *)selectedItem {
    _selectedItem = selectedItem;
    self.selectTitleLabel.text = [NSString stringWithFormat:@"  %@", selectedItem.authorName];
}

- (void)biong
{
    if (!self.selectedItem) {
        [NotiHandle showNoti:@"No Item" isSuccess:NO];
        return;
    }
    self.biongBtn.alpha = 0.5;
    self.biongBtn.userInteractionEnabled = NO;
    WBImageObject *image = [WBImageObject object];
    image.imageData = [[YYImageCache sharedCache] getImageDataForKey:self.selectedItem.imageUrl];
    
    NSString *content = [NSString stringWithFormat:@"#每日动效# 【%@】，作者：%@，%@", self.selectedItem.title, self.selectedItem.authorName, self.selectedItem.link];
    [WBHttpRequest requestForShareAStatus:content contatinsAPicture:image orPictureUrl:nil withAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"wbtoken"] andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        self.biongBtn.alpha = 1;
        self.biongBtn.userInteractionEnabled = YES;;
        if (!error) {
            [NotiHandle showNoti:@"Succeed" isSuccess:YES];
        }
        else {
            [NotiHandle showNoti:@"Fail" isSuccess:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getAuth];
            });
        }
        
    }];
}

#pragma mark - UITableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.bounds.size.width * 0.75;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RssItemCell *cell = (RssItemCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RssItemCell class])];
    if (cell == nil)
    {
        cell = [[RssItemCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: NSStringFromClass([RssItemCell class])];
    }
    [cell loadItem:_itemArray[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RssItem *item = _itemArray[indexPath.row];
    self.selectedItem = item;
}

@end
