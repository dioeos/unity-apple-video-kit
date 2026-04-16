#import "PackageHealthValidator.h"
#import <Foundation/Foundation.h>
#import <stdlib.h>
#import <string.h>

#if __has_include(<UnityFramework/UnityFramework-Swift.h>)
#import <UnityFramework/UnityFramework-Swift.h>
#else
#import "UnityFramework-Swift.h"
#endif

bool pv_is_available(void)
{
    return [PackageHealthValidator isPackageHealthy];
}

const char* pv_say_hello(void)
{
  NSString *result = [PackageHealthValidator sayHello];
  const char *utf8 = [result UTF8String];

  char *copy = (char *)malloc(strlen(utf8) + 1);
  strcpy(copy, utf8);
  return copy;
}
