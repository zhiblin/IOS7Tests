//
//  AdDataModel.h
//  AllDemo
//
//  Created by lzb on 15/9/7.
//  Copyright © 2015年 loaer. All rights reserved.
//
/*
 
 id: "35",
 ad_type: "1",
 ad_weight: "0",
 ad_weight_after: "0",
 after_action: "1",
 ad_version_type: "1",
 ad_version: "",
 icon_url: "http://backendcdn.beautyplus.com/20150825/55dc351224abf6120.png",
 ad_url: "www.meitu.com"
 
 */
#import <Foundation/Foundation.h>

@interface AdDataModel : NSObject

@property (nonatomic, copy) NSString *adid;
@property (nonatomic, copy) NSString *adtype;
@property (nonatomic, copy) NSString *adweight;
@property (nonatomic, copy) NSString *adweightafter;
@property (nonatomic, copy) NSString *adafteraction;
@property (nonatomic, copy) NSString *adversiontype;
@property (nonatomic, copy) NSString *adversion;
@property (nonatomic, copy) NSString *iconurl;
@property (nonatomic, copy) NSString *adurl;


- (id)initWithDictionary:(NSDictionary *)dic;


@end
