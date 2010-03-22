//
// Modified from Jeff Lamarche's OpenGL ES Template for XCode
// http://iphonedevelopment.blogspot.com/2009/05/opengl-es-from-ground-up-table-of.html
//

#import "GHGLTexture.h"

@implementation GHGLTexture

- (id)initWithName:(NSString *)name {
	return [self initWithName:name width:0 height:0];
}

- (id)initWithName:(NSString *)name width:(GLuint)width height:(GLuint)height {
	if ((self = [self init])) {
		glEnable(GL_TEXTURE_2D);
		
		glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);  
		glGenTextures(1, &_texture[0]);
		glBindTexture(GL_TEXTURE_2D, _texture[0]);
		//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER, GL_LINEAR); 
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER, GL_LINEAR); 
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
		glBlendFunc(GL_ONE, GL_SRC_COLOR);
		
		NSString *extension = [name pathExtension];
		NSString *path = [[NSBundle mainBundle] pathForResource:[name stringByDeletingPathExtension] ofType:extension];
		NSData *textureData = [[NSData alloc] initWithContentsOfFile:path];
		
		// Assumes pvr4 is RGB not RGBA, which is how _texturetool generates them
		if ([extension isEqualToString:@"pvr4"])
			glCompressedTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_RGB_PVRTC_4BPPV1_IMG, width, height, 0, (width * height) / 2, [textureData bytes]);
		else if ([extension isEqualToString:@"pvr2"])
			glCompressedTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_RGB_PVRTC_2BPPV1_IMG, width, height, 0, (width * height) / 2, [textureData bytes]);
		else {
			UIImage *image = [[UIImage alloc] initWithData:textureData];
			if (image == nil)
				return nil;
			
			if (width == 0) width = CGImageGetWidth(image.CGImage);
			if (height == 0) height = CGImageGetHeight(image.CGImage);
      NSAssert(width > 0, @"Invalid width");
      NSAssert(height > 0, @"Invalid height");
			CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
			void *imageData = malloc(height * width * 4);
			CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
			CGColorSpaceRelease(colorSpace);
			CGContextClearRect(context, CGRectMake(0, 0, width, height));
			CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);

			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
			GLuint GLError = glGetError();
      NSAssert(GLError == GL_NO_ERROR, @"Error loading texture");
			CGContextRelease(context);
			
			free(imageData);
			[image release];
		}
		glEnable(GL_BLEND);
		[textureData release];
	}
	return self;
}

- (void)dealloc {
	glDeleteTextures(1, &_texture[0]);
	[super dealloc];
}

+ (void)useDefaultTexture {
	glBindTexture(GL_TEXTURE_2D, 0);
}

- (GLuint)textureId {
	return _texture[0];
}

- (void)bind {
	glBindTexture(GL_TEXTURE_2D, _texture[0]);
}

- (void)drawInRect:(CGRect)rect {
  
  const GLfloat vertices[] = {
    rect.origin.x, rect.origin.y,
    rect.origin.x + rect.size.width, rect.origin.y,
    rect.origin.x, rect.origin.y + rect.size.height,
    rect.origin.x + rect.size.width, rect.origin.y + rect.size.height
	};
	
	const GLfloat texCoords[] = {
		0.0, 1.0,
		1.0, 1.0,
		0.0, 0.0,
		1.0, 0.0
	};
  
  glEnable(GL_TEXTURE_2D);
  [self bind];  
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
  
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_TEXTURE_2D);
  
}

@end
