//
//  ViewController.m
//  GoogleTTSAPISample
//
//  Created by Marcelo Queiroz on 7/26/13.
//  Copyright (c) 2013 Marcelo Queiroz. All rights reserved.
//

#import "ViewController.h"

#import "GoogleTTSAPI.h"

#import "LanguagesViewController.h"

#import "MBProgressHUD.h"

@interface ViewController ()
@property (strong, nonatomic) UIBarButtonItem *barButtonPlay;
@property (strong, nonatomic) UIBarButtonItem *barButtonPause;
@property (strong, nonatomic) UIBarButtonItem *barButtonDone;
@property (strong, nonatomic) UIBarButtonItem *barButtonLanguage;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Title
    self.title = @"Google TTS API Demo";
    
    // Bar buttons
    self.barButtonPlay = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(btnPlayTapped)];
    self.barButtonPause = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(btnPauseTapped)];
    self.barButtonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnDoneTapped)];
    self.barButtonLanguage = [[UIBarButtonItem alloc] initWithTitle:[LanguagesViewController currentLanguage] style:UIBarButtonItemStylePlain target:self action:@selector(btnLanguageTapped)];
    
    self.navigationItem.leftBarButtonItem = self.barButtonLanguage;
    self.navigationItem.rightBarButtonItem = self.barButtonPlay;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.barButtonLanguage.title = [LanguagesViewController currentLanguage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action methods

- (void) btnPlayTapped {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [GoogleTTSAPI textToSpeechWithText:self.textView.text andLanguage:[LanguagesViewController currentLanguage] success:^(NSData *data) {
        [data writeToURL:[self fileURLWithFileName:@"teste2.mp3"] atomically:NO];

        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem.enabled = YES;
            self.navigationItem.rightBarButtonItem = self.barButtonPause;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem.enabled = YES;
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"GoogleTTSAPI" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
}

- (void) btnPauseTapped {
    self.navigationItem.rightBarButtonItem = self.barButtonPlay;
}

- (void) btnDoneTapped {
    [self.textView resignFirstResponder];
    self.navigationItem.rightBarButtonItem = self.barButtonPlay;
}

- (void) btnLanguageTapped {
    LanguagesViewController *viewController = [[LanguagesViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITextViewDelegate implementation

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem = self.barButtonDone;
    
    CGRect frm = self.textView.frame;
    frm.size.height -= 216;
    [UIView animateWithDuration:0.3 animations:^{
        self.textView.frame = frm;
    }];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem = self.barButtonPlay;
    
    CGRect frm = self.textView.frame;
    frm.size.height += 216;
    [UIView animateWithDuration:0.3 animations:^{
        self.textView.frame = frm;
    }];
}

#pragma mark - File methods

- (NSURL*) fileURLWithFileName: (NSString*) fileName {
    NSURL *documentDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentDirectory URLByAppendingPathComponent:fileName];
}

@end
