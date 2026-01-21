Shader "Unlit/08"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
               float3 worldPosition : TEXCOORD1;
            };

            struct v2f
            {
               float4 vertex : SV_POSITION;
               float2 uv : TEXCOORD0;

               float3 normal : NORMAL;
               float3 worldPosition : TEXCOORD1;

            };
            
            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                o.normal = UnityObjectToWorldNormal(v.normal);
				o.worldPosition = mul(unity_ObjectToWorld,v.vertex);
                
                return o;
            }

            sampler2D _NormalTex;

            fixed4 frag (v2f i) : SV_Target
            {
               float4 nMap = tex2D(_NormalTex,i.uv) * 2 - 1;
               float3 normal = normalize(nMap.xyz);
               float intensity = saturate(dot(normal,_WorldSpaceLightPos0));


               fixed4 col = tex2D(_MainTex, i.uv );
               fixed4 color = col;
               fixed4 ambient = col * 0.3 * _LightColor0;
               fixed4 diffuse = color * intensity * _LightColor0;


               float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);
               float3 lightDir = normalize(_WorldSpaceLightPos0);
               i.normal = normalize(i.normal);
               float3 reflectDir = -lightDir + 2 * i.normal * dot(i.normal, lightDir);
               fixed4 specular = pow(saturate(dot(reflectDir, eyeDir)), 20) * _LightColor0;

               fixed4 phong = ambient + diffuse + specular;

               return phong;

            }
            ENDCG
        }
    }
}
