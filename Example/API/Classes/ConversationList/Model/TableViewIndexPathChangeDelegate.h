//
//  TableViewIndexPathChangeDelegate.h
//  API
//
//  Created by QS on 16/4/1.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TableViewIndexPathChangeType) {
    TableViewIndexPathChangeInsert = 1,
    TableViewIndexPathChangeDelete = 2,
    TableViewIndexPathChangeMove = 3,
    TableViewIndexPathChangeUpdate = 4
};

@protocol TableViewIndexPathChangeDelegate <NSObject>

- (void)tableViewIndexPathWillChangeContent:(id)manager;

- (void)tableViewIndexPathManager:(id)manager
                      atIndexPath:(NSIndexPath *)indexPath
                     newIndexPath:(NSIndexPath *)newIndexPath
                    forChangeType:(TableViewIndexPathChangeType)type;

- (void)tableViewIndexPathDidChangeContent:(id)manager;

@end
