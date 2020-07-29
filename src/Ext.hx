
import haxe.Timer;
class Ext extends dn.Process {
	
	public var boolMap = new Map<Entity, Map<String, Bool>>();

	var game(get,never) : Game; inline function get_game() return Game.ME;

	public function new() {
		super(Game.ME);
	}
	
	public function setS(entity:Entity, string:String, duration:Float) {

		if(boolMap.exists(entity) == false) boolMap.set(entity, new Map<String, Bool>());
		
		boolMap[entity].set(string, true);
		var timer = new haxe.Timer(Std.int(duration*1000));
		timer.run = function() {
			if(entity == null)
			{
				boolMap.remove(entity);
				return;
			}
			if (boolMap.exists(entity) == false)return;
			if (boolMap[entity].exists(string) == false)return;
			boolMap[entity][string] = false;
			timer.stop();
		}
	}
	public function get(entity:Entity, string:String):Bool
	{
		return boolMap[entity][string];
	}

	public function clear() {
		// boolMap = null;
		boolMap.clear();
	}
	override function update() {
		super.update();

	}
	override public function onDispose() {
		super.onDispose();
		clear();
	}
}