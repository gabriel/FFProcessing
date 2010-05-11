//
// Modified from Jeff Lamarche's OpenGL ES Template for XCode
// http://iphonedevelopment.blogspot.com/2009/05/opengl-es-from-ground-up-table-of.html
//

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "GHGLView.h"
#import "GHGLDefines.h"
#import "GHGLUtils.h"


@interface GHGLView ()
@property (retain, nonatomic) EAGLContext *context;
@property (assign, nonatomic) NSTimer *animationTimer;
- (BOOL)_createFramebuffer;
- (void)_destroyFramebuffer;
@end


@implementation GHGLView

@synthesize animationInterval=_animationInterval, drawable=_drawable, backingWidth=_backingWidth, backingHeight=_backingHeight;
@synthesize context=_context, animationTimer=_animationTimer; // Private properties

+ (Class)layerClass {
	return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame {    
	if ((self = [super initWithFrame:frame])) {
		CAEAGLLayer *EAGLLayer = (CAEAGLLayer *)self.layer;
		
		EAGLLayer.opaque = YES;
		EAGLLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
																		[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, 
                                    kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
#if kAttemptToUseOpenGLES2
		_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
		if (_context == NULL) {
#endif
			_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
			
			if (!_context || ![EAGLContext setCurrentContext:_context]) {
				[self release];
				return nil;
			}
#if kAttemptToUseOpenGLES2
		}
#endif

    glGetIntegerv(GL_MAX_TEXTURE_SIZE, &_maxTextureSize);
    _supportsNPOT = GHGLCheckForExtension(GHGLExtension_GL_APPLE_texture_2D_limited_npot);
    _supportsBGRA8888 = GHGLCheckForExtension(GHGLExtension_GL_IMG_texture_format_BGRA8888);
    
    GHGLDebug(@"GL_MAX_TEXTURE_SIZE: %d", _maxTextureSize);
    GHGLDebug(@"Supports BGRA8888 textures: %d", _supportsBGRA8888);
    GHGLDebug(@"Supports NPOT textures: %d", _supportsNPOT);
			
		_animationInterval = 1.0 / 10.0;
		
		// A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
		// class is used as fallback when it isn't available.
		// _displayLinkSupported = ([[[UIDevice currentDevice] systemVersion] compare:@"3.1" options:NSNumericSearch] != NSOrderedAscending);	
	}
	return self;
}

- (void)dealloc {
	[self stopAnimation];
	
	if ([EAGLContext currentContext] == _context) 
		[EAGLContext setCurrentContext:nil];
	
	[_context release];  
  [_drawable release];
	[super dealloc];
}

- (void)drawView {
  if (!_drawable) return;
  glBindFramebufferOES(GL_FRAMEBUFFER_OES, _viewFramebuffer);
  BOOL render = YES;
  while (render) {
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    render = [_drawable drawView:frame inView:self];
    if (render) {
      glBindRenderbufferOES(GL_RENDERBUFFER_OES, _viewRenderbuffer);
      [_context presentRenderbuffer:GL_RENDERBUFFER_OES];
    }
  }
}

- (void)layoutSubviews {
  if (!_drawable) return;
	[EAGLContext setCurrentContext:_context];
	[self _destroyFramebuffer];
	[self _createFramebuffer];
	[self drawView];
}

- (void)setDrawable:(id<GHGLViewDrawable>)drawable {
  [drawable retain];
  [_drawable release];
  _drawable = drawable;
  [self setNeedsLayout];
}

- (BOOL)_createFramebuffer {    
	glGenFramebuffersOES(1, &_viewFramebuffer);
	glGenRenderbuffersOES(1, &_viewRenderbuffer);
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, _viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, _viewRenderbuffer);
	[_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _viewRenderbuffer);
	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &_backingHeight);
	
	if (USE_DEPTH_BUFFER) {
		glGenRenderbuffersOES(1, &_depthRenderbuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, _depthRenderbuffer);
		glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, _backingWidth, _backingHeight);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, _depthRenderbuffer);
	}
	
	if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
		GHGLDebug(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		return NO;
	}
	
	[_drawable setupView:self];
	return YES;
}

- (void)_destroyFramebuffer {
	glDeleteFramebuffersOES(1, &_viewFramebuffer);
	_viewFramebuffer = 0;
	glDeleteRenderbuffersOES(1, &_viewRenderbuffer);
	_viewRenderbuffer = 0;
	
	if (_depthRenderbuffer) {
		glDeleteRenderbuffersOES(1, &_depthRenderbuffer);
		_depthRenderbuffer = 0;
	}
}

- (void)startAnimation {
	if (_displayLinkSupported) {
		// CADisplayLink is API new to iPhone SDK 3.1. Compiling against earlier versions will result in a warning, but can be dismissed
		// if the system version runtime check for CADisplayLink exists in -initWithCoder:. The runtime check ensures this code will
		// not be called in system versions earlier than 3.1.
		
//		_displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawView)];
//		[_displayLink setFrameInterval:_animationInterval];
//		[_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	} else {	
		self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:_animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];
	}
}

- (void)stopAnimation {
	if (_displayLinkSupported) {
		[_displayLink invalidate];
		_displayLink = nil;
	} else {	
		self.animationTimer = nil;
	}
}

- (void)setAnimationTimer:(NSTimer *)timer {
	[_animationTimer invalidate];
	_animationTimer = timer;
}

- (void)setAnimationInterval:(NSTimeInterval)animationInterval {
	_animationInterval = animationInterval;
	if (_animationTimer) {
		[self stopAnimation];
		[self startAnimation];
	}
}

@end


@implementation GHGLViewDrawable

- (void)dealloc {
  glDeleteTextures(1, &_videoTexture[0]);
  [super dealloc];
}

- (void)setupView:(GHGLView *)view {
  glViewport(0, 0, view.backingWidth, view.backingHeight);
  GHGLDebug(@"Viewport: (%d, %d, %d, %d)", 0, 0, view.backingWidth, view.backingHeight);
	glMatrixMode(GL_PROJECTION);
  
	glLoadIdentity();
  
	glOrthof(0, view.backingWidth, view.backingHeight, 0, -100, 100);
	glMatrixMode(GL_MODELVIEW);
  
  glEnable(GL_TEXTURE_2D);
  glGenTextures(1, &_videoTexture[0]);
}

- (void)drawInRect:(CGRect)rect {
  
  // Portrait
  /*
   const GLfloat vertices[] = {
   rect.origin.x, rect.origin.y,
   rect.origin.x + rect.size.width, rect.origin.y,
   rect.origin.x, rect.origin.y + rect.size.height,
   rect.origin.x + rect.size.width, rect.origin.y + rect.size.height
   };
   
   // Coords flipped so we appear right side up
   const GLfloat texCoords[] = {
   0, 0,
   1, 0,
   0, 1,
   1, 1,
   };
   */
  
  // Landscape
  const GLfloat vertices[] = {
    rect.origin.y, rect.origin.x,
    rect.origin.y, rect.origin.x + rect.size.width,
    rect.origin.y + rect.size.height, rect.origin.x, 
    rect.origin.y + rect.size.height, rect.origin.x + rect.size.width,
	};
	
	const GLfloat texCoords[] = {
    0, 1,
    1, 1,
    0, 0,
    1, 0,
  };  
  
  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D, _videoTexture[0]);
  glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
	
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

- (BOOL)drawView:(CGRect)frame inView:(GHGLView *)view {
  // Subclasses should implement
  return NO;
}

@end