import raylib, rlgl, raymath, rmem, reasings, rcamera
import firnas
import firnas/plugin

const
  screenWidth = 800
  screenHeight = 450

proc testLoadImage() =
  try:
    let image = loadImage("test_image.png")
  except RaylibError:
    echo "Error loading image"

proc testDrawTextWithFont() =
  let font = getFontDefault()
  let position = raylib.Vector2(x: 200, y: 200)
  drawText(font, "Hello with custom font", position, 24, 2, DarkGray)


var box = newBody(bodyType = characterBody, bodyShape = circle, position = firnas.Vector2(x: 3, y:3))

proc main =
  initWindow(screenWidth, screenHeight, "firnas")
  setTargetFPS(60)
  testLoadImage()
  testDrawTextWithFont()
  let speed = 10
  while not windowShouldClose():
    updatePhysics()
    beginDrawing()
    clearBackground(RayWhite)
    drawBody(box, Red)
    if isKeyDown(KeyboardKey.D):
      box.velocity.x = firnas.Vector2.x(speed)
    elif isKeyDown(KeyboardKey.A):
      box.velocity.x = firnas.Vector2.x(-speed)
    else:
      box.velocity.x = firnas.Vector2.x(0)

    if isKeyDown(KeyboardKey.W):
      box.velocity.y = firnas.Vector2.y(-speed)
    elif isKeyDown(KeyboardKey.S):
      box.velocity.y = firnas.Vector2.y(speed)
    else:
      box.velocity.y = firnas.Vector2.y(0)

    if ( isKeyDown(KeyboardKey.W) or isKeyDown(KeyboardKey.S) ) and ( isKeyDown(KeyboardKey.D) or isKeyDown(KeyboardKey.A) ):
      box.velocity = box.velocity.normalized() * speed


    drawText("Congrats! You created your first window!", 190, 200, 20, LightGray)
    endDrawing()

  closeWindow()

main()