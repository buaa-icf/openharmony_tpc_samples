import curves from '@ohos.curves';


let obj = {
  'translateFromCenter': {x:0,y:0},
  'translateFromTop': {x:0,y:-350},
  'translateFromBottom': {x:0,y:350},
  'translateFromLeft': {x:-200,y:0},
  'translateFromRight': {x:200,y:0},
  'translateFromLeftTop': {x:-200,y:-350},
  'translateFromLeftBottom': {x:-200,y:350},
  'translateRightTop': {x:200,y:-350},
  'translateFromRightBottom': {x:200,y:350},
}
export  function animation(val) {

  let effect: TransitionEffect =
  TransitionEffect.OPACITY
    .animation({ duration: 2000, curve: Curve.Ease })
    // .combine(TransitionEffect.translate(obj[val]))
    .combine(TransitionEffect.translate(obj[val]).animation({ curve: curves.springMotion() }))
    // .combine(  TransitionEffect.asymmetric(TransitionEffect.move(obj[val]), TransitionEffect.move(TransitionEdge.START)))
    // .combine(TransitionEffect.move(TransitionEdge.START))
  return effect
}


