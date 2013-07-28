//
//  GoogleTTSAPI.h
//  GoogleTTSAPISample
//
//  Created by Marcelo Queiroz on 7/26/13.
//  Copyright (c) 2013 Marcelo Queiroz. All rights reserved.
//

#import <Foundation/Foundation.h>

// Error domain
#define kGoogleTTSAPIDomain @"GoogleTTSAPIDomain"

// Error codes
#define kGoogleTTSAPI_InvalidTextErrorCode -1001
#define kGoogleTTSAPI_InvalidLocaleErrorCode -1002
#define kGoogleTTSAPI_InvalidAudioDataErrorCode -1003


@interface GoogleTTSAPI : NSObject

+ (void)textToSpeechWithText:(NSString *)text success:(void(^)(NSData *data))success failure:(void(^)(NSError *error))failure;

+ (void)textToSpeechWithText:(NSString *)text andLanguage:(NSString*) language success:(void(^)(NSData *data))success failure:(void(^)(NSError *error))failure;

@end
