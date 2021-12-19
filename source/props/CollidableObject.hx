package props;

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

typedef ObjectData = 
{
	type:ObjectType,
	imagePath:flixel.system.FlxAssets.FlxGraphicAsset
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
		this.type = dataFromInt(type).type;

		velocity.set(-moveVelocity, -moveVelocity);

		loadGraphic(dataFromInt(type).imagePath);
	}

	function dataFromInt(type:Int):ObjectData
	{
		switch (type)
		{
			case 0: return {type: Rock, imagePath: "assets/images/rock.png"};
			case 1: return {type: Good, imagePath: "assets/images/thegood.png"};
			case 2: return {type: Ice, imagePath: "assets/images/ice.png"};
			default: return {type: Rock, imagePath: "assets/images/rock.png"};
		}
	}
}