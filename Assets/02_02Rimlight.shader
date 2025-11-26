Shader "Unlit/02_02Rimlight"
{
	Properties
    {
        _Color("Color", Color) = (1,0,0,1)
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

				//fixed4 rim = pow(dot(i.normal,eyeDir),1);
				fixed4 rim = pow (1.0 - saturate(dot(eyeDir, i.normal)),5);

                float3 reflectDir = -lightDir + 2 * i.normal * dot(i.normal, lightDir);
                fixed4 specular = pow(saturate(dot(reflectDir, eyeDir)), 20) * _LightColor0;

                fixed4 ambient = _Color * 0.3 * _LightColor0;

                float intensity =  saturate(dot(normalize(i.normal), _WorldSpaceLightPos0));
				intensity = step(0.5,intensity);
                fixed4 color = _Color;
                fixed4 diffuse = color * intensity * _LightColor0 ;

                fixed4 phong = ambient + diffuse + specular;

                return rim;
			}	
			ENDCG
		}
		
	}
}
