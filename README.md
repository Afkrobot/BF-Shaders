# BF-Shaders
Some of the shaders used for the game "Bug Fables", recovered through googling and by reverse engineering with help of the shader decomp produced by uTinyRipper.
## Shaders and usage
### 3dtext.shader
Used on all the text in the game, is connected to the 3 fonts. Makes the text layer itself over everything else, making it unaffected by lighting effects and fog.
### customtoon2.shader
Used on most 3D Objects, makes the Unity lighting hitting the object appear cel shaded.
### fxaa3.shader
Overwrites Unitys standard FXAA, produces the FXAA (Shader based anti aliasing) when turned on in the game settings. Requires the provided Fxaa3_9.cginc file.
### outlineold2u5ready.shader
Used on most 3D objects, draws the object outline.

More shaders are in the works..
