static BOOL shouldCreate = YES;
static BOOL is24Hr = NO;
static CGFloat xStart;

%hook CCUIStatusBar

	- (void)layoutSubviews {
		%orig;
		if(shouldCreate) {
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			is24Hr ? [dateFormatter setDateFormat:@"HH:mm"] :
				[dateFormatter setDateFormat:@"h:mm a"];

			UILabel *CCTime = [[UILabel alloc] initWithFrame:CGRectMake(xStart, 17.333, 75, 16)];
			[CCTime setTextColor:[UIColor whiteColor]];
			[CCTime setFont:[UIFont fontWithName:@".SFUIText-Semibold" size:13]];
			CCTime.textAlignment = NSTextAlignmentCenter;
			CCTime.text = [dateFormatter stringFromDate: [NSDate date]];
			[self addSubview:CCTime];
			[CCTime release];
			[dateFormatter release];

			shouldCreate = NO;
			[NSTimer scheduledTimerWithTimeInterval:1.0
			    target:self
			    selector:@selector(setShouldCreate)
			    userInfo:nil
			    repeats:NO];
		}
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

%hook UIDateLabel

	- (BOOL)use24HourTime {
		is24Hr = %orig;
		return is24Hr;
	}

%end