//
//  ConversationViewController.m
//  API
//
//  Created by ShingHo on 16/1/22.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "ConversationViewController.h"
#import "GroupViewController.h"
#import "MessageCell.h"
#import "MessageNotiCell.h"
#import "InputView.h"

@interface ConversationViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
InputViewUIDelegate,
InputViewActionDelegate,
InputViewMoreDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
Y2WMessagesDelegate
>


@property (nonatomic, retain) Y2WSession *session;

@property (nonatomic, retain) NSMutableArray *messages;

@property (nonatomic, retain) MessageCellConfig *cellConfig;

@property (nonatomic, retain) Y2WMessagesPage *page;


@property (nonatomic, retain) UIImagePickerController *imagePicker;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) InputView *inputView;

@end


@implementation ConversationViewController

- (void)dealloc {
    NSLog(@"%s--%@",__FUNCTION__,[NSThread currentThread]);

    [self.session.messages removeDelegate:self];
}

- (instancetype)initWithSession:(Y2WSession *)session {

    if (self = [super init]) {
        _session = session;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNavItem];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inputView];
    
    [self.session.messages addDelegate:self];
    [self.session.messages loadMessageWithPage:nil];
    [self.session.sessions.user.userConversations.remote sync];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    self.tableView.height = self.inputView.top;
}

- (void)setUpNavItem {
    
    self.navigationItem.title = self.session.name;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"导航栏_返回"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    if ([self.session.type isEqualToString:@"p2p"]) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"导航栏_个人信息"] style:UIBarButtonItemStylePlain target:self action:@selector(p2pRightBarButtonItemClick)];
        
    }else if ([self.session.type isEqualToString:@"group"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"导航栏_群信息"] style:UIBarButtonItemStylePlain target:self action:@selector(groupRightBarButtonItemClick)];
    }
}




#pragma mark - ———— Response ———— -

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)p2pRightBarButtonItemClick {
    
}

- (void)groupRightBarButtonItemClick {
    GroupViewController *groupViewController = [[GroupViewController alloc] initWithSesstion:self.session];
    [self pushViewController:groupViewController];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.inputView endEditing:YES];
}






#pragma mark - ———— Y2WMessagesDelegate ———— -

- (void)messages:(Y2WMessages *)messages loadMessagesFromPage:(Y2WMessagesPage *)page didCompleteWithError:(NSError *)error {

    if (!_messages) _messages = [NSMutableArray array];

    CGFloat totalCellHeight = 0;
    
    for (Y2WMessage *message in page.messageList) {
        MessageModel *model = [[MessageModel alloc] initWithMessage:message];
        [self updateMessageModel:model];
        [self.messages addObject:model];
        
        totalCellHeight += model.cellHeight;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.page) {
            [self.tableView reloadData];
            CGFloat contentOffsetY = self.tableView.contentOffset.y + totalCellHeight;
            self.tableView.contentOffset = CGPointMake(0, contentOffsetY);
            
        }else {
            [self.tableView reloadData];
            [self.tableView scrollToBottom:NO];
        }
        
        self.page = page;
    });
}

- (void)messages:(Y2WMessages *)messages onRecvMessage:(Y2WMessage *)message {
   
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (MessageModel *model in self.messages) {
            if ([model.message isEqual:message]) return;
        }
        MessageModel *newModel = [[MessageModel alloc] initWithMessage:message];
        [self updateMessageModel:newModel];
        
        MessageModel *topModel;
        for (MessageModel *model in self.messages) {
            if (model.status != MessageModelStatusNormal) {
                topModel = model;
                break;
            }
        }
        
        if (topModel) {
            NSInteger index= [self.messages indexOfObject:topModel];
            [self.messages insertObject:newModel atIndex:index];
        }else {
            [self.messages addObject:newModel];
        }
        
        [self.tableView reloadData];
        [self.tableView scrollToBottom:YES];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.messages indexOfObject:newModel] inSection:0];
//        NSLog(@"%@---%@",indexPath,self.messages.description);
//        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

- (void)messages:(Y2WMessages *)messages willSendMessage:(Y2WMessage *)message {

    MessageModel *newModel = [[MessageModel alloc] initWithMessage:message];
    [self updateMessageModel:newModel];
    [self.messages addObject:newModel];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.messages indexOfObject:newModel] inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

- (void)messages:(Y2WMessages *)messages sendMessage:(Y2WMessage *)message progress:(CGFloat)progress {

    for (MessageModel *model in self.messages) {
        if (![model.message isEqual:message]) continue;
        
        model.message = message;
        [self updateMessageModel:model];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.messages indexOfObject:model] inSection:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        });
        return;
    }
}

