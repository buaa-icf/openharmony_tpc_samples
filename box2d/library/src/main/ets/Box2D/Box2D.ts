/*
* Copyright (c) 2006-2009 Erin Catto http://www.box2d.org
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/

/**
 * \mainpage Box2D API Documentation
 * \section intro_sec Getting Started
 * For documentation please see http://box2d.org/documentation.html
 * For discussion please visit http://box2d.org/forum
 */

// These include files constitute the main Box2D API

// Common
export {
  b2Assert,
  b2Maybe,
  b2_maxFloat,
  b2_epsilon,
  b2_epsilon_sq,
  b2_pi,
  b2_maxManifoldPoints,
  b2_maxPolygonVertices,
  b2_aabbExtension,
  b2_aabbMultiplier,
  b2_linearSlop,
  b2_angularSlop,
  b2_polygonRadius,
  b2_maxSubSteps,
  b2_maxTOIContacts,
  b2_velocityThreshold,
  b2_maxLinearCorrection,
  b2_maxAngularCorrection,
  b2_maxTranslation,
  b2_maxTranslationSquared,
  b2_maxRotation,
  b2_maxRotationSquared,
  b2_baumgarte,
  b2_toiBaumgarte,
  b2_invalidParticleIndex,
  b2_maxParticleIndex,
  b2_timeToSleep,
  b2_linearSleepTolerance,
  b2_particleStride,
  b2_minParticleWeight,
  b2_maxParticlePressure,
  b2_maxTriadDistance,
  b2_maxTriadDistanceSquared,
  b2_minParticleSystemBufferCapacity,
  b2_barrierCollisionTime,
  b2_angularSleepTolerance,
  b2Alloc,
  b2Free,
  b2Log,
  b2Version,
  b2_version,
  b2_branch,
  b2_commit,
  b2ParseInt,
  b2ParseUInt,
  b2MakeArray,
  b2MakeNullArray,
  b2MakeNumberArray,
  b2_maxParticleForce,
} from "./Common/b2Settings";

export {
  b2_pi_over_180,
  b2_180_over_pi,
  b2_two_pi,
  b2Abs,
  b2Min,
  b2Max,
  b2Clamp,
  b2Swap,
  b2IsValid,
  b2Sq,
  b2InvSqrt,
  b2Sqrt,
  b2Pow,
  b2DegToRad,
  b2RadToDeg,
  b2Cos,
  b2Sin,
  b2Acos,
  b2Asin,
  b2Atan2,
  b2NextPowerOfTwo,
  b2IsPowerOfTwo,
  b2Random,
  b2RandomRange,
  XY,
  b2Vec2,
  b2Vec2_zero,
  XYZ,
  b2Vec3,
  b2Mat22,
  b2Mat33,
  b2Rot,
  b2Transform,
  b2Sweep
} from "./Common/b2Math";

export {
  RGB, RGBA, b2Draw, b2DrawFlags, b2Color
} from "./Common/b2Draw";

export {
  b2Timer, b2Counter
} from "./Common/b2Timer";

export {
  b2GrowableStack
} from "./Common/b2GrowableStack";

export {
  b2BlockAllocator
} from "./Common/b2BlockAllocator";

export {
  b2StackAllocator
} from "./Common/b2StackAllocator";

// Collision
export {
  b2ContactFeatureType,
  b2Manifold,
  b2ManifoldType,
  b2ContactFeature,
  b2ContactID,
  b2WorldManifold,
  b2ClipVertex,
  b2RayCastInput,
  b2RayCastOutput,
  b2ManifoldPoint,
  b2AABB,
  b2PointState,
  b2TestOverlapAABB,
  b2ClipSegmentToLine,
  b2TestOverlapShape,
  b2GetPointStates
} from "./Collision/b2Collision";

export {
  b2_gjkCalls,
  b2_gjkIters,
  b2_gjkMaxIters,
  b2ShapeCast,
  b2DistanceInput,
  b2DistanceOutput,
  b2DistanceProxy,
  b2SimplexCache,
  b2ShapeCastInput,
  b2ShapeCastOutput,
  b2_gjk_reset,
  b2SimplexVertex,
  b2Simplex,
  b2Distance
} from "./Collision/b2Distance";

