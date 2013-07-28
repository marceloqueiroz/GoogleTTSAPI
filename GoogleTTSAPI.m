//
//  GoogleTTSAPI.m
//  GoogleTTSAPISample
//
//  Created by Marcelo Queiroz on 7/26/13.
//  Copyright (c) 2013 Marcelo Queiroz. All rights reserved.
//

#import "GoogleTTSAPI.h"

// Error messages
#define kGoogleTTSAPI_InvalidTextMessage @"Invalid text, please provided a valid text."
#define kGoogleTTSAPI_InvalidLocaleMessage @"Invalid locale, please provided a valid locale."
#define kGoogleTTSAPI_InvalidAudioDataMessage @"Invalid audio data received."

// Google TTS URL
#define kGoogleTTSURL @"http://translate.google.com/translate_tts?ie=UTF-8&q=%@&tl=%@&total=1&idx=0&textlen=%d&prev=input"

#define kGoogleTTSSourceTextLimitLength 100

@implementation GoogleTTSAPI

+ (void)textToSpeechWithText:(NSString *)text success:(void(^)(NSData *data))success failure:(void(^)(NSError *error))failure {
    [GoogleTTSAPI textToSpeechWithText:text andLanguage:[[NSLocale currentLocale] localeIdentifier] success:success failure:failure];
}

+ (void)textToSpeechWithText:(NSString *)text andLanguage:(NSString*) language success:(void(^)(NSData *data))success failure:(void(^)(NSError *error))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *trimmedText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        // Validates the text
        if (trimmedText && [trimmedText length] > 0) {
            NSString *trimmedLocale = [language stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:trimmedLocale];
            
            // Validates the locale
            if (locale) {
                NSData *audioData = [GoogleTTSAPI googleTextToSpeechWithText:text andLanguage:language];
                if (audioData && success) {
                    success(audioData);
                } else if (!audioData && failure) {
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: kGoogleTTSAPI_InvalidAudioDataMessage};
                    NSError *error = [NSError errorWithDomain:kGoogleTTSAPIDomain code:kGoogleTTSAPI_InvalidAudioDataErrorCode userInfo:userInfo];
                    failure(error);
                }
            } else {
                if (failure) {
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: kGoogleTTSAPI_InvalidLocaleMessage};
                    NSError *error = [NSError errorWithDomain:kGoogleTTSAPIDomain code:kGoogleTTSAPI_InvalidLocaleErrorCode userInfo:userInfo];
                    failure(error);
                }
            }
        } else {
            if (failure) {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: kGoogleTTSAPI_InvalidTextMessage};
                NSError *error = [NSError errorWithDomain:kGoogleTTSAPIDomain code:kGoogleTTSAPI_InvalidTextErrorCode userInfo:userInfo];
                failure(error);
            }
        }
    });
}

#pragma mark - Google Text To Speech integration

+ (NSData*) googleTextToSpeechWithText: (NSString*) text andLanguage: (NSString*) language {
    NSMutableData *audioData = [NSMutableData data];
    
    NSString *editedText = [text stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
    editedText = [editedText stringByReplacingOccurrencesOfString:@"(\\,|\\.)" withString:@"{SEP_RULES_GoogleTTSAPI}" options:NSRegularExpressionSearch range:NSMakeRange(0, [editedText length])];

    NSArray *components = [editedText componentsSeparatedByString:@"{SEP_RULES_GoogleTTSAPI}"];
    for (NSString *string in components) {
        NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([trimmedString length] <= kGoogleTTSSourceTextLimitLength) {
            [audioData appendData:[GoogleTTSAPI googleTextToSpeechDataWithText:trimmedString andLanguage:language]];
        } else {
            NSArray *subparts = [trimmedString componentsSeparatedByString:@" "];
            NSMutableString *subString = [NSMutableString string];
            
            for (NSString *element in subparts) {
                if ([element length] + [subString length] <= kGoogleTTSSourceTextLimitLength) {
                    [subString appendFormat:@"%@ ",element];
                } else {
                    [audioData appendData:[GoogleTTSAPI googleTextToSpeechDataWithText:subString andLanguage:language]];
                    subString = [NSMutableString stringWithString:element];
                }
            }
            
            if ([subString length] > 0) {
                [audioData appendData:[GoogleTTSAPI googleTextToSpeechDataWithText:subString andLanguage:language]];
            }
        }
    }
    return audioData;
}

+ (NSData*) googleTextToSpeechDataWithText: (NSString*) text andLanguage: (NSString*) language {
    NSString *trimmedText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *urlString = [NSString stringWithFormat:kGoogleTTSURL,trimmedText,language,[text length]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
}

@end
