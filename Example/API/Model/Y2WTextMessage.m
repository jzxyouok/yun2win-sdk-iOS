//
//  Y2WTextMessage.m
//  API
//
//  Created by ShingHo on 16/4/7.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WTextMessage.h"

@implementation Y2WTextMessage

- (void)updateWithDict:(NSDictionary *)dict {
    [super updateWithDict:dict];
    id content = dict[@"content"];
    if ([content isKindOfClass:[NSString class]]) {
        content = [dict[@"content"] parseJsonString];
    }
    
    if ([content isKindOfClass:[NSDictionary class]]) {
        self.content = content;
        
    }else if ([content isKindOfClass:[NSString class]]) {
        self.content = @{@"text": content};
        
    }else {
        self.content = @{@"text": dict[@"content"]};
    }
    self.text = self.content[@"text"];
}


@end
