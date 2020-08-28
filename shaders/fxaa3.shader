
//As found on:
//https://gist.github.com/demonixis/1f5e53812bf8fdc8d6d6ae8a5e7f2f44

Shader "Hidden/FXAA3" {
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
	}
		SubShader{
			Pass {
				ZTest Always Cull Off ZWrite Off
				Fog { Mode off }

				CGPROGRAM
					#pragma vertex vert
					#pragma fragment frag
					#pragma fragmentoption ARB_precision_hint_fastest
					#pragma target 3.0
					#pragma glsl

					#include "UnityCG.cginc"

					#define FXAA_PC
					#define FXAA_HLSL_3
					#define FXAA_EARLY_EXIT 0
					#include "Fxaa3_9.cginc"

					uniform sampler2D _MainTex;
					uniform float4 _MainTex_TexelSize;
					uniform float4 _rcpFrame;
					uniform float4 _rcpFrameOpt;
					half4 _MainTex_ST;

					struct v2f {
						float4 pos : POSITION;
						float2 uv : TEXCOORD0;
						float4 uvAux : TEXCOORD1;
					};

					v2f vert(appdata_img v)
					{
						v2f o;
						o.pos = UnityObjectToClipPos(v.vertex);

						float2 uv = v.texcoord.xy;

						o.uv = uv;
						o.uvAux.xy = uv + float2(-_MainTex_TexelSize.x, +_MainTex_TexelSize.y) * 0.5f;
						o.uvAux.zw = uv + float2(+_MainTex_TexelSize.x, -_MainTex_TexelSize.y) * 0.5f;

						return o;
					}

					half4 frag(v2f i) : COLOR
					{
		#if UNITY_SINGLE_PASS_STEREO
						i.uv = UnityStereoScreenSpaceUVAdjust(i.uv, _MainTex_ST);
		#endif

						return FxaaPixelShader_Quality(
							i.uv,
							i.uvAux,
							_MainTex,
							_rcpFrame.xy,
							_rcpFrameOpt);
					}
				ENDCG
			}
	}

		Fallback off

}