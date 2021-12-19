package props;

import flixel.FlxG;
import flixel.FlxSprite;

class Player extends FlxSprite
{
    public var maxLives:Int = 3;
    public var lives:Int = 3;

    public var maxSpeed:Float = 550;
    public var speed:Float = 450;
    private var speedMultiplier:Float = 5; // probs not a multiplier maybe im just D

    public function new(X:Float = 0, Y:Float = 0)
    {
        super(X, Y);

        loadGraphic("assets/images/snowball.png");
		setGraphicSize(Std.int(width / 1.75), Std.int(height / 1.75));
        updateHitbox();

        // fix lousy ass collision
		width = 120;
        height = 120;
        centerOffsets();
    }

    override function update(elapsed:Float):Void
    {
        movementCheck();

		super.update(elapsed);
    }

    function movementCheck()
    {
        velocity.set();

		if (FlxG.keys.anyPressed([LEFT, A]) && FlxG.keys.anyPressed([RIGHT, D]))
            velocity.x = 0;

        if (FlxG.keys.anyPressed([LEFT, A]))
        {
			angle += -((maxSpeed / speed) * speedMultiplier);
            velocity.x = -speed;
        }
        else if (FlxG.keys.anyPressed([RIGHT, D]))
        {	
			angle += ((maxSpeed / speed) * speedMultiplier);
            velocity.x = speed;
        }
    }
}