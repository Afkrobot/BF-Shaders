//Approximation of Bug Fables "wateroutline.shader" by Afkrobot
//With help from https://gist.github.com/smkplus/49c39ed5e68244c03f86bf455084cdae and therin linked threads as they contains many elements seen in the original shader, albeit modified.

Shader "Custom/WaterOutline" {
	Properties{
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_ShoreLineColor("ShoreLine Color", Vector) = (1,1,1,1)
		_Color("Black Color", Vector) = (0,0,0,0)
		_WaterAlpha("Alpha", Range(0, 1)) = 0.5
		_FadeLimit("Fade Limit", Range(0.01, 1)) = 0.33
		_InvFade("Soft Factor", Range(0.01, 1)) = 1.0
		_ScrollXSpeed("X Scroll Speed", Range(-1, 1)) = 0.1
		_ScrollYSpeed("Y Scroll Speed", Range(-1, 1)) = 0.1
	}
		SubShader{
			LOD 200
			Tags { "RenderType" = "Opaque" }
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMask RGB -1
			ZWrite Off
			Pass{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"


				struct appdata {
					float4 vertex : POSITION;
					float3 texcoord : TEXCOORD0;
				};

				struct v2f {
					float4 pos : POSITION;
					float4 color : COLOR;
					float3 uv : TEXCOORD0;
				};

				uniform sampler2D _MainTex;
				uniform sampler2D _CameraDepthTexture;
				uniform float4 _ShoreLineColor;
				uniform float4 _Color;
				uniform float _WaterAlpha;
				uniform float _FadeLimit;
				uniform float _InvFade;
				uniform float _ScrollXSpeed;
				uniform float _ScrollYSpeed;

				v2f vert(appdata v) {
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex); //Establishes vertex position
					v.texcoord.xy = v.texcoord.xy + frac(_Time.y * float2(_ScrollXSpeed, _ScrollYSpeed)); //scrolls the uv coordinates up for scrolling
					o.uv = float4(v.texcoord.xy*2, 0, 0); //sets the uv coordinates, we do *2 to make the texture smaller, as it is in the original
					return o;
				}

				half4 frag(v2f i) : SV_Target{
					//In this block we calculate the intersection with any objects, so that we can draw the shoreline there
					float2 screenuv = i.pos.xy / _ScreenParams.xy;
					float screenDepth = Linear01Depth(tex2D(_CameraDepthTexture, screenuv));
					float diff = screenDepth - Linear01Depth(i.pos.z);
					float intersect = 0;
					float intersect2 = 0;
					intersect = 1 - smoothstep(0, _ProjectionParams.w * _FadeLimit, diff);
					intersect2 = 1 - smoothstep(0, 0.1, diff);
					if (intersect != 0) {
						//If there is intersection, draw the shore
						return _ShoreLineColor;
					}
					if (intersect2 != 0) {
						fixed4 col = tex2D(_MainTex, i.uv.xy);
						col.xyz = col.xyz * _WaterAlpha + _Color.xyz * (1 - _WaterAlpha);
						col.a = 1;
						return col;
					}
					return _Color;
				}
				ENDCG
			}
		}
}