- (void)messages:(Y2WMessages *)messages sendMessage:(Y2WMessage *)message didCompleteWithError:(NSError *)error {
    NSLog(@"%s",__FUNCTION__);

    if (error) {
        [UIAlertView showTitle:nil message:[[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding]];
        return;
    }
    
    for (MessageModel *model in self.messages) {
        if (![model.message isEqual:message]) continue;
        
        model.message = message;
        [self updateMessageModel:model];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.messages indexOfObject:model] inSection:0];
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        });
        return;
    }
}

- (void)messages:(Y2WMessages *)messages onUpdateMessage:(Y2WMessage *)message {
//    NSLog(@"%s",__FUNCTION__);
    dispatch_async(dispatch_get_main_queue(), ^{

        for (MessageModel *model in self.messages) {
//            NSLog(@"%@---%@",model.message,message);
            if (![model.message isEqual:message]) continue;
            
            model.message = message;
            [self updateMessageModel:model];
            
                [self.tableView reloadData];
    //            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.messages indexOfObject:model] inSection:0];
    //            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    });
}




#pragma mark - ———— UITableViewDataSource ———— -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageModel *model = self.messages[indexPath.row];
    
    UITableViewCell<MessageCellModelInterface> *cell = [tableView dequeueReusableCellWithIdentifier:model.cellClassName];
    
    [cell refreshData:model];
    
    return cell;
}


#pragma mark - ———— UITableViewDelegate ———— -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *model = self.messages[indexPath.row];

    return model.cellHeight;
}


#pragma mark - ———— UIImagePickerControllerDelegate ———— -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerOriginalImage];
    }];
}



#pragma mark - ———— InputViewUIDelegate ———— -
//will
- (void)inputView:(InputView *)inputView didChangeTop:(CGFloat)top{
    
    self.tableView.frame = self.view.bounds;
    self.tableView.height = top;
    [self.tableView scrollToBottom:YES];
}

- (void)inputView:(InputView *)inputView showKeyboard:(CGFloat)show {
    self.tableView.userInteractionEnabled = !show;
}

- (void)inputView:(InputView *)inputView onSendText:(NSString *)text {

    Y2WMessage *message = [self.session.messages messageWithText:text];
    
    [self.session.messages sendMessage:message];
}

- (void)moreInputViewDidSelectItem:(MoreItem *)item {
    if ([item.title isEqualToString:@"图片"]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}





- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    for (MessageModel *model in _messages) {
        [model cleanCache];
        [model calculateContent:size.width];
    }
    
    [coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context) {
      
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
         });
     } completion:nil];
}







#pragma mark - ———— Helper ———— -

- (void)updateMessageModel:(MessageModel *)model {
    model.cellConfig = self.cellConfig;
    [model cleanCache];
    [model calculateContent:self.tableView.width];
}





#pragma mark - ———— getter ———— -

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"E3EFEF"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.canCancelContentTouches = NO;
        _tableView.delaysContentTouches = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[MessageCell class] forCellReuseIdentifier:NSStringFromClass([MessageCell class])];
        [_tableView registerClass:[MessageNotiCell class] forCellReuseIdentifier:NSStringFromClass([MessageNotiCell class])];
    }
    return _tableView;
}

- (InputView *)inputView {
    if (!_inputView) {
        _inputView = [[InputView alloc] initWithFrame:CGRectMake(0, self.view.height - 45, self.view.width, 45)];
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.UIDelegate = self;
        _inputView.ActionDelegate = self;
        _inputView.MoreDelegate = self;
        
        
        MoreItem *item = [[MoreItem alloc] init];
        item.title = @"图片";
        item.image = [UIImage imageNamed:@"输入框-图片"];
   
        MoreItem *item1 = [[MoreItem alloc] init];
        item1.title = @"文档";
        item1.image = [UIImage imageNamed:@"输入框-文档"];
        
        MoreItem *item2 = [[MoreItem alloc] init];
        item2.title = @"位置";
        item2.image = [UIImage imageNamed:@"输入框-位置"];
        
        _inputView.moreInputView.items = @[item,item1,item2];
    }
    return _inputView;
}

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

- (MessageCellConfig *)cellConfig {
    if (!_cellConfig) {
        _cellConfig = [[MessageCellConfig alloc] init];
    }
    return _cellConfig;
}

@end
