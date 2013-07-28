//
//  LanguagesViewController.h
//  GoogleTTSAPISample
//
//  Created by Marcelo Queiroz on 7/27/13.
//  Copyright (c) 2013 Marcelo Queiroz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LanguagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewLanguages;
@property (strong, nonatomic) NSArray *languages;

+ (NSString*) currentLanguage;

@end
