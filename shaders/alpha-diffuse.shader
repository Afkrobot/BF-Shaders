//As found on:
//https://answers.unity.com/questions/448992/transparentdiffuse-shader-always-transparent-by-de.html
//This is basically just the legacy Transparent/Diffuse.
//Why was this a custom shader? I don't know, may have been the fallback. but I can not tell, using the "Standard"-shader would have done it aswell.

//Shader "Custom/Transparent/Diffuse" {
Shader "Transparent/Cutout/Diffuse" {
    Properties{
        _Color("Main Color", Color) = (1,1,1,1)
        _MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
    }

        SubShader{
            Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
            LOD 200

        CGPROGRAM
            #pragma surface surf Lambert alpha

            sampler2D _MainTex;
            fixed4 _Color;

            struct Input {
                float2 uv_MainTex;
            };

            void surf(Input IN, inout SurfaceOutput o) {
                fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
                o.Albedo = c.rgb;
                o.Alpha = c.a;
            }
        ENDCG
    }

        Fallback "Legacy Shaders/Transparent/VertexLit"
}