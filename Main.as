package 
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Main extends MovieClip
	{
		var focalLength:Number = 250;
		var centerPoint:Point = new Point((stage.stageWidth / 2), (stage.stageHeight / 2));
		var gravity:Number = 0.24;
		var backLeft:Boolean = false;
		var backRight:Boolean = false;
		var frontLeft:Boolean = false;
		var frontRight:Boolean = false;
		var lowering:Boolean = false;
		var releaseRover:Boolean;
		var rover:Rover = new Rover;
		var originalRovePod:Array;
		var originalRover:Array;
		var rovePod:RoverPod = new RoverPod;
		var scale:Number;
		var goalBox:Box = new Box;
		var goalBoxPnts:Array;
		var goalBoxZ:Number;
		var boxScale:Number;
		
		public function Main()
		{
			addChild(rover);
			addChild(rovePod);
			addChild(goalBox);
			Init();
		}
		public function Init()
		{
			releaseRover = false;
			
			rovePod.x = 400;
			rovePod.y = -452;
			rovePod.myZ = 700;
			
			originalRovePod = new Array(400, 452);
			
			rover.x = 400;
			rover.y = -300;
			rover.myZ = 700;
			
			originalRover = new Array(400, -300);
			
			trace(rover.width);
			trace(rover.height);
			
			goalBox.x = (Math.random() + 0.1) * 700;
			goalBox.y = 600;
			goalBox.width = 224;
			goalBox.height = 168;
			goalBoxZ = (Math.random() + 1) * 300;
			boxScale = focalLength / (focalLength + goalBoxZ);
			
			goalBoxPnts = new Array(goalBox.x - centerPoint.x, goalBox.y - centerPoint.y);
			
			goalBox.width *= boxScale;
			goalBox.height *= boxScale;
			goalBox.x = centerPoint.x + (goalBoxPnts[0] * boxScale);
			goalBox.y = centerPoint.y + (goalBoxPnts[1] * boxScale);
			
			trace(goalBox.x + " " + goalBox.y + " " +  goalBox.width + " " + goalBox.height);
			
			addChild(goalBox);
			
			rover.dy = 0;
			rover.dx = 0;
			rover.dz = 0;
			
			rovePod.dy = 0;
			rovePod.dx = 0;
			rovePod.dz = 0;
			
			rover.dy += gravity;
			rovePod.dy += gravity;
			
			originalRovePod[0] = rovePod.x - centerPoint.x;
			originalRovePod[1] = rovePod.y - centerPoint.y;
			
			originalRover[0] = rover.x - centerPoint.x;
			originalRover[1] = rover.y - centerPoint.y;
			
			scale =  focalLength / (focalLength + rover.myZ);
			
			rover.scaleX = rover.scaleY = scale;
			rovePod.scaleX = rovePod.scaleY = scale;
			
			rovePod.x = centerPoint.x + (originalRovePod[0] * scale);
			rovePod.y = centerPoint.y + (originalRovePod[1] * scale);
			
			rover.x = centerPoint.x + (originalRover[0] * scale);
			rover.y = centerPoint.y + (originalRover[1] * scale);
			
			stage.addEventListener(Event.ENTER_FRAME, Update);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyPress);
			stage.addEventListener(KeyboardEvent.KEY_UP, KeyRelease);
		}
		public function Update(e:Event)
		{
			rover.dy += gravity;
			rovePod.dy += gravity;
			
			if(backLeft)
			{
				if(!releaseRover)
				{
					rover.dy -= 0.1;
					rover.dx += 0.05;
					rover.dz -= 0.05;
				}
				rovePod.dy -= 0.1;
				rovePod.dx += 0.05;
				rovePod.dz -= 0.05;
			}
			
			if(frontLeft)
			{
				if(!releaseRover)
				{
					rover.dy -= 0.1;
					rover.dx += 0.05;
					rover.dz += 0.05;
				}
				rovePod.dy -= 0.1;
				rovePod.dx += 0.05;
				rovePod.dz += 0.05;
			}
			
			if(frontRight)
			{
				if(!releaseRover)
				{
					rover.dx -= 0.05;
					rover.dz += 0.05;
					rover.dy -= 0.1;
				}
				rovePod.dy -= 0.1;
				rovePod.dx -= 0.05;
				rovePod.dz += 0.05;
			}
			
			if(backRight)
			{
				if(!releaseRover)
				{
					rover.dy -= 0.1;
					rover.dx -= 0.05;
					rover.dz -= 0.05;
				}
				rovePod.dy -= 0.1;
				rovePod.dx -= 0.05;
				rovePod.dz -= 0.05;
			}
			
			if(lowering)
			{
				originalRover[1] += 1;
			}
			
			scale =  focalLength / (focalLength + rover.myZ);
			
			originalRover[1] += (rover.dy * scale);
			originalRovePod[1] += (rovePod.dy * scale);
			
			if(originalRover[1] + rover.width >= 600)
			{
				if(rover.hitTestObject(goalBox))
				{
					if(releaseRover)
					{
						if(rover.dy <= 1)
						{
							cond_txt.text = "Congratulation you landed it!";
						}
						else
						{
							cond_txt.text = "Oh no! The rover was going to fast! It's broken!";
						}
					}
					else
					{
						cond_txt.text = "Oh no! You forgot to release the rover!";
					}
				}
				else
				{
					cond_txt.text = "Oh no! The rover wasn't in the goal area!";
				}
				stage.removeEventListener(Event.ENTER_FRAME, Update);
			}
			
			originalRover[0] += (rover.dx * scale);
			originalRovePod[0] += (rovePod.dx * scale);
			
			rover.myZ += rover.dz;
			rovePod.myZ += rovePod.dz;
			
			rover.scaleX = rover.scaleY = scale;
			rovePod.scaleX = rovePod.scaleY = scale;
			
			rovePod.x = centerPoint.x + (originalRovePod[0] * scale);
			rovePod.y = centerPoint.y + (originalRovePod[1] * scale);
			
			rover.x = centerPoint.x + (originalRover[0] * scale);
			rover.y = centerPoint.y + (originalRover[1] * scale);
			
			rover.tabIndex = 1;
			goalBox.tabIndex = 2;
			
			if(rover.myZ >= goalBoxZ)
			{
				trace(rover.tabIndex);
				trace(goalBox.tabIndex);
			}
			
			graphics.clear();
			if(!releaseRover)
			{
				graphics.lineStyle(2, 0xFFFFFF);
				graphics.moveTo(rovePod.x - (rovePod.width / 2), rovePod.y);
				graphics.lineTo(rover.x - rover.width, rover.y);
			}
			
		}
		public function KeyPress(e:KeyboardEvent)
		{
			if(e.keyCode == Keyboard.W)
			{
				backLeft = true;
			}
			if(e.keyCode == Keyboard.C)
			{
				frontLeft = true;
			}
			
			if(e.keyCode == Keyboard.N)
			{
				frontRight= true;
			}
			
			if(e.keyCode == Keyboard.I)
			{
				backRight = true;
			}
			
			if(e.keyCode == Keyboard.SPACE)
			{
				lowering = true;
			}
			
			if(e.keyCode == Keyboard.SHIFT)
			{
				releaseRover = true;
			}
			
			if(e.keyCode == Keyboard.R)
			{
				Init();
			}
		}
		public function KeyRelease(e:KeyboardEvent)
		{
			if(e.keyCode == Keyboard.W)
			{
				backLeft = false;
			}
			if(e.keyCode == Keyboard.C)
			{
				frontLeft = false;
			}
			
			if(e.keyCode == Keyboard.N)
			{
				frontRight= false;
			}
			
			if(e.keyCode == Keyboard.I)
			{
				backRight = false;
			}
			
			if(e.keyCode == Keyboard.SPACE)
			{
				lowering = false;
			}
		}
	}
	
}
