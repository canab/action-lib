package actionlib.motion
{
	/**
	 * Creates new tween. It just calls TweenManager.tween(...)
	 * @param target
	 * target object
	 * @param duration
	 * Tween time in milliseconds. If omitted defaultDuration value will be used.
	 *
	 * @see actionlib.motion.TweenManager.defaultDuration
	 *
	 * @see actionlib.motion.TweenManager
	 */
	public function tween(target:Object, duration:int = -1):Tweener
	{
		return TweenManager.tween(target, duration);
	}
}
