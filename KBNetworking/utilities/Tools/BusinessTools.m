//
//  BusinessTools.m
//  VRShow
//
//  Created by jwd on 3/4/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "BusinessTools.h"
#import "BBRSACryptor.h"
#import "GTMBase64.h"

@interface BusinessTools ()
@property(nonatomic,strong)BBRSACryptor *rsaCryptor;

@end

@implementation BusinessTools

static BusinessTools *tools;

+ (BusinessTools *)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[BusinessTools alloc] init];
    });
    return tools;
}

-(id)init
{
    self = [super init];
    if (self) {
        _rsaCryptor = [[BBRSACryptor alloc] init];
        [_rsaCryptor importRSAPublicKeyBase64:kRSAPublicKey];
    }
    return self;
}


+ (UIView *)loadXibToViewWithName:(NSString *)name
{
    NSArray *ary = [[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil];
    UIView *elationView = (UIView *)[ary lastObject];
    return elationView;
}

+ (NSString *)encryptWithPublicKey:(NSString *)str
{
    NSData *passwordData = [[BusinessTools instance].rsaCryptor encryptWithPublicKeyUsingPadding:RSA_PKCS1_PADDING plainData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *cipherPassword = [GTMBase64 stringByEncodingData:passwordData];
    return cipherPassword;
}

+ (NSString *)decryptWithPublicKey:(NSString *)str
{
    NSData *cipherData = [GTMBase64 decodeString:str];
    NSData *plainData = [[BusinessTools instance].rsaCryptor decryptWithPublicKeyUsingPadding:RSA_PADDING_TYPE_PKCS1 cipherData:cipherData];
    NSString *_userID = [[NSString alloc]initWithData:plainData encoding:NSUTF8StringEncoding];
    return _userID;
}

// 将字典转换成json字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    //如果没有参数,返回-1
    if (dic == nil) {
        return @"-1";
    } else {
        NSError *parseError = nil;
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}



@end
