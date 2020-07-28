package en;

import dn.Rand;

class Mob extends Entity {
	public static var ALL : Array<Mob> = [];
	public var life = 1;
	public var speed = 0.1;
	public var jumpPower = 0.8;

	public function new(x,y) {
		super(x,y);
		ALL.push(this);

		var g = new h2d.Graphics(spr);
		g.beginFill(options.baseArt ? 0xffcc00 : 0xffffff);
		g.drawRect(-radius, -hei, radius*2, hei);
		gravMass = 0.4;
		var g = new h2d.Graphics(spr);
		g.beginFill(options.baseArt ? 0x000000 : 0xffffff);
		g.drawRect(0, -hei/2, radius, hei/2);
		entityRepel = false;
	}

	override function dispose() {
		super.dispose();
		ALL.remove(this);
	}

	override function isAlive():Bool {
		return super.isAlive() && life>0;
	}
	

	public function hit(dmg:Int, impactDir:Int) {
		life-=dmg;

		if( options.mobSquashAndStrech )
			skew(0.6, 1.35);

		if( options.physicalReactions )
			if( !cd.hasSetS("firstImpact",0.4) )
				bump(impactDir * rnd(0.040, 0.060), -0.05);
			else
				bump(impactDir*rnd(0.005,0.010), 0);

		if( options.blinkImpact )
			blink(0xffffff);

		if( options.lighting )
			fx.lightSpot(centerX+rnd(0,15)*-impactDir, centerY+rnd(0,8,true), 0xff0000, rnd(0.15,0.18));

		if( options.blood ) {
			fx.bloodBackHits(centerX, centerY, impactDir, 2);
			fx.bloodFrontHits(centerX, centerY, -impactDir, 0.6);
		}

		if( life<=0 ) {
			life = 0;
			onDie();
		}
	}
	
	
	function onDie() {
		if( options.cadavers )
			new en.Cadaver(this);

		destroy();
	}
	public function makeChoice() {
		
		
		var rand = Std.int(rnd(0,100,true));
		if(rand ==0) shoot();
		if (rand >50)move(dir);
		if (rand >80){
			if (hero.cy < cy) jump();
		}
		else 
			move(dir);
	}
	public function shoot(){
		var b = new en.Bullet(this,0, true);
		if (options.randomizeBullets)
			b.ang += 0.04 - rnd(0, 0.065);
		b.speed = options.randomizeBullets ? rnd(0.5, 0.6) : 1;
	}
	public function move(side:Int) {
		dx = speed*side;
		spr.scaleX = side;
	}
	public function jump() {

		if(onGround) dy = -jumpPower;
	}
	public function stopMoving() {
		dx = 0;
	}

	override function update() {
		super.update();
		dir = dirTo(hero);

		if (!onGround && dy < 0 && dy > -0.2)
			gravMass = 0.2;
		else
			gravMass = 0.4;

		
		// trace(cx + "    " + cy);
		// trace(hero.cx + "    " + hero.cy);
		var bool = checkLine(cx, cy, hero.cx, hero.cy, function(x, y) return !game.level.hasCollision(x, y));
		if(bool)
		{
			makeChoice();
		} 
		else stopMoving();
		// trace("bool : " + bool);
	}
}