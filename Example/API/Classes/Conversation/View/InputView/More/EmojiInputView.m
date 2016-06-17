//
//  EmojiInputView.m
//  API
//
//  Created by ShingHo on 16/4/8.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "EmojiInputView.h"

@interface EmojiInputView()<UICollectionViewDelegate,UICollectionViewDataSource>

//@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, strong) NSArray *emojiArr;
@end

@implementation EmojiInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"E3EFEF"];
        [self addSubview:self.pageControl];
        [self addSubview:self.sendBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - ———— UICollectionView ———— -


#pragma mark - ———— DataSource ———— -
- (void)getEmojiData
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"];
    self.emojiArr = [NSArray arrayWithContentsOfFile:plistPath];
    
}

#pragma mark - ———— Action ———— -
//- (void)pageControlTouched:(UIPageControl *)sender {
//    CGRect bounds = self.scrollView.bounds;
//    bounds.origin.x = CGRectGetWidth(bounds) * sender.currentPage;
//    bounds.origin.y = 0;
//    [self.scrollView scrollRectToVisible:bounds animated:YES];
//}

#pragma mark - ———— getter ———— -

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        layout.itemSize = CGSizeMake(15, 15);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPage = 0;
        _pageControl.backgroundColor = [UIColor blackColor];
        [_pageControl addTarget:self action:@selector(pageControlTouched:) forControlEvents:UIControlEventValueChanged];
        _pageControl.height = 10;
        _pageControl.width = 20;
        _pageControl.center = CGPointMake(self.bounds.size.height-5, self.bounds.size.width/2);
        
    }
    return _pageControl;
}

- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _sendBtn.tag = 1000;
        _sendBtn.backgroundColor = [UIColor whiteColor];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(btnClick:) forControlEvents:1<<6];
        _sendBtn.right = self.bounds.size.width- 65;
        _sendBtn.width = 60;
        _sendBtn.height = 30;
        _sendBtn.bottom = self.bounds.size.height - 5;
    }
    return _sendBtn;
}

@end
