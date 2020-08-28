# BF-Shaders
TSome of the shaders used for the game "Bug Fables", recovered through googling and by reverse engineering with help of the shader decomp produced by uTinyRipper.
## Shaders and usage
### 3dtext.shader
Used on all the text in the game, is connected to the 3 fonts. Makes the text layer over everything else, making it unaffected by lighting effects and fog.
### customtoon2.shader
Used on most 3D Objects, makes the Unity lighting hitting the object appear cel shaded.
### fxaa3.shader
Overwrites Unitys standard FXAA, provides the FXAA (Shader based anti aliasing) when turned on in the settings. Requires the provided Fxaa3_9.cginc file.
### outlineold2u5ready.shader
Used on most 3D Objects, draws the object outline.
### alpha-diffuse.shader
Used on ShadowCaster.mat, makes the alpha of textures transparent. I don't know where the .mat is used or why this is necessary, but I included it anyway in case its important.

More shaders are in the works..