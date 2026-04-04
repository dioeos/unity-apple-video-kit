#import "NativeHelloBridge.h"
#import <Foundation/Foundation.h>
#import "UnityFramework/UnityFramework.h"
#import "UnityFramework-Swift.h"

bool nh_is_available(void)
{
    return [NativeHelloManager isBridgeAvailable];
}

const char* nh_say_hello(void)
{
  NSString *result = [NativehelloManager sayHello];
  const char *utf8 = [result UTF8String];

  char *copy = (char *)malloc(strlen(utf8) + 1);
  strcpy(copy, utf8);
  return copy;
}
