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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"wbtoken"]) {
        [self getAuth];
    }
    
    UIButton *biongBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    biongBtn.backgroundColor = [UIColor greenColor];
    biongBtn.center = self.view.center;
    [biongBtn addTarget:self action:@selector(biong) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:biongBtn];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
