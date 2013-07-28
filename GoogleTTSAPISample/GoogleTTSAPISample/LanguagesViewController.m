//
//  LanguagesViewController.m
//  GoogleTTSAPISample
//
//  Created by Marcelo Queiroz on 7/27/13.
//  Copyright (c) 2013 Marcelo Queiroz. All rights reserved.
//

#import "LanguagesViewController.h"

#define kGoogleTTSAPISampleCurrentLanguage @"kGoogleTTSAPISampleCurrentLanguage"
#define kGoogleTTSAPISampleDefaultLanguage @"en"

@interface LanguagesViewController ()

@end

@implementation LanguagesViewController

#pragma mark - Class methods

+ (NSString*) currentLanguage {
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:kGoogleTTSAPISampleCurrentLanguage];
    if (!currentLanguage) {
        currentLanguage = kGoogleTTSAPISampleDefaultLanguage;
        [LanguagesViewController setCurrentLanguage:currentLanguage];
    }
    return currentLanguage;
}

+ (void) setCurrentLanguage: (NSString*) language {
    if (language) {
        [[NSUserDefaults standardUserDefaults] setValue:language forKey:kGoogleTTSAPISampleCurrentLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Languages";
    
    // Init languages array
    self.languages = [[NSLocale availableLocaleIdentifiers] sortedArrayUsingSelector:@selector(compare:)];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.languages indexOfObject:[LanguagesViewController currentLanguage]] inSection:0];
    [self.tableViewLanguages scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.languages) {
        return [self.languages count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"languageCellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    NSString *language = self.languages[indexPath.row];
    cell.textLabel.text = language;
    
    if ([language isEqualToString:[LanguagesViewController currentLanguage]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *language = self.languages[indexPath.row];
    [LanguagesViewController setCurrentLanguage:language];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
