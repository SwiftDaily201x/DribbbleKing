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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"http://www.sina.com";
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self biong];
    });
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)biong
{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBImageObject *image = [WBImageObject object];
    image.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://bbsimg.ali213.net/data/attachment/forum/201311/05/21224633iguo4a2a3l6uza.gif"]];
    
    [WBHttpRequest requestForShareAStatus:@"test" contatinsAPicture:image orPictureUrl:nil withAccessToken:myDelegate.wbtoken andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        
        DemoRequestHanlder(httpRequest, result, error);
        
    }];
}

void DemoRequestHanlder(WBHttpRequest *httpRequest, id result, NSError *error)
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    if (error)
    {
        title = NSLocalizedString(@"失败", nil);
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:[NSString stringWithFormat:@"%@",error]
                                          delegate:nil
                                 cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                 otherButtonTitles:nil];
    }
    else
    {
        title = NSLocalizedString(@"成功", nil);
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:nil
                                          delegate:nil
                                 cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                 otherButtonTitles:nil];
    }
    
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
