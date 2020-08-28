
//As found on:
//http://wiki.unity3d.com/index.php/3DText

Shader "Custom/3D Text Shader"
{
    Properties
    {
        _MainTex("Font Texture", 2D) = "white" {}
        _Color("Text Color", Vector) = (1,1,1,1)
    }
        SubShader
        {
            Tags {  "IGNOREPROJECTOR" = "true"
                    "QUEUE" = "Transparent"
                    "RenderType" = "Transparent" }
            //LOD 100
            Blend SrcAlpha OneMinusSrcAlpha
            Lighting Off Cull Off ZWrite Off Fog { Mode Off }

            Pass
            {
                Color[_Color]
                SetTexture[_MainTex] {
                    combine primary, texture * primary
                }
            }
        }
}
