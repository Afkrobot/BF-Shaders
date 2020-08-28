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
Used on most 3D Objects, draws the object outline.
### alpha-diffuse.shader
Used on ShadowCaster.mat, makes the alpha of textures transparent. I don't know where the .mat is used or why this is necessary, but I included it anyway in case its important.
### alpha-diffusedoublesided.shader
Same as above but for materials that are applied to both sides of a mesh. (namely just the spoder material (Material.5_0.mat))
### hologram.shader
Used on "No Name 1_0.mat", and, presumably, all other holograms.
### hologram2.shader
Used for the glitch effect on holograms (and I believe computer text bubbles), also that scanner thing when you enter the bee factory for the first time.

More shaders are in the works..
