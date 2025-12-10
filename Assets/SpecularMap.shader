Shader "Unlit/SpecularMap"
{
    Properties
    {
        _MaskTex ("Texture", 2D) = "black" {}
    }
    SubShader
    {
        

        Pass
        {
            CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;

				float3 normal : NORMAL;
            };

            struct v2f
            {
               float4 vertex : SV_POSITION;
               float2 uv : TEXCOORD0;

               float3 normal : NORMAL;
               float3 worldPosition : TEXCOORD1;
            };

            sampler2D _MaskTex;
            float4 _MaskTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.uv = v.uv;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.worldPosition = mul(unity_ObjectToWorld,v.vertex);
				return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
               float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);
               float3 lightDir = normalize(_WorldSpaceLightPos0);
               i.normal = normalize(i.normal);
               float3 reflectDir = -lightDir + 2 * i.normal * dot(i.normal, lightDir);


               
               fixed4 specular = pow(saturate(dot(reflectDir, eyeDir)), 7.5) * _LightColor0;

               fixed4 maskColor = tex2D(_MaskTex , i.uv * _MaskTex_ST.xy);

               return maskColor.r * specular;
            }
            ENDCG
        }
    }
}
