//
// Modified from Jeff Lamarche's OpenGL ES Template for XCode
// http://iphonedevelopment.blogspot.com/2009/05/opengl-es-from-ground-up-table-of.html
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@class GHGLView;

@protocol GHGLViewDrawable <NSObject>
- (BOOL)drawView:(CGRect)frame inView:(GHGLView *)view;
- (void)setupView:(GHGLView *)view;
@end

@interface GHGLView : UIView {
	GLint _backingWidth;
	GLint _backingHeight;
    
	EAGLContext *_context;    
	GLuint _viewRenderbuffer;
	GLuint _viewFramebuffer;
	GLuint _depthRenderbuffer;
      
	NSTimer *_animationTimer;
	NSTimeInterval _animationInterval;
	
	// Use of the CADisplayLink class is the preferred method for controlling your animation timing.
	// CADisplayLink will link to the main display and fire every vsync when added to a given run-loop.
	// The NSTimer class is used only as fallback when running on a pre 3.1 device where CADisplayLink
	// isn't available.
	id _displayLink;
	BOOL _displayLinkSupported;
    
	id<GHGLViewDrawable> _drawable; // weak
		
}
@property (assign, nonatomic) NSTimeInterval animationInterval;
@property (retain, nonatomic) id<GHGLViewDrawable> drawable;
@property (readonly, nonatomic) GLint backingWidth;
@property (readonly, nonatomic) GLint backingHeight;


- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView;

@end
