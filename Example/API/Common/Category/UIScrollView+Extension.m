//
//  UIScrollView+Extension.m
//  API
//
//  Created by QS on 16/3/16.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "UIScrollView+Extension.h"

@implementation UIScrollView (Extension)

- (void)scrollToTop:(BOOL)animation {
    
    CGPoint offset = CGPointMake(0, 0);
    [self setContentOffset:offset animated:animation];
}

- (void)scrollToBottom:(BOOL)animation {
    
    if (self.contentSize.height + self.contentInset.top > self.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.contentSize.height - self.frame.size.height);
        [self setContentOffset:offset animated:animation];
    }
}

@end
