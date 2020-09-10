//Edited version of shader found on:
//https://answers.unity.com/questions/1681242/crt-shader-but-not-for-camera-1.html
//Who probably got it from:
//http://wordpress.notargs.com/blog/blog/2016/01/09/unity3d%E3%83%96%E3%83%A9%E3%82%A6%E3%83%B3%E7%AE%A1%E9%A2%A8%E3%82%B7%E3%82%A7%E3%83%BC%E3%83%80%E3%83%BC%E3%82%92%E4%BD%9C%E3%81%A3%E3%81%9F/

//Edited by Afkrobot
//Comment:  This is as close as I can get to the ingame shader without actually being able to swap them ingame for testing.
//          I will revisit this once I am done with my full Bug Fables decomp and can test it in the editor. Until then, here you go.

Shader "PostEffects/CRT"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _NoiseX("NoiseX", Range(0, 1)) = 0
        _Offset("Offset", Vector) = (0, 0, 0, 0)
        _RGBNoise("RGBNoise", Range(0, 1)) = 0
        _SinNoiseWidth("SineNoiseWidth", Float) = 1
        _SinNoiseScale("SinNoiseScale", Float) = 1
        _SinNoiseOffset("SinNoiseOffset", Float) = 1
        _ScanLineTail("Tail", Float) = 0.5
        _ScanLineSpeed("TailSpeed", Float) = 100
        //Added vars
            _ScreenSize("Screen Size", Float) = 0.15
            _Darkening("Corner Darkness", Float) = 0.5

            //No idea what these two were supposed to do, maybe set max opacity for the scan line? But then why 4 as max range?
            //Anyhow, we don't have to implement them as the game does not use scanlines, therefore the implementation would be in commented out code.
            //If anyone wants to take a shot at finding the intended use for these, go ahead. and hit me up tho.
            _ScanLineDarker("Scan Line Opacity", Range(0, 4)) = 4
            _ScanLineDarker2("Scan Line Opacity 2", Range(0, 1)) = 0.5
    }
        SubShader
        {
            // No culling or depth
            Cull Off ZWrite Off ZTest Always

            Pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma target 3.0

                #include "UnityCG.cginc"

                struct appdata
                {
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct v2f
                {
                    float2 uv : TEXCOORD0;
                    float4 vertex : SV_POSITION;
                };

                v2f vert(appdata v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = v.uv;
                    return o;
                }

                float rand(float2 co) {
                    return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
                }

                float2 mod(float2 a, float2 b)
                {
                    return a - floor(a / b) * b;
                }
                sampler2D _MainTex;
                float _NoiseX;
                float2 _Offset;
                float _RGBNoise;
                float _SinNoiseWidth;
                float _SinNoiseScale;
                float _SinNoiseOffset;
                float _ScanLineTail;
                float _ScanLineSpeed;
                float _ScreenSize;
                float _Darkening;
                //float _ScanLineDarker;
                //float _ScanLineDarker2;

                fixed4 frag(v2f i) : SV_Target
                {
                    float2 inUV = i.uv;
                    float2 uv = i.uv - 0.5;

                    float vignet = length(uv);
                    uv /= 1 - vignet * _ScreenSize;
                    float2 texUV = uv + 0.5;

                    if (max(abs(uv.y) - 0.5, abs(uv.x) - 0.5) > 0)
                    {
                        return float4(0, 0, 0, 1);
                    }

                    float3 col;

                    texUV.x += sin(texUV.y * _SinNoiseWidth + _SinNoiseOffset) * _SinNoiseScale;
                    texUV += _Offset;
                    texUV.x += (rand(floor(texUV.y * 500) + _Time.y) - 0.5) * _NoiseX;
                    texUV = mod(texUV, 1);

                    col.r = tex2D(_MainTex, texUV).r;
                    col.g = tex2D(_MainTex, texUV - float2(0.002, 0)).g;
                    col.b = tex2D(_MainTex, texUV - float2(0.004, 0)).b;

                    //Removed due to RGBNoise never being used ingame. Reduces number of shader variants.

                    /*if (rand((rand(floor(texUV.y * 500) + _Time.y) - 0.5) + _Time.y) < _RGBNoise)
                    {
                        col.r = rand(uv + float2(123 + _Time.y, 0));
                        col.g = rand(uv + float2(123 + _Time.y, 1));
                        col.b = rand(uv + float2(123 + _Time.y, 2));
                    }*/

                    float floorX = fmod(inUV.x * _ScreenParams.x / 3, 1);
                    col.r *= floorX > 0.3333;
                    col.g *= floorX < 0.3333 || floorX > 0.6666;
                    col.b *= floorX < 0.6666;

                    //Removed due to scan lines never being used ingame. 

                    /*float scanLineColor = sin(_Time.y * 10 + uv.y * 500) / 2 + 0.5;
                    col *= 0.5 + clamp(scanLineColor + 0.5, 0, 1) * 0.5;

                    float tail = clamp((frac(uv.y + _Time.y * _ScanLineSpeed) - 1 + _ScanLineTail) / min(_ScanLineTail, 1), 0, 1);
                    col *= tail;*/

                    col *= 1 - vignet * _Darkening;

                    return float4(col, 1);
                }
                ENDCG
            }
        }
}