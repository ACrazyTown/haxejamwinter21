package props;

import utils.Util;
import haxe.xml.Fast;
import flixel.FlxG;
import flixel.FlxSprite;

class Player extends FlxSprite
{
    public var maxLives:Int = 3;
    public var lives:Int = 3;

    public var maxSpeed:Float = 550;
    public var speed:Float = 450;
    private var speedMultiplier:Float = 3.75; // probs not a multiplier maybe im just D

    public var iced:Bool = false;

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

        //iced = true;
    }

    override function update(elapsed:Float):Void
    {
        movementCheck();

		var angleAmount = Util.mapToRange(velocity.x, 0, speed, 0, 8);

        if (velocity.x != 0)
            angle += angleAmount;

		super.update(elapsed);
    }

    public function updateMovementType(iceEffect:Bool)
    {
		velocity.set();
		acceleration.set();

        if (iceEffect)
        {
			maxVelocity.set(speed * 1.25);
			drag.x = maxVelocity.x * 0.85;
        }
        else
        {
            maxVelocity.set();
            drag.x = 0;
        }
        
        iced = iceEffect;
    }

    function movementCheck()
    {
        if (!iced)
        {
            velocity.x = 0;

            if (FlxG.keys.anyPressed([LEFT, A]) && FlxG.keys.anyPressed([RIGHT, D]))
                velocity.x = 0;

            if (FlxG.keys.anyPressed([LEFT, A]))
            {
                angle -= ((maxSpeed / speed) * speedMultiplier);
                velocity.x = -speed;
            }
            else if (FlxG.keys.anyPressed([RIGHT, D]))
            {	
                angle += ((maxSpeed / speed) * speedMultiplier);
                velocity.x = speed;
            }
        }
        else
        {
            acceleration.x = 0;

			if (FlxG.keys.anyPressed([LEFT, A]) && FlxG.keys.anyPressed([RIGHT, D]))
				acceleration.x = 0;

			if (FlxG.keys.anyPressed([LEFT, A]))
			{
				acceleration.x = -(maxVelocity.x * 6);
			}
			else if (FlxG.keys.anyPressed([RIGHT, D]))
			{
				acceleration.x = maxVelocity.x * 6;
			}
        }
    }
}