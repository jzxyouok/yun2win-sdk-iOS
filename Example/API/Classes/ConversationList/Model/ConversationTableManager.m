//
//  ConversationTableManager.m
//  API
//
//  Created by QS on 16/4/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "ConversationTableManager.h"

@interface ConversationTableManager ()<Y2WUserConversationsDelegate>

@property (nonatomic, retain) Y2WUserConversations *userConversations;

@property (nonatomic, retain) NSMutableArray *reloadDatas;

@end


@implementation ConversationTableManager {
    NSMutableArray *newConversationDatas;
}

- (void)dealloc {
    [self.userConversations removeDelegate:self];
}

- (instancetype)init {
    if (self = [super init]) {
        self.conversationDatas = [NSMutableArray array];
        self.reloadDatas = [NSMutableArray array];

        [self.userConversations addDelegate:self];
    }
    return self;
}





#pragma mark - ———— Y2WUserConversationsDelegate ———— -

- (void)userConversationsWillChangeContent:(Y2WUserConversations *)userConversations {
    [self.reloadDatas removeAllObjects];
    
    newConversationDatas = [self.conversationDatas mutableCopy];
}

- (void)userConversations:(Y2WUserConversations *)userConversations onAddUserConversation:(Y2WUserConversation *)userConversation {
    
    for (Y2WUserConversation *conversation in newConversationDatas) {
        if ([conversation isEqual:userConversation]) {
            return;
        }
    }
    [newConversationDatas addObject:userConversation];
}

- (void)userConversations:(Y2WUserConversations *)userConversations onDeleteUserConversation:(Y2WUserConversation *)userConversation {
    
    for (Y2WUserConversation *conversation in newConversationDatas) {
        if ([conversation isEqual:userConversation]) {
            
            [newConversationDatas removeObject:conversation];
            return;
        }
    }
}

- (void)userConversations:(Y2WUserConversations *)userConversations onUpdateUserConversation:(Y2WUserConversation *)userConversation {
    for (Y2WUserConversation *conversation in newConversationDatas) {
        if ([conversation isEqual:userConversation]) {
  
            [self.reloadDatas addObject:userConversation];
            return;
        }
    }
}

- (void)userConversationsDidChangeContent:(Y2WUserConversations *)userConversations {
    
    // 排序
    [newConversationDatas sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"top" ascending:NO],
                                                 [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]]];
    
    NSArray *insertIndexPaths = [self getInsertIndexPaths];
    NSArray *deleteIndexPaths = [self getDeleteIndexPaths];
    NSArray *reloadIndexPaths = [self getReloadIndexPaths];
    
    
    NSMutableDictionary *oldIndexPaths = [NSMutableDictionary dictionary];
    [self.conversationDatas enumerateObjectsUsingBlock:^(Y2WUserConversation *conversation, NSUInteger idx, BOOL * _Nonnull stop) {
        oldIndexPaths[conversation.userConversationId] = [NSIndexPath indexPathForRow:idx inSection:0];
    }];
    
    NSMutableDictionary *newIndexPaths = [NSMutableDictionary dictionary];
    [newConversationDatas enumerateObjectsUsingBlock:^(Y2WUserConversation *conversation, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *oldIndexPath = oldIndexPaths[conversation.userConversationId];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];

        if (oldIndexPath) newIndexPaths[conversation.userConversationId] = newIndexPath;
    }];
    
    
    self.conversationDatas = newConversationDatas;
    newConversationDatas = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{

        if ([self.delegate respondsToSelector:@selector(tableViewIndexPathWillChangeContent:)]) {
            [self.delegate tableViewIndexPathWillChangeContent:self];
        }
        
        for (NSIndexPath *indexPath in insertIndexPaths) {
            if ([self.delegate respondsToSelector:@selector(tableViewIndexPathManager:atIndexPath:newIndexPath:forChangeType:)]) {
                [self.delegate tableViewIndexPathManager:self atIndexPath:nil newIndexPath:indexPath forChangeType:TableViewIndexPathChangeInsert];
            }
        }
        
        for (NSIndexPath *indexPath in deleteIndexPaths) {
            if ([self.delegate respondsToSelector:@selector(tableViewIndexPathManager:atIndexPath:newIndexPath:forChangeType:)]) {
                [self.delegate tableViewIndexPathManager:self atIndexPath:indexPath newIndexPath:nil forChangeType:TableViewIndexPathChangeDelete];
            }
        }
        
        for (id obj in newConversationDatas) {
            NSIndexPath *oldIndexPath = oldIndexPaths[obj];
            NSIndexPath *newIndexPath = newIndexPaths[obj];
            if (newIndexPath) {
                if ([self.delegate respondsToSelector:@selector(tableViewIndexPathManager:atIndexPath:newIndexPath:forChangeType:)]) {
                    [self.delegate tableViewIndexPathManager:self atIndexPath:oldIndexPath newIndexPath:newIndexPath forChangeType:TableViewIndexPathChangeMove];
                }
            }
        }
        
        for (NSIndexPath *indexPath in reloadIndexPaths) {
            if ([self.delegate respondsToSelector:@selector(tableViewIndexPathManager:atIndexPath:newIndexPath:forChangeType:)]) {
                [self.delegate tableViewIndexPathManager:self atIndexPath:indexPath newIndexPath:nil forChangeType:TableViewIndexPathChangeUpdate];
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(tableViewIndexPathDidChangeContent:)]) {
            [self.delegate tableViewIndexPathDidChangeContent:self];
        }
    });
}







#pragma mark - ———— Helper ———— -

- (NSArray *)getInsertIndexPaths {
    
    return [[newConversationDatas qs_mapObjectsUsingBlock:^id(id obj, NSUInteger index) {
        if ([self.conversationDatas indexOfObject:obj] == NSNotFound) {
            return [NSIndexPath indexPathForRow:index inSection:0];
        };
        return [NSNull null];
    }] qs_compact];
}

- (NSArray *)getDeleteIndexPaths {
    
    return [[self.conversationDatas qs_mapObjectsUsingBlock:^id(id obj, NSUInteger index) {
        if ([newConversationDatas indexOfObject:obj] == NSNotFound) {
            return [NSIndexPath indexPathForRow:index inSection:0];
        };
        return [NSNull null];
    }] qs_compact];
}

- (NSArray *)getReloadIndexPaths {
    
    return [[self.reloadDatas qs_mapObjectsUsingBlock:^id(id obj, NSUInteger index) {
        if ([newConversationDatas indexOfObject:obj] != NSNotFound) {
            return [NSIndexPath indexPathForRow:index inSection:0];
        };
        return [NSNull null];
    }] qs_compact];
}





#pragma mark - ———— getter ———— -

- (Y2WUserConversations *)userConversations {
    
    if (!_userConversations) {
        _userConversations = [Y2WUsers getInstance].getCurrentUser.userConversations;
    }
    return _userConversations;
}

@end
