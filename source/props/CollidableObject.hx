package props;

import utils.Util;
import states.PlayState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

enum ObjectType 
{
	Rock;
	Good;
	Ice;
}

typedef OffsetData =
{
	offsetX:Float,
	offsetY:Float,
	width:Float,
	height:Float
}

typedef ObjectData = 
{
	type:ObjectType,
	imagePath:flixel.system.FlxAssets.FlxGraphicAsset//,
	//offsetData:OffsetData
}

enum GenerationType
{
	Classic;
	Experimental;
}

class CollidableObject extends FlxSprite
{
	public var typeData:ObjectData;
	public var type:ObjectType;

	public var onCollision:Void->Void;

	var moveVelocity:Int = 465;

	public function new(X:Float = 0, Y:Float = 0, type:Int = 0)
	{
		super(X, Y);
		immovable = true;

		typeData = dataFromInt(type);
		this.type = typeData.type;

		velocity.set(-moveVelocity, -moveVelocity);

		loadGraphic(typeData.imagePath);
		setGraphicSize(Std.int(width / 4), Std.int(height / 4));
		updateHitbox();

		width = 128;
		height = 128;
		centerOffsets();
	}

	function dataFromInt(type:Int):ObjectData
	{
		switch (type)
		{
			case 0: return {type: Rock, imagePath: "assets/images/rock" + Util.getRandomInt(3) + ".png"};
			case 1: return {type: Good, imagePath: "assets/images/thegood.png"};
			case 2: return {type: Ice, imagePath: "assets/images/ice" + Util.getRandomInt(2) + ".png"};
			default: return {type: Rock, imagePath: "assets/images/rock.png"};
		}
	}

	public static function generateType(generationType:GenerationType):Int
	{
		var type:Int = 0;

		if (generationType == Classic)
		{
			if (FlxG.random.bool(70))
				type = 0;
			if (FlxG.random.bool(45))
				type = 2;
			if (FlxG.random.bool(25))
				type = 1;
		}
		else if (generationType == Experimental)
		{
			var num = Util.getRandomInt(1000);

			// 500, 700, 1000

			if (num >= 0 && num < 500)
				type = 0;
			if (num >= 500 && num < 700)
				type = 2;
			if (num >= 700 && num < 1000)
				type = 1;
		}

		return type;
	}
}