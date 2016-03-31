//
//  Y2WSession.m
//  API
//
//  Created by ShingHo on 16/3/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "Y2WSession.h"

@implementation Y2WSession

- (instancetype)initWithSessions:(Y2WSessions *)sessions dict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _sessions  = sessions;
        _sessionId = dict[@"id"];
        _type      = dict[@"type"];
        _name      = dict[@"name"];
        _avatarUrl = dict[@"avatarUrl"];
        _createMTS = dict[@"createMTS"];
        _updateMTS = dict[@"updateMTS"];
        _createdAt = dict[@"createdAt"];
        _updatedAt = dict[@"updatedAt"];
        
        _messages = [[Y2WMessages alloc] initWithSession:self];
        _members = [[Y2WSessionMembers alloc] initWithSession:self];
    }
    return self;
}

- (void)updateWithSession:(Y2WSession *)session {
    _sessions  = session.sessions;
    _sessionId = session.sessionId;
    _type      = session.type;
    _name      = session.name;
    _avatarUrl = session.avatarUrl;
    _createMTS = session.createMTS;
    _updateMTS = session.updateMTS;
    _createdAt = session.createdAt;
    _updatedAt = session.updatedAt;
}

@end
