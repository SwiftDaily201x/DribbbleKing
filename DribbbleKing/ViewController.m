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

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableArray *selectedItemArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //界面相关
    [self.view addSubview:self.tableView];
    
    //数据相关
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer new]];
    [manager GET:@"https://dribbble.com/shots/popular.rss" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
             
             NSLog(@"这里打印请求成功要做的事");
             [self.tableView reloadData];
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             
             NSLog(@"%@",error);  //这里打印错误信息
             
         }];
    
    //授权相关
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"wbtoken"]) {
        [self getAuth];
    }
    
    UIButton *biongBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 60, 40, 40)];
    biongBtn.backgroundColor = [UIColor greenColor];
    biongBtn.layer.cornerRadius = 20;
    [biongBtn addTarget:self action:@selector(biong) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:biongBtn];
    
}

#pragma mark - UIElement {
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

- (void)biong
{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBImageObject *image = [WBImageObject object];
    image.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://bbsimg.ali213.net/data/attachment/forum/201311/05/21224633iguo4a2a3l6uza.gif"]];
    
    [WBHttpRequest requestForShareAStatus:@"test" contatinsAPicture:image orPictureUrl:nil withAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"wbtoken"] andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        
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

#pragma mark - tableviewdatasource
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


#pragma mark - tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
