//
//  FileTransSelectViewController.m
//  API
//
//  Created by ShingHo on 16/4/26.
//  Copyright © 2016年 SayGeronimo. All rights reserved.
//

#import "FileTransSelectViewController.h"
#import "FileModel.h"

@interface FileTransSelectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *fileArray;

@end

@implementation FileTransSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self getFileList];
}

#pragma mark - ———— UITableViewDataSource ———— -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fileArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    FileModel *model = self.fileArray[indexPath.row];
    cell.imageView.image = model.typeImage;
    cell.textLabel.text = model.title;
    return cell;
}

#pragma mark - ———— UITableViewDelegate ———— -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FileModel *model = self.fileArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(sendFileModel:)]) {
        [self.delegate sendFileModel:model];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - ———— Helper ———— -
- (void)getFileList
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",[Y2WUsers getInstance].getCurrentUser.userId]];
    NSArray *fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for (NSString *string in fileArray) {
        NSString *filePath = [path stringByAppendingFormat:@"/%@",string];
        FileModel *model = [[FileModel alloc]initWithFileTitle:string FilePath:filePath];
        [self.fileArray addObject:model];
    }
    
}

#pragma mark - ———— setter and getter ———— -
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"E3EFEF"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];

    }
    return _tableView;
}

- (NSMutableArray *)fileArray
{
    if (!_fileArray) {
        _fileArray = [NSMutableArray array];
    }
    return _fileArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
