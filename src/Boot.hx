class Boot extends hxd.App {
	public static var ME : Boot;

	// Boot
	static function main() {
		new Boot();
	}

	// Engine ready
	override function init() {
		ME = this;
		new Main(s2d);
		onResize();
	}

	override function onResize() {
		super.onResize();
		dn.Process.resizeAll();
	}

	public inline function isSlowMo() return speed<1;
	public var speed = 1.0;
	public var fixedTimestepAccumulator:Float = 0;
	public var fixedTimestepAccumulatorRatio:Float;
	public var deltaTimeNormal:Float = 0.016666;
	public var additionnalGameFrame:Int = 0;
	public var currentTime:Float = 0;

	override function update(deltaTime:Float) {
		super.update(deltaTime);

		var tmod = hxd.Timer.tmod * ( ui.Modal.hasAny() ? 1 : speed );
		
		var dt:Float = hxd.Timer.dt;

		var MAX_STEPS:Int = 5;

		fixedTimestepAccumulator += dt;
		var nSteps:Int = Math.floor(fixedTimestepAccumulator / deltaTimeNormal);
		if (nSteps > 0) {
			fixedTimestepAccumulator -= nSteps * deltaTimeNormal;
		}
		fixedTimestepAccumulatorRatio = fixedTimestepAccumulator / deltaTimeNormal;
		var nStepsClamped:Int = Std.int(Math.min(nSteps, MAX_STEPS)) + additionnalGameFrame;
		additionnalGameFrame = 0;
		// trace(nStepsClamped);
		// for (i in 0...nStepsClamped){
			// dn.heaps.Controller.beforeUpdate();
			// dn.Process.updateAll(deltaTimeNormal * hxd.Timer.wantedFPS);
		// }
		dn.heaps.Controller.beforeUpdate();
		dn.Process.updateAll(tmod);
	}
}

