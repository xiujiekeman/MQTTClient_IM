//
//  ChatList_VC.m
//  MQTT
//
//  Created by 休杰克曼 on 2019/2/22.
//  Copyright © 2019 休杰克曼. All rights reserved.
//

#import "ChatList_VC.h"

@interface ChatList_VC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_tab;
    UITextField *_textF;
    NSMutableArray *_arrData;
}
@end

@implementation ChatList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _arrData = [NSMutableArray array];
    [self creatUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationGetMessage:) name:@"getmessage" object:nil];

}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)creatUI
{
    _tab = [[UITableView alloc]init];
    _tab.delegate = self;
    _tab.dataSource = self;
    _tab.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tab];
    [_tab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarHeight);
        make.size.mas_equalTo(CGSizeMake(KDeviceWidth, KDeviceHeight - kNavBarHeight - 50));
    }];
    
    
    _textF = [[UITextField alloc]init];
    _textF.backgroundColor= [UIColor orangeColor];
    _textF.delegate = self;
    _textF.returnKeyType = UIReturnKeySend;
    _textF.frame = CGRectMake(0, KDeviceHeight - 50 -(KDeviceHeight==83?39:0), KDeviceWidth, 50);
    [self.view addSubview:_textF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}



#pragma mark - 发送
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];//取消第一响应者
    if (_enterType == 0) {
        [self sendMessageWithStr:textField.text];
    }else{
        [self sendGroupMessageWithStr:textField.text];
    }
    return YES;
}


#pragma mark - 点击发送

#pragma mark - 单聊
- (void)sendMessageWithStr:(NSString *)strMessage
{
    [_mqttManager sendMessageWith:strMessage WithTpoic:MQTTUserSingleTopic(self.title) WithSendUserName:_userName];
    [_arrData addObject:@{@"message":strMessage,@"senderName":_userName}];
    [_tab reloadData];
}
#pragma mark - 群聊
- (void)sendGroupMessageWithStr:(NSString *)strMessage
{
    [_mqttManager sendMessageWith:strMessage WithTpoic:MQTTUserGroupTopic(self.title) WithSendUserName:_userName];
}



- (void)keyboardWillChangeFrame:(NSNotification *)notify{
    NSDictionary    * info = notify.userInfo;
    //动画时间
    CGFloat animationDuration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //键盘目标位置
    CGRect  keyboardAimFrame = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self keybaordAnimationWithDuration:animationDuration keyboardOriginY:keyboardAimFrame.origin.y];
}


- (void)keybaordAnimationWithDuration:(CGFloat)duration keyboardOriginY:(CGFloat)keyboardOriginY{
    //作为视图的键盘，弹出动画也是UIViewAnimationOptionCurveEaseIn的方式
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        //text field
        CGPoint textFieldOrigin = self->_textF.frame.origin;
        CGSize  textFieldSize = self->_textF.frame.size;
        CGRect  textFieldAimFrame = CGRectMake(textFieldOrigin.x, keyboardOriginY - textFieldSize.height, textFieldSize.width, textFieldSize.height);
        self->_textF.frame = textFieldAimFrame;
        
        //table view
        
    } completion:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"MQTTChatCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@:%@",[_arrData[indexPath.row] objectForKey:@"senderName"],[_arrData[indexPath.row] objectForKey:@"message"]];
    return cell;
}



-(void)notificationGetMessage:(NSNotification *)sender
{
    NSLog(@"=======%@",[sender userInfo]);
    [_arrData addObject:[sender userInfo]];
    [_tab reloadData];
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
