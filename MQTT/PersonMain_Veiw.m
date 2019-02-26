//
//  PersonMain_Veiw.m
//  MQTT
//
//  Created by 休杰克曼 on 2019/2/22.
//  Copyright © 2019 休杰克曼. All rights reserved.
//

#import "PersonMain_Veiw.h"


@interface PersonMain_Veiw()
{
    NSMutableArray *_personArrFriends;
    UIScrollView *_scroll;
}
@end

@implementation PersonMain_Veiw


- (instancetype)initWithFrame:(CGRect)frame SuperView:(UIViewController *)superView UserName:(NSString *)strName
{
    if (self = [super initWithFrame:frame]) {
        [self creatUIWithSuperView:superView userName:strName];
    }
    return self;
}

#pragma mark - creatUI
- (void)creatUIWithSuperView:(PersonMain_VC *)superView userName:(NSString *)strName
{
    UISegmentedControl *segView = [[UISegmentedControl alloc]initWithItems:@[@"单聊",@"群聊"]];
    [segView addTarget:self action:@selector(checkSegSelect:) forControlEvents:UIControlEventValueChanged];
    segView.frame = CGRectMake(0, 0, KDeviceWidth, 50);
    segView.selectedSegmentIndex = 0;
    [self addSubview:segView];
    
    
    _scroll = [[UIScrollView alloc]init];
    _scroll.frame = CGRectMake(0, 50, KDeviceWidth, KDeviceHeight  - kStatusBarHeight - 50);
    _scroll.contentSize = CGSizeMake(KDeviceWidth*2, KDeviceHeight  - kStatusBarHeight - 50);
    _scroll.pagingEnabled = YES;
    _scroll.scrollEnabled = NO;
    [self addSubview:_scroll];
    
    
        
    _personArrFriends = [self getArrWithType:strName];
    
    for (int i = 0; i < _personArrFriends.count; i++) {
        UIButton *btnChatPerson = [UIButton buttonWithType:UIButtonTypeSystem];
        btnChatPerson.backgroundColor = [UIColor orangeColor];
        [btnChatPerson setTitle:_personArrFriends[i] forState:UIControlStateNormal];
        [btnChatPerson setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnChatPerson addTarget:self action:@selector(checkPersonChatBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_scroll addSubview:btnChatPerson];
        [btnChatPerson mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_scroll).offset(KDeviceWidth/2-50);
            make.top.equalTo(self->_scroll).offset(i*50+50);
            make.size.mas_equalTo(CGSizeMake(100, 30));
        }];
    }
    
    UIButton *btnChatGroup = [UIButton buttonWithType:UIButtonTypeSystem];
    btnChatGroup.backgroundColor = [UIColor orangeColor];
    [btnChatGroup setTitle:@"Group01" forState:UIControlStateNormal];
    [btnChatGroup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnChatGroup addTarget:self action:@selector(checkGroupChatBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:btnChatGroup];
    [btnChatGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self->_scroll).offset(KDeviceWidth);
        make.top.equalTo(self->_scroll).offset(100);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
}



#pragma mark - 单聊
- (void)checkPersonChatBtn:(UIButton *)btn
{
    _checkSingleChatBtnB(btn.titleLabel.text);
}


#pragma mark - 群聊
- (void)checkGroupChatBtn:(UIButton *)btn
{
    _checkGroupChatBtnB(btn.titleLabel.text);
}




- (void)checkSegSelect:(UISegmentedControl *)sender
{
    [_scroll setContentOffset:CGPointMake(sender.selectedSegmentIndex*KDeviceWidth, 0) animated:YES];
}


- (NSMutableArray *)getArrWithType:(NSString *)strPersonTag
{
    
    NSMutableArray *arrData = [NSMutableArray array];
    if ([strPersonTag isEqualToString:@"user1"]) {
        [arrData addObjectsFromArray:@[@"user2",@"user3"]];
    }else if ([strPersonTag isEqualToString:@"user2"]) {
        [arrData addObjectsFromArray:@[@"user1",@"user3"]];
    }else if ([strPersonTag isEqualToString:@"user3"]) {
        [arrData addObjectsFromArray:@[@"user1",@"user2"]];
    }
    return arrData;
}

#pragma mark - BLOCK
- (void)checkSingleChatBtn:(checkSingleChatBtnBlock)block
{
    _checkSingleChatBtnB = block;
}
- (void)checkGroupChatBtnBlock:(checkGroupChatBtnBlock)block
{
    _checkGroupChatBtnB = block;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
