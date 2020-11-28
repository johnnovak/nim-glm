# nim-glm

*Nim port of the C++ [OpenGL Mathematics (GLM) library](https://github.com/g-truc/glm) for graphics based on the [OpenGL Shading Language (GLSL)](https://www.khronos.org/registry/OpenGL/specs/gl/GLSLangSpec.4.50.pdf) specification*


## Quickstart & feature highlights

- **Vector creation & operations**

```nim
import glm

let
  v = vec3(1.0, 5.0, 6.0)
  a = vec3(2.0, 2.0, 5.0)
  v4 = vec4(v, 1.0);
  c = cross(v, a)
  m = mat4().rotate(5.0, vec3(1.0, 0.0, 0.0))
  r = v4 * m
```


- **Matrix creation & operations**

```nim
import glm

let
  eye = vec3(50.0, 50.0, 10.0)
  center = vec3(0.0)
  up = vec3(0.0, 1.0, 0.0)
  viewMatrix = lookAt(eye, center, up)
  projectionMatrix = perspective(math.PI/2, 1.0, 0.01, 100.0)

echo viewMatrix * projectionMatrix
```


- **Full compatbility with OpenGL**

```nim
import glm

var modelView = mat4f(1)
  .rotate(alpha, n.x, n.y, n.z)
  .scale(4,5,6)
  .translate(1,2,3)

glUniformMatrix4fv(_uniformLocation, 1, false, modelView.caddr)
```


- **Swizzling support**

```nim
import glm

var pos1, pos2: Vec4f
pos1.xyz = pos2.zww
pos1.yz += pos2.ww

var texcoord: Vec2f
echo texcoord.st

var color: Vec4f
color.rgb = color.bgr
```

- **Pretty-printing matrices**

Matrices can be printed with `echo` because they have the `$` operator
implemented. By default, they use nice Unicode characters for best visual
representation. But if you have problems with that, you can pass the
``-d:noUnicode`` option to the compiler to use ASCII characters instead
(this is the default on Windows).

```
      ASCII              Unicode

 / 3  7   3   0 \     ⎡3  7   3   0⎤
|  0  2  -1   1  |    ⎢0  2  -1   1⎥
|  5  4   3   2  |    ⎢5  4   3   2⎥
 \ 6  6   4  -1 /     ⎣6  6   4  -1⎦

 ```

- **Perlin noise generation**

```nim
import glm/vec
import glm/noise

var line = newStringOfCap(80)
for y in 0..<20:
  for x in 0..<40:
    let n = perlin(vec2f(float32(x), float32(y)) * 0.1'f32)
    let i = int(floor((n + 1) * 5))
    line.add "  .:+=*%#@"[i]
  echo line
  line.setLen(0)
```

Expected output:

```
=+++:::::+======++++==*%%%%**==++++++++=
===++::::++====++::++=*%%%%%*===++++:+++
***=+::.::+====++:::+==*%%%%***==++:::::
***=+:...:++===++:::++==**%%*****=++:...
**=+::...::+====++:::+++==********=+:.
*==+:....::+=====++:::::++==******=+:.
==+:..  .::+=****=++:::::::+==*****=+:.
=+:..   .:++=*%%**=++::....:+==**%**=+:.
++:.   ..:+=*%%%%**=+:..   .:+=**%%**=+:
++:.   .::+=*%###%*=+::.   .:+==*%%%**=+
=+:..  .:+==*%###%*==+:.   .:+==*%%%%*==
=++:....:+=**%###%**=+:.    .:+=*%%#%%*=
==+::..:++=*%%####%*=+:.    .:+=*%%#%%**
*==+:::++==*%%####%**=+:.   .:+==*%%%%**
**==++++==***%%##%%%**=+:....::+=*****==
%**======******%%%%%%**=+:....:++=***==+
***===*****====****%%%*=+::...:++====+++
**===*****==++++==******=+::.::++====++:
*====*****=++:::++==****=+::::+++====++:
==++==***==+::..::+======++::+++======++
```

## Differences to the original C++ GLM library and GLSL

- The `mod` function is called `floorMod` instead to make it consistent with
  the Nim standard library.
  - Explanation: `mod` is already an operator in Nim that has its own
    meaning that is very different to the meaning of the `mod` function in
    GLSL. The name `fmod` is not good either because `fmod` in C++ has
    a different meaning as well. The function `floorMod` from the ``math``
    package has the same meaning as the `mod` function in GLSL. Note that the
    `mod` operator always rounds towards zero; I personally recommend to
   never use this operator.

- Swizzling support. Unlike C++, Nim make it pretty easy to implement
  swizzling. Note that `rgba` and `stpq` swizzling is off by default. They
  can be enabled with the `GLM_SWIZZLE_OPS_RGBA` and `GLM_SWIZZLE_OPS_STPQ`
  compiler flags, respectively. This is to avoid name clashes with other
  libraries.

- SIMD optimisations are not implemented. One could hope that someday
  C compilers will be smart enough to do such optimisations automatically,
  but I would not bet on it.

- The C++ GLM library has a lot more extensions that are not yet ported
  over. They will be added when needed. On the other hand, this library is
  feature complete in terms of GLSL features.

