// Copyright 2015-present 650 Industries. All rights reserved.

#import <ABI38_0_0EXFileSystem/ABI38_0_0EXSessionUploadTaskDelegate.h>

@interface ABI38_0_0EXSessionUploadTaskDelegate ()

@property (strong, nonatomic) NSMutableData *responseData;

@end

@implementation ABI38_0_0EXSessionUploadTaskDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
  if (!data.length) {
    return;
  }
  [_responseData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
  if (error) {
    self.reject(@"ERR_FILESYSTEM_CANNOT_UPLOAD",
                [NSString stringWithFormat:@"Unable to upload the file: '%@'", error.description],
                error);
    return;
  }
  
  // We only set ABI38_0_0EXSessionUploadTaskDelegates as delegates of upload tasks
  // so it should be safe to assume that this is what we will receive here.
  NSURLSessionUploadTask *uploadTask = (NSURLSessionUploadTask *)task;
  self.resolve([self parseServerResponse:uploadTask.response]);
}

- (NSDictionary *)parseServerResponse:(NSURLResponse *)response
{
  NSMutableDictionary *result = [[super parseServerResponse:response] mutableCopy];
  // TODO: add support for others response types (different encodings, files)
  result[@"body"] = ABI38_0_0UMNullIfNil([[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding]);
  return result;
}

@end
