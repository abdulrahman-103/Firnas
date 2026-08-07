import std/monotimes
import std/os
import std/math

const Gravity* = 9.80665
var gravity = Gravity
var previousTime, currentTime = float(getMonoTime().ticks()/1000000000)
var frameTime: float
var elapsedTime: float
var dt: float = 1/60
var accumulator = 0.0

type Vector2* = object
  x*, y*: float

proc normalize*(v: var Vector2) =
  let length = sqrt(v.x * v.x + v.y * v.y)
  if length != 0:
    v.x /= length
    v.y /= length

proc normalized*(v: Vector2): Vector2 =
  result = v
  result.normalize()



proc zero*(T: typedesc[Vector2]): Vector2 =
  Vector2(x: 0, y: 0)

proc one*(T: typedesc[Vector2]): Vector2 =
  Vector2(x: 1, y: 1)

proc right*(T: typedesc[Vector2]): Vector2 =
  Vector2(x: 1, y: 0)

proc left*(T: typedesc[Vector2]): Vector2 =
  Vector2(x: -1, y: 0)

proc up*(T: typedesc[Vector2]): Vector2 =
  Vector2(x: 0, y: -1)

proc down*(T: typedesc[Vector2]): Vector2 =
  Vector2(x: 0, y: 1)

# negate
proc `-`*(v: Vector2): Vector2 =
  Vector2(x: -v.x, y: -v.y)

# addition
proc `+`*(a, b: Vector2): Vector2 =
  Vector2(x: a.x + b.x, y: a.y + b.y)

proc `+=`*(a: var Vector2, b: Vector2) =
  a.x += b.x
  a.y += b.y


# subtraction
proc `-`*(a, b: Vector2): Vector2 =
  Vector2(x: a.x - b.x, y: a.y - b.y)

proc `-=`*(a: var Vector2, b: Vector2) =
  a.x -= b.x
  a.y -= b.y


# multiplication
proc `*`*(v: Vector2, f: float): Vector2 =
  Vector2(x: v.x * f, y: v.y * f)

proc `*`*(f: float, v: Vector2): Vector2 =
  v * f

proc `*`*(i: int, v: Vector2): Vector2 =
  v * float(i)

proc `*`*(v: Vector2, i: int): Vector2 =
  v * float(i)

proc `*`*(a, b: Vector2): Vector2 =
  Vector2(x: a.x * b.x, y: a.y * b.y)

proc `*=`*(v: var Vector2, f: float) =
  v.x *= f
  v.y *= f

proc `*=`*(v: var Vector2, i: int) =
  v *= float(i)

proc `*=`*(a: var Vector2, b: Vector2) =
  a.x *= b.x
  a.y *= b.y

# division
proc `/`*(v: Vector2, f: float): Vector2 =
  Vector2(x: v.x / f, y: v.y / f)

proc `/`*(a, b: Vector2): Vector2 =
  Vector2(x: a.x / b.x, y: a.y / b.y)

proc `/=`*(v: var Vector2, f: float) =
  v.x /= f
  v.y /= f

proc `/=`*(a: var Vector2, b: Vector2) =
  a.x /= b.x
  a.y /= b.y


type BodyType* = enum
  staticBody,
  dynamicBody,
  characterBody
  

type BodyShape* = enum
  rectangle,
  circle


type Body* = ref object
  bodyType*: BodyType
  bodyShape*: BodyShape
  radius*: float
  size*: Vector2
  mass: float
  inverseMass: float
  force: Vector2
  position*: Vector2
  velocity*: Vector2
  acceleration*: Vector2
  manualForce: Vector2
  manualImpulse: Vector2
  gravityScale: float

var bodies: seq[Body] = @[]

proc newBody*(bodyType: BodyType = dynamicBody, bodyShape: BodyShape = rectangle, size: Vector2 = Vector2.one, mass: float = 1, position: Vector2 = Vector2.zero, radius: float = 1): Body =
  assert mass > 0
  let inverseMass = 1/mass
  let manualForce: Vector2 = Vector2.zero
  var gravityScale: float
  if bodyType == dynamicBody:
    gravityScale = 1
  else:
    gravityScale = 0

  let body = Body(
    bodyType: bodyType,
    bodyShape: bodyShape,
    size: size,
    mass: mass,
    position: position,
    radius: radius,
    manualForce: manualForce,
    gravityScale: gravityScale,
    inverseMass: inverseMass
  )
  bodies.add(body)
  return body

proc setPhysicsHz*(hz: int) =
  dt = 1/hz

proc getPhysicsHz*(): int =
  int(round(1 / dt))

proc applyForce*(body: Body, force: Vector2) =
  body.manualForce += force

proc applyImpulse*(body: Body, impulse: Vector2) =
  body.manualImpulse += impulse

proc setForce*(body: Body, force: Vector2) =
  body.manualForce = force

proc setGravityScale*(body: Body, scale: float) =
  body.gravityScale = scale
  
proc setGlobalGravity*(new_gravity: float) =
  gravity = new_gravity

proc updateForces() =
  for body in bodies:
    if body.bodyType == dynamicBody:
      body.force = Vector2.zero
      if body.gravityScale > 0:
        let gravity_force = body.mass * gravity
        body.force.y = gravity_force * body.gravityScale
      body.force += body.manualForce
      body.manualForce = Vector2.zero

proc updateAcceleration() =
  for body in bodies:
    if body.bodyType == dynamicBody:
      body.acceleration = body.force * body.inverseMass
  
proc updateVelocity() =
  for body in bodies:
    if body.bodyType == dynamicBody:
      body.velocity += body.acceleration * dt
      body.velocity += body.manualImpulse * body.inverseMass
      body.manualImpulse = Vector2.zero

proc updatePosition() =
  for body in bodies:
    if body.bodyType != staticBody:
      body.position += body.velocity * dt

proc updateAll() = 
  updateForces()
  updateAcceleration()
  updateVelocity()
  updatePosition()

proc updatePhysics*() =
  currentTime = float(getMonoTime().ticks()/1000000000)
  frameTime = currentTime - previousTime
  previousTime = currentTime
  if frameTime > 0.250:
    frameTime = 0.250
  accumulator += frameTime
  while accumulator >= dt:
    updateAll()

    accumulator -= dt

