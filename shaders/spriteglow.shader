//As found here:
//https://forum.unity.com/threads/looking-for-glow-effect-for-sprites-mobile-friendly.427824/
//Original thread unfortunately got deleted.

Shader "Sprites/Cheap Outer Glow"
{
    Properties
    {
        [PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
        _Color("Tint", Color) = (1,1,1,1)
        _GlowScale("Glow Scale", Range(0,1)) = 1
        _GlowColor("Glow Color", Color) = (1,1,1,1)
        [MaterialToggle] PixelSnap("Pixel snap", Float) = 0
    }

        SubShader
        {
            Tags
            {
                "Queue" = "Transparent"
                "IgnoreProjector" = "True"
                "RenderType" = "Transparent"
                "PreviewType" = "Plane"
                "CanUseSpriteAtlas" = "True"
            }

            Cull Off
            Lighting Off
            ZWrite Off
            Blend One OneMinusSrcAlpha

            Pass
            {
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma target 2.0
                #pragma multi_compile _ PIXELSNAP_ON
                #pragma multi_compile _ ETC1_EXTERNAL_ALPHA
                #include "UnityCG.cginc"

                struct appdata_t
                {
                    float4 vertex   : POSITION;
                    float4 color    : COLOR;
                    float2 texcoord : TEXCOORD0;
                };

                struct v2f
                {
                    float4 vertex   : SV_POSITION;
                    fixed4 color : COLOR;
                    float2 texcoord  : TEXCOORD0;
                };

                fixed4 _Color;

                v2f vert(appdata_t IN)
                {
                    v2f OUT;
                    OUT.vertex = UnityObjectToClipPos(IN.vertex);
                    OUT.texcoord = IN.texcoord;
                    OUT.color = IN.color * _Color;
                    #ifdef PIXELSNAP_ON
                    OUT.vertex = UnityPixelSnap(OUT.vertex);
                    #endif

                    return OUT;
                }

                sampler2D _MainTex;
                sampler2D _AlphaTex;

                fixed _GlowScale;
                fixed4 _GlowColor;

                fixed4 SampleSpriteTexture(float2 uv)
                {
                    fixed4 color = tex2D(_MainTex, uv);

    #if ETC1_EXTERNAL_ALPHA
                    // get the color from an external texture (usecase: Alpha support for ETC1 on android)
                    color.a = tex2D(_AlphaTex, uv).r;
    #endif //ETC1_EXTERNAL_ALPHA

                    return color;
                }

                fixed4 frag(v2f IN) : SV_Target
                {
                    fixed4 c = SampleSpriteTexture(IN.texcoord) * IN.color;

                // Use alpha assuming glow is a gradient from 0.0 to ~0.75% alpha, and the rest is the sprite.
                fixed spriteAlpha = saturate(c.a * 4.0 - 3.0);
                fixed glowAlpha = saturate(1.0 - (1.0 - c.a / 0.75) / max(_GlowScale, 0.01)) * saturate(_GlowScale * 32.0);
                c.a = max(spriteAlpha, glowAlpha * _GlowColor.a);
                c.rgb = lerp(_GlowColor.rgb, c.rgb, 1.0 - (1.0 - saturate(spriteAlpha / max(_GlowColor.a, 0.01))) * saturate(_GlowScale * 32.0));

                c.rgb *= c.a;
                return c;
            }
        ENDCG
        }
        }
}