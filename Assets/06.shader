Shader "Unlit/06"
{
    Properties
    {
        _Color("Color", Color) = (1,0,0,1)
    }
    SubShader
    {
        

        Pass
        {
            Stencil
            {
                Ref 1
                Comp NotEqual
             }


            CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			fixed4 _Color;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float3 worldPosition : TEXCOORD1;
			};
			
			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.worldPosition = mul(unity_ObjectToWorld,v.vertex);
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target
			{

				float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);
                float3 lightDir = normalize(_WorldSpaceLightPos0);
                i.normal = normalize(i.normal);
                float3 reflectDir = -lightDir + 2 * i.normal * dot(i.normal, lightDir);
                fixed4 specular = pow(saturate(dot(reflectDir, eyeDir)), 20) * _LightColor0;

                fixed4 ambient = _Color * 0.3 * _LightColor0;

                float intensity =  saturate(dot(normalize(i.normal), _WorldSpaceLightPos0));
                fixed4 color = _Color;
                fixed4 diffuse = color * intensity * _LightColor0;

                fixed4 phong = ambient + diffuse + specular;

                return phong;
			}	
			ENDCG
        }
        Pass
        {
            Tags{ "Queue" = "Geometry+1" }

            Stencil
            {
                Ref 1
                Comp Equal
            }

            ztest always

            CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include"UnityCG.cginc"

			float4 vert(float4 v:POSITION):SV_POSITION
			{
				float4 o;
				o = UnityObjectToClipPos(v);
				return o;
			}

			fixed4 frag(float4 i:SV_POSITION) : SV_TARGET
			{
				
				fixed4 o = fixed4(1,1,0,1);
				return o;

			}
			ENDCG
        }
        
    }
    
}
