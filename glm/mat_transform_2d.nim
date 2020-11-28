when not compiles(SomeFloat):
  type SomeFloat = SomeReal

import globals
import mat
import vec


proc translateInpl*[T](m: var Mat3[T]; v: Vec2[T]): void {.inline.} =
  m[2] = m * vec3(v, 1)

proc translateInpl*[T](m: var Mat3[T]; x,y: T): void {.inline.} =
  m.translateInpl(vec2(x,y))

proc translate*[T](m: Mat3[T]; v: Vec2[T]): Mat4[T] {.inline.} =
  result = m
  result.translateInpl(v)

proc translate*[T](m: Mat3[T]; x,y: T): Mat3[T] {.inline.} =
  result = m
  result.translateInpl(vec2(x,y))


proc rotateInpl*[T](m: var Mat3x3[T], angle: T): void {.inline.} =
  m = m.rotate(angle)

proc rotate*[T](m: Mat3x3[T], angle: T): Mat3x3[T] {.inline.} =
  let
    a = angle
    c = cos(a)
    s = sin(a)

  var R = mat3[T](1)
  R[0,0] = c
  R[0,1] = -s
  R[1,0] = s
  R[1,1] = c

  result = R * m


proc scaleInpl*[T](m: var Mat3[T], v: Vec2[T]): void {.inline.} =
  m[0] *= v[0]
  m[1] *= v[1]

proc scaleInpl*[T](m: var Mat3[T], x,y: T): void {.inline.} =
  m[0] *= x
  m[1] *= y

proc scaleInpl*[T](m: var Mat3[T], s: T): void {.inline.} =
  m[0] *= s
  m[1] *= s

proc scale*[T](m: Mat3[T], v: Vec2[T]): Mat3x3[T] {.inline.} =
  result = m
  result.scaleInpl(v)

proc scale*[T](m: Mat3[T], x,y: T): Mat3[T] {.inline.} =
  result = m
  result.scaleInpl(x,y)

proc scale*[T](m: Mat3[T], s: T): Mat3[T] {.inline.} =
  result = m
  result.scaleInpl(s)


when isMainModule:
  import math

  var m = mat3d()
  echo "TRANSLATE\N"
  echo m
  echo m.translate(2,5).translate(-1,-1)
  m.translateInpl(vec2(-5.0, -8.0))
  echo m
  m.translateInpl(-3.0, -2.0)
  echo m

  echo "SCALE\N"
  echo m.scale(2,3)
  m.scaleInpl(0.5, 0.2)
  echo m
  m.scaleInpl(100)
  echo m

  echo "ROTATE\N"
  echo m.rotate(degToRad(90.0))
  m.rotateInpl(degToRad(180.0))
  echo m


