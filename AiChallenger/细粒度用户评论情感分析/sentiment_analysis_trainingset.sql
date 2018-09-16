CREATE TABLE `sentiment_analysis_trainingset` (
`id`  int NOT NULL AUTO_INCREMENT ,
`content`  text NULL COMMENT '数据文本' ,
`location_traffic_convenience`  int NULL COMMENT '交通是否便利' ,
`location_distance_from_business_district`  int NULL DEFAULT '' COMMENT '距离商圈远近' ,
`location_easy_to_find`  int NULL COMMENT '是否容易寻找' ,
`service_wait_time`  int NULL COMMENT '排队等候时间' ,
`service_waiters_attitude`  int NULL COMMENT '服务人员态度' ,
`service_parking_convenience`  int NULL COMMENT '是否容易停车' ,
`service_serving_speed`  int NULL COMMENT '点菜/上菜速度' ,
`price_level`  int NULL COMMENT '价格水平' ,
`price_cost_effective`  int NULL COMMENT '性价比' ,
`price_discount`  int NULL COMMENT '折扣力度' ,
`environment_decoration`  int NULL COMMENT '装修情况' ,
`environment_noise`  int NULL COMMENT '嘈杂情况' ,
`environment_space`  int NULL COMMENT '就餐空间' ,
`environment_cleaness`  int NULL COMMENT '卫生情况' ,
`dish_portion`  int NULL COMMENT '分量' ,
`dish_taste`  int NULL COMMENT '口感' ,
`dish_look`  int NULL COMMENT '外观' ,
`dish_recommendation`  int NULL COMMENT '推荐程度' ,
`others_overall_experience`  int NULL COMMENT '  本次消费感受' ,
`others_willing_to_consume_again`  int NULL COMMENT '再次消费的意愿' ,
PRIMARY KEY (`id`),
FULLTEXT INDEX `findword` (`content`) 
)
COMMENT='AI_Challenger 挑战赛训练集数据'
;
