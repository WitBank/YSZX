//
//  AppDelegate.m
//  YaoKaoLa
//
//  Created by HuXin on 14/12/25.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ViewController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "SVProgressHUD.h"
#import "ZHCoreDataManage.h"

@interface AppDelegate ()

@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.courseChapterModel = nil;
    self.downloadQueue = [NSMutableArray array];
    [self initData];
    [self addMTASDK];
    
    
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)showMainViewController{
    NSString *status = [[NSUserDefaults standardUserDefaults] objectForKey:@"userpassword"];
    if (status == nil ||[status isEqualToString:@""]) {
        [self showLogin];
    }else{
        [self showMainView];
    }
    
}

- (void)addMTASDK
{
    [MTA startWithAppkey:@"IC9X73K4PCZN"];
}


//初始化数据
- (void)initData{
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    //设置所有导航条背景
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationBar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName:[UIFont boldSystemFontOfSize:19],
                                                           NSForegroundColorAttributeName:[UIColor whiteColor], //前景字体颜色
                                                           NSStrikethroughStyleAttributeName:@1}];
    
    //第一次登陆
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString * s = [ud objectForKey:@"isFirstStart"];
    if (!s) {
        [ud setObject:@"YES" forKey:@"isFirstStart"];
        [ud synchronize];
        ViewController *root = [[ViewController alloc] init];
        self.window.rootViewController = root;
    }else{
        [self showMainViewController];
    }
    
}- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "ZHSZ.YaoKaoLa" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"YaoKaoLa" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"YaoKaoLa.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
//登录
- (void)showLogin{
    LoginViewController *root = [[LoginViewController alloc] init];
    self.window.rootViewController = root;
}
//主页
- (void)showMainView{
    _courseArray = [[NSMutableArray alloc] init];
    _chapterArray = [[NSMutableArray alloc] init];
    [self readLocalData];
    NSArray *classes = @[@"MenuViewController",@"TestViewController",@"CourseViewController",@"InformationViewController",@"UserViewController"];
    NSArray *titles = @[@"首页",@"试题",@"课程",@"资讯",@"我"];
    NSArray *images = @[@"menu_",@"test_",@"course_",@"advisory_",@"people_"];
    NSMutableArray *tabArray = [NSMutableArray array];
    UITabBarController *tbc = [[UITabBarController alloc] init];
    for (int i = 0;i < classes.count; i++) {
        Class cls = NSClassFromString(classes[i]);
        UIViewController *vc = [[cls alloc] init];
        vc.title = titles[i];
        [vc.tabBarItem setImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@nomal",images[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [vc.tabBarItem setSelectedImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@select",images[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [vc.tabBarItem setTitleTextAttributes:@{
                                                NSFontAttributeName:[UIFont boldSystemFontOfSize:12],//字体大小
                                                //  NSForegroundColorAttributeName:[UIColor whiteColor],//字体颜色
                                                } forState:UIControlStateNormal];
        [vc.tabBarItem setTitleTextAttributes:@{
                                                NSFontAttributeName:[UIFont boldSystemFontOfSize:12],//字体大小
                                                NSForegroundColorAttributeName:UIColorFromRGB(0x1E90FE),//字体颜色
                                                } forState:UIControlStateSelected];
        
        [tabArray addObject:nc];
    }
    [tbc.tabBar setBackgroundImage:[UIImage imageNamed:@"bottombg.png"]];
    tbc.viewControllers = tabArray;
    self.window.rootViewController = tbc;
}

- (void)readLocalData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *courseArray = [ZHCoreDataManage getCourseModelArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            _courseArray = [NSMutableArray arrayWithArray:courseArray];
        });
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *cpArray = [ZHCoreDataManage getAllCourseChapterModelArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            _chapterArray = [NSMutableArray arrayWithArray:cpArray];
        });
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *dlArray = [ZHCoreDataManage getAllDownloadVideoModelArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            _downloadArray = [NSMutableArray arrayWithArray:dlArray];
        });
    });
}

+(AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark download method
-(NSURL *)smartURLForString:(NSString *)str
{
    NSURL *result;
    NSString *trimmedStr;
    NSRange schemeMarkerRang;
    NSString *scheme;
    
    assert(str != nil);
    
    result = nil;
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ((trimmedStr != nil) && (trimmedStr.length != 0)) {
        schemeMarkerRang = [trimmedStr rangeOfString:@"://"];
        
        if (schemeMarkerRang.location == NSNotFound) {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",trimmedStr]];
        }
        else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0,schemeMarkerRang.location)];
            assert(scheme != nil);
            if (([scheme compare:@"http" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame))
            {
                result = [NSURL URLWithString:trimmedStr];
            }
            else {
                
            }
        }
    }
    return result;
}
-(void)didStartNetworking
{
    _networkingCount += 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
-(void)didStopNetworking
{
    assert(_networkingCount > 0);
    _networkingCount -= 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = (_networkingCount != 0);
}

@end
