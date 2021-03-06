// Copyright © 2018 650 Industries. All rights reserved.

#import <ABI39_0_0EXSplashScreen/ABI39_0_0EXSplashScreenService.h>
#import <ABI39_0_0EXSplashScreen/ABI39_0_0EXSplashScreenViewNativeProvider.h>
#import <ABI39_0_0UMCore/ABI39_0_0UMDefines.h>

@interface ABI39_0_0EXSplashScreenService ()

@property (nonatomic, strong) NSMapTable<UIViewController *, ABI39_0_0EXSplashScreenController *> *splashScreenControllers;

@end

@implementation ABI39_0_0EXSplashScreenService

ABI39_0_0UM_REGISTER_SINGLETON_MODULE(SplashScreen);

- (instancetype)init
{
  if (self = [super init]) {
    _splashScreenControllers = [NSMapTable weakToStrongObjectsMapTable];
  }
  return self;
}

- (void)showSplashScreenFor:(UIViewController *)viewController
{
  id<ABI39_0_0EXSplashScreenViewProvider> splashScreenViewProvider = [ABI39_0_0EXSplashScreenViewNativeProvider new];
  return [self showSplashScreenFor:viewController
          splashScreenViewProvider:splashScreenViewProvider
                   successCallback:^{}
                   failureCallback:^(NSString *message){ ABI39_0_0UMLogWarn(@"%@", message); }];
}

- (void)showSplashScreenFor:(UIViewController *)viewController
   splashScreenViewProvider:(id<ABI39_0_0EXSplashScreenViewProvider>)splashScreenViewProvider
            successCallback:(void (^)(void))successCallback
            failureCallback:(void (^)(NSString * _Nonnull))failureCallback
{
  if ([self.splashScreenControllers objectForKey:viewController]) {
    return failureCallback(@"'SplashScreen.show' has already been called for given view controller.");
  }
  
  ABI39_0_0EXSplashScreenController *splashScreenController = [[ABI39_0_0EXSplashScreenController alloc] initWithViewController:viewController
                                                                                     splashScreenViewProvider:splashScreenViewProvider];
  [self.splashScreenControllers setObject:splashScreenController forKey:viewController];
  [[self.splashScreenControllers objectForKey:viewController] showWithCallback:successCallback
                                                               failureCallback:failureCallback];
}

- (void)preventSplashScreenAutoHideFor:(UIViewController *)viewController
                       successCallback:(void (^)(BOOL hasEffect))successCallback
                       failureCallback:(void (^)(NSString * _Nonnull))failureCallback
{
  if (![self.splashScreenControllers objectForKey:viewController]) {
    return failureCallback(@"No native splash screen registered for given view controller. Call 'SplashScreen.show' for given view controller first.");
  }
  
  return [[self.splashScreenControllers objectForKey:viewController] preventAutoHideWithCallback:successCallback
                                                                                 failureCallback:failureCallback];
}

- (void)hideSplashScreenFor:(UIViewController *)viewController
            successCallback:(void (^)(BOOL hasEffect))successCallback
            failureCallback:(void (^)(NSString * _Nonnull))failureCallback
{
  if (![self.splashScreenControllers objectForKey:viewController]) {
    return failureCallback(@"No native splash screen registered for given view controller. Call 'SplashScreen.show' for given view controller first.");
  }
  return [[self.splashScreenControllers objectForKey:viewController] hideWithCallback:successCallback
                                                                      failureCallback:failureCallback];
}

- (void)onAppContentDidAppear:(UIViewController *)viewController
{
  if (![self.splashScreenControllers objectForKey:viewController]) {
    ABI39_0_0UMLogWarn(@"No native splash screen registered for given view controller. Call 'SplashScreen.show' for given view controller first.");
  }
  [[self.splashScreenControllers objectForKey:viewController] onAppContentDidAppear];
}

- (void)onAppContentWillReload:(UIViewController *)viewController
{
  if (![self.splashScreenControllers objectForKey:viewController]) {
    ABI39_0_0UMLogWarn(@"No native splash screen registered for given view controller. Call 'SplashScreen.show' for given view controller first.");
  }
  [[self.splashScreenControllers objectForKey:viewController] onAppContentWillReload];
}

# pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  UIViewController *rootViewController = [[application keyWindow] rootViewController];
  [self showSplashScreenFor:rootViewController];
  return YES;
}

@end
