static BOOL shouldCreate = YES;
static CGFloat xStart = 150;

%hook CCUIStatusBar

	- (void)layoutSubviews {
		if(shouldCreate) {
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"h:mm a"];

			UILabel *CCTime = [[UILabel alloc] initWithFrame:CGRectMake(xStart, 17, 75, 16)];
			[CCTime setTextColor:[UIColor whiteColor]];
			[CCTime setFont:[UIFont fontWithName:@".SFUIText-Semibold" size:13]];
			CCTime.text = [dateFormatter stringFromDate: [NSDate date]];
			CCTime.textAlignment = NSTextAlignmentCenter;
			[self addSubview:CCTime];
			[CCTime release];

			shouldCreate = NO;
			[NSTimer scheduledTimerWithTimeInterval:1.0
			    target:self
			    selector:@selector(setShouldCreate)
			    userInfo:nil
			    repeats:NO];
		}
		%orig;
	}

	- (id)initWithFrame:(CGRect)rect {
		xStart = rect.size.width == 375 ? 150 : 368;
		return %orig;
	}

	%new

	- (void)setShouldCreate {
		shouldCreate = YES;
	}

%end