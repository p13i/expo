// Copyright 2015-present 650 Industries. All rights reserved.
#import "EXDevMenuAppInfo.h"
#import <EXDevMenu-Swift.h>
#import <EXManifests/EXManifests-Swift.h>

@implementation EXDevMenuAppInfo

+(NSDictionary *)getAppInfo
{
  NSMutableDictionary *appInfo = [NSMutableDictionary new];

  NSString *appIcon = [EXDevMenuAppInfo getAppIcon];
  NSString *runtimeVersion = [EXDevMenuAppInfo getUpdatesConfigForKey:@"EXUpdatesRuntimeVersion"];
  NSString *sdkVersion = [EXDevMenuAppInfo getUpdatesConfigForKey:@"EXUpdatesSDKVersion"];
  NSString *appVersion = [EXDevMenuAppInfo getFormattedAppVersion];
  NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleDisplayName"] ?: [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleExecutable"];

  DevMenuManager *manager = [DevMenuManager shared];

  if (manager.currentManifest != nil) {
    appName = [manager.currentManifest name];
    appVersion = [manager.currentManifest version];
  }


  NSString *hostUrl = [manager.currentManifestURL absoluteString] ?: @"";

  appInfo[@"appName"] = appName;
  appInfo[@"appIcon"] = appIcon;
  appInfo[@"appVersion"] = appVersion;
  appInfo[@"runtimeVersion"] = runtimeVersion;
  appInfo[@"sdkVersion"] = sdkVersion;
  appInfo[@"hostUrl"] = hostUrl;

  return appInfo;
}

+(NSString *)getAppIcon
{
  NSString *appIcon = @"";
  NSString *appIconName = [[[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIcons"] objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"]  lastObject];

  if (appIconName != nil) {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *appIconPath = [[resourcePath stringByAppendingString:appIconName] stringByAppendingString:@".png"];
    appIcon = [@"file://" stringByAppendingString:appIconPath];
  }

  return appIcon;
}

+(NSString *)getUpdatesConfigForKey:(NSString *)key
{
  NSString *value = @"";
  NSString *path = [[NSBundle mainBundle] pathForResource:@"Expo" ofType:@"plist"];

  if (path != nil) {
    NSDictionary *expoConfig = [NSDictionary dictionaryWithContentsOfFile:path];

    if (expoConfig != nil) {
      value = [expoConfig objectForKey:key] ?: @"";
    }
  }

  return value;
}

+(NSString *)getFormattedAppVersion
{
  NSString *shortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
  NSString *buildVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
  NSString *appVersion = [NSString stringWithFormat:@"%@ (%@)", shortVersion, buildVersion];
  return appVersion;
}

@end
