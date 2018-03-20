//
//  AppDelegate.m
//  Refueling
//
//  Created by Samuel on 17.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	#if TARGET_IPHONE_SIMULATOR
	// where are you?
	NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
	#endif
	
	[[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"itunesbackup_pref"];
	[[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"icloudbackup_pref"];
    [self initCloudAccess];
	
	//NSURLConnection *theConnection= [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:@"http://www.echopadder.bplaced.net/activity.php?kind=Started&name=Refueling"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0] delegate:self];
	
	// [theConnection start];
	
    return YES;
}


- (void)initCloudAccess {
    NSURL *ubiq = [[NSFileManager defaultManager]
				   URLForUbiquityContainerIdentifier:nil];
	if (ubiq) {
		NSLog(@"iCloud access at %@", ubiq);
	} else {
		NSLog(@"No iCloud access");
	}
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"saveDataInForeground" object:self];
}



@end
