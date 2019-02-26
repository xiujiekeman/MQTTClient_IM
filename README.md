# MQTTClient_IM
IM-based chat encapsulation based on MQTTClient



//init
- (instancetype)initMQTTWith:(NSString *)strName;

//send message
- (void)sendMessageWith:(NSString *)strMessage WithTpoic:(NSString *)strTopic WithSendUserName:(NSString *)strName;

//disConnect
- (void)disMQTTConnect;

//addTopic
- (void)addTopicWithName:(NSString *)strTopic isGroup:(BOOL)isGroup;

//removeTopic
- (void)deleteTopicWithName:(NSString *)strTopic isGroup:(BOOL)isGroup;









