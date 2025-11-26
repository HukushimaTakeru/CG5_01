Shader "Unlit/AlphaBlend"
{
	 Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }


	SubShader
	{
		Tags
		{

			"Queue" = "Transparent"

		}

		Blend SrcAlpha OneMinusSrcAlpha

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

			v2f vert(appdata v)
			{
				v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;


				
				o.normal = UnityObjectToWorldNormal(v.normal);
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target
			{

				float2 tiling = _MainTex_ST.xy;
                float2 offset = _MainTex_ST.zw;
                fixed4 col = tex2D(_MainTex, i.uv* tiling + offset);

				fixed4 o = fixed4(1,0,0,0.3);

				return col;
			}	
			ENDCG
		}
	}
}
