static BOOL shouldCreate = YES;
static NSString *timeString = @"error";

%hook CCUIStatusBar

	- (void)layoutSubviews {
		if(shouldCreate) {
			UILabel *CCTime = [[UILabel alloc] initWithFrame:CGRectMake(150, 16, 75, 16)];
			[CCTime setTextColor:[UIColor whiteColor]];
			[CCTime setFont:[UIFont fontWithName:@".SFUIText-Semibold" size:13]];
			CCTime.text = timeString;
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

	%new

	- (void)setShouldCreate {
		shouldCreate = YES;
	}

%end

%hook _UIStatusBarStringView
	
	- (void)setOriginalText:(NSString *)time {
		timeString = time;
		%orig;
	}

%end