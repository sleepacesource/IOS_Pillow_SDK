//
//  WeekdaySelectViewController.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/14.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "WeekdaySelectViewController.h"

#import "SelectItemCell.h"

@interface WeekdaySelectViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray *weekdayList;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (nonatomic, assign) NSInteger weekDayNew;

@property (nonatomic, copy) NSArray *selectWeekDayList;
@end

@implementation WeekdaySelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)setUI
{
    self.titleLabel.text = @"重复";
    
    self.weekdayList = [NSArray arrayWithObjects:@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日", nil];
    
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    
    self.weekDayNew = self.selectWeekDay;
    
    self.selectWeekDayList = [self getRepeatDays:self.weekDayNew];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveData)];
    self.navigationItem.rightBarButtonItem = item1;
}

- (void)saveData {
    
    if (self.weekdayBlock) {
        self.weekdayBlock(self.weekDayNew);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.weekdayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellNibName:(NSString *)nibName{
    if (!tableView || [nibName length] == 0){
        return nil;
    }
    
    NSString *cellID = nibName;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell){
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectItemCell *cell = (SelectItemCell *)[self tableView:tableView cellNibName:@"SelectItemCell"];
    NSString *weekday = [self.weekdayList objectAtIndex:indexPath.row];
    cell.titleLabel.text = weekday;
    
    BOOL isSelected = [[self.selectWeekDayList objectAtIndex:indexPath.row] boolValue];
    cell.selectIcon.hidden = !isSelected;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger repeatDays = self.weekDayNew;
    NSInteger offset = 0x01 << indexPath.row;
    self.weekDayNew = repeatDays ^ offset;
    
    self.selectWeekDayList = [self getRepeatDays:self.weekDayNew];
    [self.tableView reloadData];
}

- (NSArray *)getRepeatDays:(NSInteger)weekday {
    NSMutableArray *repeatDaysArr = [NSMutableArray array];
    NSInteger repeatDays = weekday;
    for (int i = 0; i < 7; i++) {
        NSInteger offset = 0x01 << i;
        BOOL isSelected = repeatDays & offset;
        [repeatDaysArr addObject:@(isSelected)];
    }
    return [repeatDaysArr copy];
}


@end
