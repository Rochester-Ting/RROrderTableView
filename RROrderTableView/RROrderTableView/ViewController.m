//
//  ViewController.m
//  RROrderTableView
//
//  Created by 丁瑞瑞 on 1/8/16.
//  Copyright © 2016年 Rochester. All rights reserved.
//

#import "ViewController.h"
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
/** leftTableView*/
@property (nonatomic,strong) UITableView *leftTableView;
/** rightTableView*/
@property (nonatomic,strong) UITableView *rightTableView;
/** 模型数组*/
@property (nonatomic,strong) NSMutableArray *arrs;
@end

@implementation ViewController
- (NSMutableArray *)arrs{
    if (!_arrs) {
        _arrs = [NSMutableArray array];
        for (int i = 0; i < 20; i++) {
            NSString *str = [NSString stringWithFormat:@"第%zd组",i];
            [_arrs addObject:str];
        }
    }
    return _arrs;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseTableView];
}
- (void)setBaseTableView{
    UITableView *leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0.25 * ScreenW, ScreenH)];
    self.leftTableView = leftTableView;
    leftTableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:leftTableView];
    
    UITableView *rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.25 * ScreenW, 0, 0.75 * ScreenW, ScreenH)];
    self.rightTableView = rightTableView;
    [self.view addSubview:rightTableView];
    rightTableView.backgroundColor = [UIColor greenColor];
    
    leftTableView.delegate = rightTableView.delegate = self;
    leftTableView.dataSource = rightTableView.dataSource = self;
//    设置左边tableview的第一行默认被选中
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}
#pragma mark - uitableviewdelegate&&uitableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.leftTableView) {
        return 1;
    }else{
        return self.arrs.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView) return self.arrs.count;
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RR"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RR"];
    }
    if (tableView == self.leftTableView) {
        cell.textLabel.text = self.arrs[indexPath.row];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@----%zd",self.arrs[indexPath.row],indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.rightTableView) return;
//    选中左边的某一行 让对应右边的那一组的第一行默认选中
    [self.rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] animated:YES scrollPosition:UITableViewScrollPositionTop];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return nil;
    }
    return self.arrs[section];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ((UITableView *)scrollView == self.leftTableView) return;
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.rightTableView.indexPathsForVisibleRows.firstObject.section inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}
@end
