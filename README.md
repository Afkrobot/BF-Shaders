# BF-Shaders
Some of the shaders used for the game "Bug Fables", recovered through googling and by reverse engineering with help of the shader decomp produced by uTinyRipper.
## Shaders and usage
### 3dtext.shader
Used on all the text in the game, is connected to the 3 fonts. Makes the text layer itself over everything else, making it unaffected by lighting effects and fog.
### alpha-diffuse.shader
Used on ShadowCaster.mat, makes the alpha of textures transparent. I don't know where the .mat is used or why this is necessary, but I included it anyway in case its important.
### alpha-diffusedoublesided.shader
Same as above but for materials that are applied to both sides of a mesh. (namely just the spoder material (Material.5_0.mat))
### customsprite.shader
Used for most of the sprites ingame.
### customtoon2.shader
Used on most 3D Objects, makes the Unity lighting hitting the object appear cel shaded.
### fireshader.shader
Probably what was used for the effect on getting the "Burn" status.
### fxaa3.shader
Overwrites Unitys standard FXAA, produces the FXAA (Shader based anti aliasing) when turned on in the game settings. Requires the provided Fxaa3_9.cginc file.
### grayscalesprite.shader
Used for grayscaling sprites, not sure where exactly in game this is required.
### hologram.shader
Used on "No Name 1_0.mat", and, presumably, all other 2D holograms.
### hologram2.shader
Used for the glitch effect on holograms (and I believe computer text bubbles), also that scanner thing when you enter the bee factory for the first time.
### outline.shader
Apparently a test shader for the outline, was not used except for on one material (Material_0). I have no idea where that is used so to make sure I included this here too.
### outlineold2u5ready.shader
Used on most 3D Objects, draws the object outline.
### spriteglow.shader
When sprites glow in this game, this is the shader they do it with.
### stencilsphere.shader
Not entirely sure, used on some textures (main2, so probably quite a few objects) like the roach cave drawings or thorns. Not entirely sure why stencils though.
### unlitfog.shader
The unlit standard shader but with fog removed, used for the Omega eye, fire sprites and some material relating to the fridge.
### unlittexcolor.shader
Paints object a single unlit color. Used for the Termacade game sprites.
### wateroutline.shader
Used on most bodies of water to make the texture scroll, render the shoreline and submerged geometry.
### windmovement.shader
Visibly moves foilage in the wind, without actually moving any objects.

## Missing shaders:
crt.shader						//not complete\
celshaderholo.shader			//probably custom\
celshaderholostencil.shader		//probably custom\
customtoon.shader				//not complete\
decal.shader					//not complete\
outersphere.shader				//probably custom\
scrolling bubbles.shader		//probably custom\
stenciltry5.shader				//probably custom\
stenciltry5b.shader				//probably custom\
