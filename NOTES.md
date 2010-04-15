
// Save to album

- (void)saveToPhotoLibrary:(NSString *)path {
  if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
    UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(videoPath:didFinishSavingWithError:contextInfo:), NULL);
  } else {
    FFDebug(@"Path is not compatible: %@", path);
  }
}  

- (void)videoPath:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
  if (error) {
    FFDebug(@"Error saving: %@", error);
  } else {
    FFDebug(@"Saved"); 
  }
}
