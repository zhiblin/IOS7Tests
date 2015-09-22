//
//  AdDataModel.m
//  AllDemo
//
//  Created by lzb on 15/9/7.
//  Copyright © 2015年 loaer. All rights reserved.
//

#import "AdDataModel.h"

@implementation AdDataModel
@synthesize adid,adtype,adversiontype,adafteraction,adurl,adversion,adweight,adweightafter,iconurl;


- (id)initWithDictionary:(NSDictionary *)dic{
    
    self = [super init];
    if (self) {
        adid = [dic objectForKey:@"id"];
        adtype = [dic objectForKey:@"ad_type"];
        adweight = [dic objectForKey:@"ad_weight"];
        adweightafter = [dic objectForKey:@"ad_weight_after"];
        adafteraction = [dic objectForKey:@"after_action"];
        adversiontype = [dic objectForKey:@"ad_version_type"];
        adversion = [dic objectForKey:@"ad_version"];
        iconurl = [dic objectForKey:@"icon_url"];
        adurl = [dic objectForKey:@"ad_url"];
    }
    return self;
    
}

-(void)filterData{
    
//    if ([oneAd objectForKey:@"ad_version"] &&
//        [oneAd
//         objectForKey:@"ad_version_type"]) //不存在版本号就是适用于所有版本
//    {
//        NSInteger verson =
//        [[oneAd objectForKey:@"ad_version_type"] integerValue];
//        //          广告当前适合版本号
//        NSInteger adverson = [[[oneAd objectForKey:@"ad_version"]
//                               stringByReplacingOccurrencesOfString:@"."
//                               withString:@""] integerValue];
//        //          app当前版本号
//        NSInteger currentVersion = [[SOFTWARE_VERSION
//                                     stringByReplacingOccurrencesOfString:@"."
//                                     withString:@""] integerValue];
//        BOOL isSetAD = YES;
//        if (verson == 3) {
//            isSetAD = (adverson < currentVersion);
//        } else if (verson == 2) {
//            isSetAD = (adverson >= currentVersion);
//        }
//        if (isSetAD) {
//            NSDictionary *adDic = [NSDictionary
//                                   dictionaryWithObjectsAndKeys:[oneAd objectForKey:@"after_action"],@"after_action",[oneAd objectForKey:@"icon_url"],
//                                   @"icon_url",
//                                   [oneAd objectForKey:@"ad_url"],
//                                   @"ad_url", nil];
}

@end
