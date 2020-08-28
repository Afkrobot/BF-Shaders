//As found on:
//https://answers.unity.com/questions/1324253/custom-cel-shaded-unity-shader-not-casting-shadows.html
//Commented out most of the shading steps in LightingCelShadingForward(); as the game does not appear to use them.

Shader "Custom/CelShader7"
{
    Properties
    {
        _Color("Main Color", Color) = (1, 1, 1, 1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
    }

        SubShader
        {
            Tags
            {
                "RenderType" = "Opaque"
            }
            LOD 200

            CGPROGRAM
                #pragma surface surf CelShadingForward fullforwardshadows
                #pragma    target 3.0
                #include "AutoLight.cginc"
                #define UnityStandardBRDFCustom.cginc

                half4 LightingCelShadingForward(SurfaceOutput s, half3 lightDir, half atten)
                {
                    half NdotL = dot(s.Normal, lightDir);
                    if (NdotL <= 0.0) NdotL = 0.14f;
                    //else if (NdotL > 0.0f && NdotL <= 0.1f) NdotL = 0.15f;
                    //else if (NdotL > 0.1f && NdotL <= 0.2f) NdotL = 0.2f;
                    /*else*/ if (NdotL > 0.0f/*0.2f*/ && NdotL <= 0.3f) NdotL = 0.3f;
                    //else if (NdotL > 0.3f && NdotL <= 0.4f) NdotL = 0.4f;
                    else if (NdotL > 0.3f/*0.4f*/ && NdotL <= 0.6f/*0.5f*/) NdotL = 0.5f;
                    //else if (NdotL > 0.5f && NdotL <= 0.6f) NdotL = 0.6f;
                    //else if (NdotL > 0.6f && NdotL <= 0.7f) NdotL = 0.7f;
                    //else if (NdotL > 0.7f && NdotL <= 0.8f) NdotL = 0.8f;
                    //else if (NdotL > 0.8f && NdotL <= 0.9f) NdotL = 0.9f;
                    else NdotL = 1;
                    //NdotL = 0.5f;

                    NdotL = smoothstep(0, 0.625f, NdotL);
                    NdotL /= 2.5f;


                    half4 c;
                    c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten * 2); // THe *2 makes it brighter
                    c.a = s.Alpha;
                    return c;
                }



                sampler2D _MainTex;
                fixed4 _Color;

                struct Input
                {
                    fixed2 uv_MainTex;

                };

                void surf(Input IN, inout SurfaceOutput o) {
                    // Albedo comes from a texture tinted by color
                    fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
                    o.Albedo = c.rgb;
                    o.Alpha = c.a;
                }
            ENDCG
        } // End of Subshader
        FallBack "Diffuse"

}