export {
  b2BroadPhase, b2Pair, b2PairLessThan
} from "./Collision/b2BroadPhase";

export {
  b2DynamicTree, b2TreeNode
} from "./Collision/b2DynamicTree";

export {
  b2TOIInput,
  b2TOIOutput,
  b2TOIOutputState,
  b2_toiTime,
  b2_toiMaxTime,
  b2_toiCalls,
  b2_toiIters,
  b2_toiMaxIters,
  b2_toiRootIters,
  b2_toiMaxRootIters,
  b2_toi_reset,
  b2SeparationFunctionType,
  b2SeparationFunction,
  b2TimeOfImpact
} from "./Collision/b2TimeOfImpact";

export {
  b2CollideCircles, b2CollidePolygonAndCircle
} from "./Collision/b2CollideCircle";

export {
  b2CollidePolygons
} from "./Collision/b2CollidePolygon";

export {
  b2CollideEdgeAndCircle, b2CollideEdgeAndPolygon
} from "./Collision/b2CollideEdge";

// Collision Shapes
export {
  b2Shape, b2ShapeType, b2MassData
} from "./Collision/Shapes/b2Shape";

export {
  b2CircleShape
} from "./Collision/Shapes/b2CircleShape";

export {
  b2PolygonShape
} from "./Collision/Shapes/b2PolygonShape";

export {
  b2EdgeShape
} from "./Collision/Shapes/b2EdgeShape";

export {
  b2ChainShape
} from "./Collision/Shapes/b2ChainShape";

// Dynamics
export {
  b2IFilter, b2Filter, b2IFixtureDef, b2FixtureProxy, b2Fixture, b2FixtureDef
} from "./Dynamics/b2Fixture";

export {
  b2Body, b2BodyDef, b2BodyType, b2IBodyDef
} from "./Dynamics/b2Body";

export {
  b2World
} from "./Dynamics/b2World";

export {
  b2DestructionListener,
  b2ContactFilter,
  b2ContactImpulse,
  b2QueryCallbackFunction,
  b2RayCastCallbackFunction,
  b2ContactListener,
  b2QueryCallback,
  b2RayCastCallback
} from "./Dynamics/b2WorldCallbacks";

export {
  b2Island
} from "./Dynamics/b2Island";

export {
  b2Profile, b2TimeStep, b2Position, b2Velocity, b2SolverData
} from "./Dynamics/b2TimeStep";

export {
  b2ContactManager
} from "./Dynamics/b2ContactManager";

// Dynamics Contacts
export {
  b2MixFriction, b2MixRestitution, b2Contact, b2ContactEdge
} from "./Dynamics/Contacts/b2Contact";

export {
  b2ContactRegister, b2ContactFactory
} from "./Dynamics/Contacts/b2ContactFactory";

export {
  g_blockSolve,
  b2VelocityConstraintPoint,
  b2ContactVelocityConstraint,
  b2ContactSolver,
  b2ContactSolverDef,
  b2ContactPositionConstraint,
  b2PositionSolverManifold
} from "./Dynamics/Contacts/b2ContactSolver";

export {
  b2CircleContact
} from "./Dynamics/Contacts/b2CircleContact";

export {
  b2PolygonContact
} from "./Dynamics/Contacts/b2PolygonContact";

export {
  b2PolygonAndCircleContact
} from "./Dynamics/Contacts/b2PolygonAndCircleContact";

export {
  b2EdgeAndCircleContact
} from "./Dynamics/Contacts/b2EdgeAndCircleContact";

export {
  b2EdgeAndPolygonContact
} from "./Dynamics/Contacts/b2EdgeAndPolygonContact";

export {
  b2ChainAndCircleContact
} from "./Dynamics/Contacts/b2ChainAndCircleContact";

export {
  b2ChainAndPolygonContact
} from "./Dynamics/Contacts/b2ChainAndPolygonContact";

// Dynamics Joints
export {
  b2Joint,
  b2JointDef,
  b2JointEdge,
  b2JointType,
  b2LimitState,
  b2Jacobian,
  b2IJointDef
} from "./Dynamics/Joints/b2Joint";

