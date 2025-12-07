Shader "Unlit/04_03"
{
    Properties
    {
        _MaskTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Tags {"LightMode" = "UniversalForward"}

            Cull front

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
             
            };

            sampler2D _MaskTex;
            float4 _MaskTex_ST;
            float _Dissolve;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
               
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 mask = tex2D(_MaskTex,i.uv);
                 _Dissolve = 0.2;
                clip(mask.r-_Dissolve);
                return fixed4(0,1,1,1);
                
            }

            ENDCG

        }

        Pass
        {
            Cull back
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
               float4 vertex : POSITION;
               float2 uv : TEXCOORD0;

            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
             
            };

            sampler2D _MaskTex;
            float4 _MaskTex_ST;
            float _Dissolve;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
               
                return o;
            };

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 mask = tex2D(_MaskTex,i.uv);
                _Dissolve = 0.2;
                clip(mask.r - _Dissolve);

                return mask;
                
            };

            ENDCG

        }


    }
}
