//
//  AutoMonitorViewController.m
//  RestonSDKDemo
//
//  Created by San on 2017/7/27.
//  Copyright © 2017年 medica. All rights reserved.
//

#import "AutoMonitorViewController.h"
#import "Tool.h"

@interface AutoMonitorViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSMutableArray *hourArr;
    NSMutableArray *minArr;
}

@property (weak, nonatomic) IBOutlet UIPickerView *myPicker;
@property (weak, nonatomic) IBOutlet UIButton *saveBT;
@end

@implementation AutoMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUI];
    
    [self initData];
}

- (void)setUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    [self.saveBT setTitle:NSLocalizedString(@"save", nil) forState:UIControlStateNormal];
    [Tool configSomeKindOfButtonLikeNomal:self.saveBT];
}

- (void)initData
{
    hourArr=[[NSMutableArray alloc]initWithCapacity:0];
    minArr=[[NSMutableArray alloc]initWithCapacity:0];
    for (int i=0; i<24; i++) {
        [hourArr addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    for (int i=0; i<60; i++) {
        [minArr addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    self.myPicker.delegate=self;
    self.myPicker.dataSource=self;
    self.myPicker.showsSelectionIndicator=YES;
    
    [self.myPicker selectRow:[hourArr indexOfObject:@"22"] inComponent:0 animated:NO];
    [self.myPicker selectRow:[minArr indexOfObject:@"00"] inComponent:1 animated:NO];
}

- (IBAction)saveData:(id)sender {
    
}

#pragma mark - PickerView delegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 24;
        case 1:
            return 60;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return hourArr[row];
            break ;
        case 1:
            return minArr[row];
            break ;
        default:
            return 0;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    /*
    switch (component) {
        case 0:
        {
            //            [pickerView selectRow:[pickerView selectedRowInComponent:component]%[compentArray count]+base10 inComponent:component animated:false];
            hour=[[hourArr objectAtIndex:row]integerValue];
        }
            break;
        case 1:
        {
            min=[[minArr objectAtIndex:row] integerValue];
        }
            break;
        default:
            break;
    }*/
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
{
    return  80;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
{
    return 60.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