export {
  b2IAreaJointDef, b2AreaJoint, b2AreaJointDef
} from "./Dynamics/Joints/b2AreaJoint";

export {
  b2DistanceJoint, b2DistanceJointDef, b2IDistanceJointDef
} from "./Dynamics/Joints/b2DistanceJoint";

export {
  b2FrictionJoint, b2FrictionJointDef, b2IFrictionJointDef
} from "./Dynamics/Joints/b2FrictionJoint";

export {
  b2GearJoint, b2GearJointDef, b2IGearJointDef
} from "./Dynamics/Joints/b2GearJoint";

export {
  b2MotorJoint, b2MotorJointDef, b2IMotorJointDef
} from "./Dynamics/Joints/b2MotorJoint";

export {
  b2MouseJoint, b2MouseJointDef, b2IMouseJointDef
} from "./Dynamics/Joints/b2MouseJoint";

export {
  b2PrismaticJoint, b2PrismaticJointDef, b2IPrismaticJointDef
} from "./Dynamics/Joints/b2PrismaticJoint";

export {
  b2PulleyJoint,
  b2PulleyJointDef,
  b2IPulleyJointDef,
  b2_minPulleyLength
} from "./Dynamics/Joints/b2PulleyJoint";

export {
  b2RevoluteJoint, b2RevoluteJointDef, b2IRevoluteJointDef
} from "./Dynamics/Joints/b2RevoluteJoint";

export {
  b2RopeJoint, b2RopeJointDef, b2IRopeJointDef
} from "./Dynamics/Joints/b2RopeJoint";

export {
  b2WeldJoint, b2WeldJointDef, b2IWeldJointDef
} from "./Dynamics/Joints/b2WeldJoint";

export {
  b2WheelJoint, b2WheelJointDef, b2IWheelJointDef
} from "./Dynamics/Joints/b2WheelJoint";

// Controllers
export {
  b2Controller, b2ControllerEdge
} from "./Controllers/b2Controller";

export {
  b2BuoyancyController
} from "./Controllers/b2BuoyancyController";

export {
  b2ConstantAccelController
} from "./Controllers/b2ConstantAccelController";

export {
  b2ConstantForceController
} from "./Controllers/b2ConstantForceController";

export {
  b2GravityController
} from "./Controllers/b2GravityController";

export {
  b2TensorDampingController
} from "./Controllers/b2TensorDampingController";

// Particle
export {
  b2ParticleDef,
  b2ParticleFlag,
  b2IParticleDef,
  b2CalculateParticleIterations,
  b2ParticleHandle
} from "./Particle/b2Particle";

export {
  b2ParticleGroup,
  b2ParticleGroupDef,
  b2ParticleGroupFlag,
  b2IParticleGroupDef
} from "./Particle/b2ParticleGroup";

export {
  b2GrowableBuffer,
  b2ParticleIndex,
  b2FixtureParticleQueryCallback,
  b2ParticleSystem,
  b2ParticleSystemDef,
  b2ParticleContact,
  b2ParticleBodyContact,
  b2ParticlePair,
  b2ParticleTriad,
  b2ParticleSystem_UserOverridableBuffer,
  b2ParticleSystem_Proxy,
  b2ParticleSystem_InsideBoundsEnumerator,
  b2ParticleSystem_ParticleListNode,
  b2ParticleSystem_FixedSetAllocator,
  b2ParticleSystem_FixtureParticle,
  b2ParticleSystem_FixtureParticleSet,
  b2ParticleSystem_ParticlePair,
  b2ParticlePairSet,
  b2ParticleSystem_ConnectionFilter,
  b2ParticleSystem_DestroyParticlesInShapeCallback,
  b2ParticleSystem_JoinParticleGroupsFilter,
  b2ParticleSystem_CompositeShape,
  b2ParticleSystem_ReactiveFilter,
  b2ParticleSystem_UpdateBodyContactsCallback,
  b2ParticleSystem_SolveCollisionCallback,
} from "./Particle/b2ParticleSystem";

// Rope
export {
  b2Rope, b2RopeDef
} from "./Rope/b2Rope";
