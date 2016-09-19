
//
//  RssItemCell.m
//  DribbbleKing
//
//  Created by Fnoz on 16/9/16.
//  Copyright © 2016年 Fnoz. All rights reserved.
//

#import "RssItemCell.h"
#import "ConstDef.h"
#import "UIImageView+WebCache.h"
#import "FFCircularProgressView.h"

@interface RssItemCell ()

@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) FFCircularProgressView *progressView;
@property (nonatomic, strong) UILabel *mainTextLabel;

@end

@implementation RssItemCell

- (void)dealloc {
    [self.mainImageView sd_cancelCurrentImageLoad];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.mainImageView];
        [self.contentView addSubview:self.progressView];
        [self.contentView addSubview:self.mainTextLabel];
    }
    return self;
}

- (UIImageView *)mainImageView {
    if (!_mainImageView) {
        _mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.75)];
    }
    return _mainImageView;
}

- (FFCircularProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[FFCircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _progressView.center = _mainImageView.center;
    }
    return _progressView;
}

- (UILabel *)mainTextLabel {
    if (!_mainTextLabel) {
        _mainTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH * 0.75 - 30, SCREEN_WIDTH, 30)];
        _mainTextLabel.textColor = [UIColor colorWithRed:155 / 255.0 green:89 / 255.0 blue:182 / 255.0 alpha:1];
        _mainTextLabel.font = [UIFont systemFontOfSize:17];
        _mainTextLabel.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    }
    return _mainTextLabel;
}

- (void)loadItem:(RssItem *)item {
    self.item = item;
    self.mainTextLabel.text = [NSString stringWithFormat:@"  [%@]  %@", item.authorName, item.title];
    _progressView.hidden = YES;
}

- (void)loadGif {
    _progressView.hidden = NO;
    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.item.imageUrl]
                          placeholderImage:nil
                                   options:0
                                  progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                      if (expectedSize > 0) {
                                          self.progressView.progress = receivedSize * 1.0 / expectedSize;
                                      }
                                  }
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     self.progressView.hidden = YES;
                                  }];
}

@end
